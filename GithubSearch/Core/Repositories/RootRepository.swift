//
//  RootRepository.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RxSwift

struct RootRepository: RepositoryProtocol {
    static var remoteStorage = StorageFactory.default.remoteStorage
    static var localStorage = StorageFactory.default.localStorage
    
    static func authentificate(username: String,
                               password: String,
                               success: @escaping () -> Void,
                               failure: @escaping (DataError) -> Void) {
        self.remoteStorage.authentificate(username: username,
                                          password: password,
                                          success: {
                                            let adapter = TokenRequestAdapter(tokenHeaders: $0)
                                            Constants.Api.defautSessionManager.adapter = adapter
                                            
                                            success()
        }, failure: failure)
    }
    
    static func getPopularSearchResult(parameters: Observable<(searchText: String,
                                                               page: Int,
                                                               perPage: Int)>) -> Observable<[RepoModel]> {
        return parameters.flatMap { (searchText: String, page: Int, perPage: Int) -> Observable<[RepoModel]> in
            guard !searchText.isEmpty else { return .just([]) }
            
            return self
                .remoteStorage
                .getPopularSearchResult(parameters: .just((searchText: searchText,
                                                           page: page,
                                                           perPage: perPage)))
                .map { (first: RepoListModel?, second: RepoListModel?, page: Int, perPage: Int) in
                    let initialIndex = perPage * (page - 1)
                    let firstResults: [RepoModel] = first?.items.enumerated().map {
                        let item = RepoModel(fromServerModel: $1)
                        item.index = $0 + initialIndex
                        
                        return item
                        } ?? []
                    let secondResults: [RepoModel] = second?.items.enumerated().map {
                        let item = RepoModel(fromServerModel: $1)
                        item.index = $0 + initialIndex + firstResults.count
                        
                        return item
                        } ?? []
                    
                    return firstResults + secondResults
                }.do(onNext: { Log.debug.log($0) })
        }
        
    }
    
    static func saveSearchResults(_ results: [RepoModel]) {
        self.localStorage.saveSearchResults(results)
    }
    
    static func getCachedSearchResults() -> Observable<[RepoModel]> {
        return Observable.create { (observer) in
            self.localStorage.getSearchResults(success: { (data: [RepoModel]) in
                observer.onNext(data)
                observer.onCompleted()
            }, failure: observer.onError)
            
            return Disposables.create()
        }
    }
}
