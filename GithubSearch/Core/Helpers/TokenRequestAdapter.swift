//
//  TokenRequestAdapter.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire

struct TokenRequestAdapter: RequestAdapter {
    
    private let headers: HTTPHeaders
    
    init(tokenHeaders: HTTPHeaders) {
        self.headers = tokenHeaders
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        self.headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return urlRequest
    }
    
    
}
