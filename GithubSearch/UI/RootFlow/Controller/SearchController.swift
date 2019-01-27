//
//  SearchController.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: BaseViewController {
    
    @IBOutlet weak private var searchBar: SearchBar!
    @IBOutlet weak private var viewContent: SearchResultsView!
    
    lazy var switchText = self
    
    private lazy var viewModel = SearchRepoViewModel<RepoViewModelData>(searchText: self.searchBar.rx.text)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.set(data: self.viewModel.data)
        self.configureRx()
    }
    
    private func configureRx() {
        self.bindItemMove().disposed(by: self.disposeBag)
        self.bindRequestStatus().disposed(by: self.disposeBag)
        self.bindPagination().disposed(by: self.disposeBag)
        self.bindItemDelete().disposed(by: self.disposeBag)
        self.bindCancelAction().disposed(by: self.disposeBag)
        self.bindItemSelected().disposed(by: self.disposeBag)
    }
    
    private func bindRequestStatus() -> Disposable {
        return self.viewModel.requestStatus.drive(onNext: { [weak self] in
            switch $0 {
            case .searchLoading:
                self?.searchBar.isLoading = true
                self?.viewContent.isLoading = false
            case .error(let error):
                Log.error.log(error)
                self?.searchBar.isLoading = false
                self?.viewContent.isLoading = false
            case .nextPageLoading:
                self?.searchBar.isLoading = false
                self?.viewContent.isLoading = true
            default:
                self?.searchBar.isLoading = false
                self?.viewContent.isLoading = false
            }
        })
    }
    
    private func bindItemMove() -> Disposable {
        return self
            .viewContent
            .rx
            .moveAction
            .bind { [weak self] in self?.viewModel.moveItem(from: $0.fromIndex,
                                                            to: $0.toIndex) }
    }
    
    private func bindItemDelete() -> Disposable {
        return self
            .viewContent
            .rx
            .deleteIndexAction
            .bind { [weak self] in self?.viewModel.deleteItem(atIndex: $0) }
    }
    
    private func bindItemSelected() -> Disposable {
        return self
            .viewContent
            .rx
            .selectIndexAction
            .bind { [weak self] in
                (self?.viewModel.request(forItemWithIndex: $0)).run {
                    let vc = Storyboard.main.instantiateViewController(DetailsController.self)
                    vc.set(data: $0)
                    
                    self?.present(vc, animated: true)
                }
        }
    }
    
    private func bindPagination() -> Disposable {
        return self
            .viewContent
            .rx
            .paginationAction
            .bind { [weak self] in self?.viewModel.getNext() }
    }
    
    private func bindCancelAction() -> Disposable {
        return self
            .searchBar
            .rx
            .cancelButtonClicked
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.viewContent.set(data: self.viewModel.data)
        }
    }
}
