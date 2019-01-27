//
//  StorageFactory.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation

enum StorageFactory {
    private static let defaultLocalStorage = LocalStorage()
    private static let defaultRemoteStorage = RemoteStorage()
    
    case `default`
    
    var remoteStorage: RemoteStorageProtocol {
        switch self {
        case .default:
            return StorageFactory.defaultRemoteStorage
        }
    }
    
    var localStorage: LocalStorageProtocol {
        switch self {
        case .default:
            return StorageFactory.defaultLocalStorage
        }
    }
}
