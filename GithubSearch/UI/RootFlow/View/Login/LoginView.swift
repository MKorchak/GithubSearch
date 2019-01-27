//
//  LoginView.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginView: BaseView {
    
    // MARK: - Outlets
    
    @IBOutlet weak private(set) fileprivate var textFieldUsername: UITextField!
    @IBOutlet weak private(set) fileprivate var textFieldPassword: UITextField!
    @IBOutlet weak private(set) fileprivate var buttonSignIn: UIButton!
    @IBOutlet weak private(set) fileprivate var buttonGuestMode: UIButton!
    
    // MARK: - Public properties
    // MARK: RegisterViewProtocol

    var view: UIView! {
        didSet {
            self.configure()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self <- self.xibSetupView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self <- self.xibSetupView
    }
}

// MARK: - LoginView + RegisterViewProtocol

extension LoginView: RegisterViewProtocol {
    func configure() {
        
    }
}

// MARK: - LoginView + Rx accessors

extension Reactive where Base == LoginView {
    var signInAction: ControlEvent<(username: String?, password: String?)> {
        return ControlEvent(
            events: self
                .base
                .buttonSignIn
                .rx
                .tap
                .map { [weak base = self.base] _ in
                    (base?.textFieldUsername.text, base?.textFieldPassword.text)
                }
        )
    }
    
    var guestModeAction: ControlEvent<Void> {
        return self
            .base
            .buttonGuestMode
            .rx
            .tap
    }
}
