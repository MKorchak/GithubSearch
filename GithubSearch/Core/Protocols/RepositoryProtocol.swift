//
//  RepositoryProtocol.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation

protocol RepositoryProtocol: BaseRepositoryProtocol where RemoteStorageType == RemoteStorageProtocol, LocalStorageType == LocalStorageProtocol {}
