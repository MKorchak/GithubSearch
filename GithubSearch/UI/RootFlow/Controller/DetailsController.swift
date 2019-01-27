//
//  DetailsController.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift

class DetailsController: BaseViewController {
    
    @IBOutlet weak private var viewContent: DetailsView!
    
    private var requestDetails: URLRequest?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestDetails.run(self.viewContent.set)
        self.configureRx()
    }

    private func configureRx() {
        self.viewContent
            .rx
            .closeAction
            .bind { [weak self] in self?.dismiss(animated: true) }
            .disposed(by: self.disposeBag)
    }
}

extension DetailsController: DataProviderProtocol {
    typealias DataType = URLRequest
    
    func set(data: URLRequest) {
        self.requestDetails = data
    }
}
