//
//  Constants.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire

struct Constants {
    struct Api {
        static let authSessionManager = SessionManager.default
        
        static let defautSessionManager: SessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.httpMaximumConnectionsPerHost = 2
            
            return SessionManager(configuration: configuration)
        }()
        
        static let baseUrl = "https://api.github.com"
    }
    
    private init() {}
}
