//
//  RemoteStorageProtocol.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol RemoteStorageProtocol {
    func authentificate(username: String,
                        password: String,
                        success: @escaping (HTTPHeaders) -> Void,
                        failure: @escaping (DataError) -> Void)
    
    func getPopularSearchResult<T: ModelProtocol>(
        parameters: Observable<(searchText: String, page: Int, perPage: Int)>
        ) -> Observable<(first: T?, second: T?, page: Int, perPage: Int)>
}
