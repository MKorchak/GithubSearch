//
//  LocalStorageProtocol.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocalStorageProtocol {
    func saveSearchResults<T: Object>(_ data: [T])
    func getSearchResults<T: Object>(success: @escaping ([T]) -> Void,
                                     failure: @escaping (DataError) -> Void)
}
