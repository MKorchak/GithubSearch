//
//  RemoteStorage.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct RemoteStorage: ApiClientProtocol, RemoteStorageProtocol {
    typealias ErrorHandlerType = ErrorHandler
    
    func authentificate(username: String,
                        password: String,
                        success: @escaping (HTTPHeaders) -> Void,
                        failure: @escaping (DataError) -> Void) {
        let request = AuthRequest(username: username, password: password)
        
        self.execute(request, success: { success(request.headers) }, failure: failure)
    }
    
    func getPopularSearchResult<T: ModelProtocol>(
        parameters: Observable<(searchText: String, page: Int, perPage: Int)>
        ) -> Observable<(first: T?, second: T?, page: Int, perPage: Int)> {
        return parameters.flatMap { (text, page, perPage) -> Observable<(first: T?, second: T?, page: Int, perPage: Int)> in
            let firstRequest = SearchRepoRequest(page: page * 2 - 1,
                                                 perPage: perPage / 2,
                                                 searchText: text,
                                                 sort: .stars)
            let secondRequest = SearchRepoRequest(page: page * 2,
                                                  perPage: perPage / 2,
                                                  searchText: text,
                                                  sort: .stars)
            let firstRequestObservable: Observable<T?> = self.rxExecute(firstRequest)
            let secondRequestObservable: Observable<T?> = self.rxExecute(secondRequest)
            
            return Observable.zip(firstRequestObservable,
                                  secondRequestObservable,
                                  resultSelector: { ($0, $1, page, perPage) })
        }
    
    }
}
