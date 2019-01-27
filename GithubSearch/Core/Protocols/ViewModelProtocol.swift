//
//  ViewModelProtocol.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation

public enum RequestStatus: RequestStatusProtocol, Equatable {
    public typealias Error = DataError
    
    case `default`
    case loading // request now loading
    case success // request success complete
    case error(Error) // request complete with error
    
    public var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    public var isLoading: Bool {
        return self == .loading
    }
    
    public func isError(_ error: Error) -> Bool {
        switch self {
        case .error(let currentError):
            return error.statusCode == currentError.statusCode
                && error.devMessage == currentError.devMessage
        default:
            return false
        }
    }
    
    public static func ==(lhs: RequestStatus,
                          rhs: RequestStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.loading, .loading):
            return true
        case (.error(let lError), .error(let rError)):
            return lError == rError
        case (.default, .default):
            return true
        default:
            return false
        }
    }
}

protocol ViewModelProtocol: BaseViewModelProtocol where RequestStatusType == RequestStatus {}
protocol RxViewModelProtocol: RxBaseViewModelProtocol where RequestStatusType == RequestStatus {}
