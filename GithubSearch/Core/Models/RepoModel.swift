//
//  RepoModel.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RealmSwift

struct RepoListModel: ModelProtocol {
    let items: [RepoModel.ServerModel]
}

final class RepoModel: Object {
    @objc dynamic var id = intDummy
    @objc dynamic var index = intDummy
    @objc dynamic var name = stringDummy
    @objc dynamic var url = stringDummy
    @objc dynamic var viewed = boolDummy
    
    convenience required init(fromServerModel serverModel: ServerModel) {
        self.init()
        
        self.id = serverModel.id
        self.name = serverModel.name
        self.url = serverModel.url
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    struct ServerModel: ModelProtocol {
        let id: Int
        let name: String
        let url: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case url = "html_url"
        }
    }
}
