//
//  LoginViewModel.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: RxViewModelProtocol {
    typealias ModelType = Void
    var requestStatus: Driver<RequestStatus> {
        return _requestStatus
            .asDriver(onErrorRecover: { .just(.error(ErrorHandler.handleError($0))) })
    }
    
    private let _requestStatus = PublishSubject<RequestStatus>()
    
    var model: Void
    
    init() {}
    
    func set(_ model: Void) {}
    
    func update(username: String, password: String) {
        RootRepository.authentificate(username: username,
                                      password: password,
                                      success: { [weak self] in self?._requestStatus.onNext(.success) },
                                      failure: { self._requestStatus.onNext(.error(ErrorHandler.handleError($0))) })
    }
}
