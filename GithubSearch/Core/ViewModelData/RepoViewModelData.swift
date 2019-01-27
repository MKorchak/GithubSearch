//
//  RepoViewModelData.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation

struct RepoViewModelData: ViewModelDataProtocol {
    
    var name: String {
        return self.model.name
    }
    
    var viewed: Bool {
        return self.model.viewed
    }
    
    let model: RepoModel
    
    init(_ model: RepoModel) {
        self.model = model
    }
}
