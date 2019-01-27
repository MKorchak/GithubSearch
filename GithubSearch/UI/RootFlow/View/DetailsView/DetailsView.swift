//
//  DetailsView.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

class DetailsView: BaseView {
    
    // MARK: - Outlets

    @IBOutlet weak private(set) fileprivate var buttonClose: UIButton!
    @IBOutlet weak private var webView: WKWebView!
    
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

// MARK: - DetailsView + RegisterViewProtocol

extension DetailsView: RegisterViewProtocol {
    func configure() {
    }
}

extension DetailsView: DataProviderProtocol {
    typealias DataType = URLRequest
    
    func set(data: URLRequest) {
        self.webView.load(data)
    }
}

extension Reactive where Base == DetailsView {
    var closeAction: ControlEvent<Void> {
        return self.base.buttonClose.rx.tap
    }
}
