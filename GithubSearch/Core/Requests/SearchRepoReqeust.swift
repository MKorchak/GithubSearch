//
//  SearchRepoReqeust.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire

struct SearchRepoRequest: ApiRequestProtocol {
    enum Sort: String {
        case stars
        case forks
        case updated
        case none = ""
    }
    
    var url: String {
        return Constants.Api.baseUrl + "/search/repositories"
    }
    
    var parameters: Parameters {
        return ["q": self.searchText,
                "page": self.page,
                "per_page": self.perPage,
                "sort": self.sort.rawValue]
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var sessionManager: SessionManager {
        return Constants.Api.defautSessionManager
    }
    
    private let page: Int
    private let perPage: Int
    private let searchText: String
    private let sort: Sort
    
    init(page: Int,
         perPage: Int,
         searchText: String,
         sort: Sort) {
        self.page = page
        self.perPage = perPage
        self.searchText = searchText
        self.sort = sort
    }
}
