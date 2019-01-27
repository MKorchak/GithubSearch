//
//  LoginController.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak private var viewContent: LoginView!
    
    // MARK: - Private properties
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Overriden methods
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureRx()
    }
    
    // MARK: - Private methods
    
    private func configureRx() {
        self.bindRequestStatus().disposed(by: self.disposeBag)
        self.bindSignInAction().disposed(by: self.disposeBag)
        self.bindGuestModeAction().disposed(by: self.disposeBag)
    }
    
    private func bindRequestStatus() -> Disposable {
        return self
            .viewModel
            .requestStatus
            .drive(onNext: { [weak self] (status) in
                switch status {
                case .success:
                    self?.present(Storyboard.main.instantiateViewController(SearchController.self),
                                  animated: true)
                    Log.debug.log("Success")
                case .loading:
                    Log.debug.log("Loading")
                case .error(let error):
                    Log.debug.log("Error: \(error)")
                case .default:
                    Log.debug.log("Default")
                }
            })
    }
    
    private func bindSignInAction() -> Disposable {
        return self
            .viewContent
            .rx
            .signInAction
            .bind { [weak self] in
                guard let username = $0.username, let password = $0.password else { return }
                self?.viewModel.update(username: username, password: password)
        }
    }

    private func bindGuestModeAction() -> Disposable {
        return self
            .viewContent
            .rx
            .guestModeAction
            .bind { [weak self] in
                let vc = Storyboard
                    .main
                    .instantiateViewController(GuestModeController.self)
                self?.present(vc, animated: true)
        }
    }
}
