//
//  GuestModeController.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit

class GuestModeController: BaseViewController {
    
    @IBOutlet weak private var viewContent: SearchResultsView!
    
    private let viewModel = GuestModeViewModel<RepoViewModelData>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.editable = false
        self.viewContent.set(data: self.viewModel.data)
    }
    
    @IBAction private func buttonCloseAction() {
        self.dismiss(animated: true)
    }
}
