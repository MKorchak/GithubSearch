//
//  GuestViewModel.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GuestModeViewModel<T: ViewModelDataProtocol>: RxViewModelProtocol,
                                                          DataContainerProtocol
                                                          where T.ModelType == RepoModel {
    typealias DataType = Driver<[T]>
    typealias ModelType = [RepoModel]
    
    var requestStatus: Driver<RequestStatus> = .empty()
    var model: [RepoModel] = []
    let data: Driver<[T]>
    
    init() {
        self.data = RootRepository
            .getCachedSearchResults()
            .map { $0.map(T.init) }
            .asDriver(onErrorJustReturn: [])
    }
    
    func set(_ model: [RepoModel]) {
        self.model = model
    }
    
}
