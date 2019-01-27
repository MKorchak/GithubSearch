//
//  AuthRequest.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire

struct AuthRequest: ApiRequestProtocol {
    var url: String {
        return "https://api.github.com/user"
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": self.token]
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var sessionManager: SessionManager {
        return Constants.Api.authSessionManager
    }
    
    private let token: String
    
    init(username: String, password: String) {
        self.token = "Basic \((username + ":" + password).data(using: .utf8)?.base64EncodedString() ?? stringDummy)"
    }
}
