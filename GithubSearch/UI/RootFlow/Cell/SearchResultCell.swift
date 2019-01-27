//
//  SearchResultCell.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell, RegisterCellProtocol {

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel?.text = stringDummy
        self.accessoryType = .none
    }
}

extension SearchResultCell: DataProviderProtocol {
    typealias DataType = RepoViewModelData
    
    func set(data: DataType) {
        self.textLabel?.text = data.name
        self.accessoryType = data.viewed ? .checkmark : .none
    }
}
