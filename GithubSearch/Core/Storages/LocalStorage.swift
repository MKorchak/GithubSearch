//
//  LocalStorage.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RealmSwift

struct LocalStorage: LocalStorageProtocol, RealmClientProtocol {
    typealias ErrorType = DataError
    
    
    func saveSearchResults<T: Object>(_ data: [T]) {
        DispatchQueue.global(qos: .background).async {
            let objects = data.map { T(value: $0, schema: .partialPrivateShared()) }
            self.removeAllDataFrom(T.self)
            self.saveModelArrayToStorage(objects)
        }
    }
    
    func getSearchResults<T: Object>(success: @escaping ([T]) -> Void,
                                     failure: @escaping (DataError) -> Void) {
        self.fetchAllItems(T.self, success: success, failure: failure)
    }
}
