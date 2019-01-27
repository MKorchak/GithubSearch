//
//  SearchRepoViewModel.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchRepoViewModel<T: ViewModelDataProtocol>: RxBaseViewModelProtocol,
                                                           DataContainerProtocol
                                                           where T.ModelType == RepoModel {
    
    // MARK: - Subtypes
    // MARK: BaseViewModel
    
    enum RequestStatus: RequestStatusProtocol, Equatable {
        public typealias Error = DataError
        
        case `default`
        case searchLoading // request now loading
        case success // request success complete
        case nextPageLoading
        case error(Error) // request complete with error
        
        public var isError: Bool {
            switch self {
            case .error:
                return true
            default:
                return false
            }
        }
        
        public var isLoading: Bool {
            return self == .searchLoading || self == .nextPageLoading
        }
        
        public func isError(_ error: Error) -> Bool {
            switch self {
            case .error(let currentError):
                return error.statusCode == currentError.statusCode
                    && error.devMessage == currentError.devMessage
            default:
                return false
            }
        }
        
        public static func ==(lhs: RequestStatus,
                              rhs: RequestStatus) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case (.searchLoading, .searchLoading):
                return true
            case (.nextPageLoading, .nextPageLoading):
                return true
            case (.error(let lError), .error(let rError)):
                return lError == rError
            case (.default, .default):
                return true
            default:
                return false
            }
        }
    }
    
    typealias ModelType = [RepoModel]
    typealias RequestStatusType = RequestStatus
    
    // MARK: - Public properties
    // MARK: BaseViewModel
    
    var requestStatus: Driver<RequestStatus> {
        return _requestStatus
            .asDriver(onErrorRecover: { .just(.error(ErrorHandler.handleError($0))) })
    }
    
    var model: [RepoModel] = []
    private(set) var data: Driver<[T]> = .empty()
    
    // MARK: PaginationProtocol
    
    var currentPage: Int = 1
    var totalPages: Int = 30
    
    // MARK: - Private properties
    
    private let paginationEvent = PublishSubject<Void>()
    private let moveEvent = PublishSubject<(fromIndex: Int, toIndex: Int, initial: [RepoModel])>()
    private let deleteEvent = PublishSubject<(index: Int, initial: [RepoModel])>()
    private let selectEvent = PublishSubject<[RepoModel]>()
    private let _requestStatus = PublishSubject<RequestStatus>()
    
    // MARK: Initializers
    
    init(searchText: ControlProperty<String?>) {
        let parameters = Observable
            .combineLatest(
                searchText
                    .orEmpty
                    .skip(1)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .debounce(0.5, scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .do(onNext: { [weak self] _ in self?._requestStatus.onNext(.searchLoading) })
                    .do(onNext: { [weak self] _ in self?.model.removeAll() })
                    .do(onNext: { _ in self.currentPage = 1 }),
                self.paginationEvent
                    .do(onNext: { [weak self] in self?._requestStatus.onNext(.nextPageLoading) })
                    .startWith(()),
                resultSelector: { [weak self] (text, _) in
                    (searchText: text, page: self?.currentPage ?? 1, perPage: self?.totalPages ?? 30)
                }
        )
        
        let results = RootRepository
            .getPopularSearchResult(parameters: parameters)
            .do(onNext: { [weak self] _ in self?._requestStatus.onNext(.success) },
                onError: { [weak self] in self?._requestStatus.onError(ErrorHandler.handleError($0)) })
        let moved: Observable<[RepoModel]> = self
            .moveEvent
            .map {
                var result = $0.initial
                let item = result[$0.fromIndex]
                item.index = $0.toIndex
                result[$0.toIndex].index = $0.fromIndex
                result.remove(at: $0.fromIndex)
                result.insert(item, at: $0.toIndex)
                
                return result
            }.do(onNext: { [weak self] _ in self?.model.removeAll() })
        let deleted: Observable<[RepoModel]> = self
            .deleteEvent
            .map {
                var result = $0.initial
                result.remove(at: $0.index)
                
                return result
            }.do(onNext: { [weak self] _ in self?.model.removeAll() })
        let selected: Observable<[RepoModel]> = self
            .selectEvent
            .do(onNext: { [weak self] _ in self?.model.removeAll() })
        
        self.data = Observable
            .merge(deleted, moved, results, selected)
            .do(onNext: { [weak self] in self?.set($0) },
                onDispose: { [weak self] in self?._requestStatus.onNext(.default) })
            .do(onNext: { RootRepository.saveSearchResults($0) })
            .startWith(self.model)
            .asDriver(onErrorJustReturn: self.model)
            .map { [weak self] _ in (self?.model ?? []).map(T.init) }
    }
    
    // MARK: - Public methods
    
    func set(_ model: [RepoModel]) {
        self.model = self.model + model
    }
    
    func request(forItemWithIndex index: Int) -> URLRequest? {
        return URL(string: self.model[index].url)
            .map { URLRequest(url: $0) }
            .map {
                self.model[index].viewed = true
                self.selectEvent.onNext(self.model)
                
                return $0
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        self.moveEvent.onNext((fromIndex, toIndex, self.model))
    }
    
    func deleteItem(atIndex index: Int) {
        self.deleteEvent.onNext((index, self.model))
    }
}

// MARK: - SearchRepoViewModel + PaginationProtocol

extension SearchRepoViewModel: PaginationProtocol {
    func getNext() {
        self.currentPage += 1
        self.paginationEvent.onNext(())
    }
}
