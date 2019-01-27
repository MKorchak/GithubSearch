//
//  ErrorHandler.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import Alamofire

public enum StatusCode: Int, StatusCodeProtocol {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    
    case badRequest = 400
    case badCredentials = 401
    case accessForbidden = 403
    case objectNotFound = 404
    
    case unprocessableEntity = 422
    case limitedRequest = 429
    
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    
    case noInternetConnection = -1009
    case requestTimeout = -1001
    case internetConnectionWasLost = -1005
    case serverCouldNotBeFound = -1003
}


public struct DataError: ErrorProtocol {
    public typealias StatusCodeType = StatusCode
    
    public var statusCode: StatusCodeType
    public var devMessage: String
    public var userMessage: String
    
    init(statusCode: StatusCodeType, devMessage: String, userMessage: String) {
        self.statusCode = statusCode
        self.devMessage = devMessage
        self.userMessage = userMessage
    }
    
    init(model: ErrorModel) {
        self.statusCode = StatusCode(rawValue: model.code ?? 0) ?? .badRequest
        self.devMessage = model.devMessage ?? DataManager.shared.serverConnectionErrorMessage
        self.userMessage = model.errorMessage ?? DataManager.shared.serverConnectionErrorMessage
    }
    
    public static var `default`: DataError {
        return DataError(statusCode: .badRequest,
                         devMessage: "Default Auth error",
                         userMessage: DataManager.shared.serverConnectionErrorMessage)
    }
    
    public func logDescription() {
        Log.error.log("DataError",
                      parameters: ["statusCode": self.statusCode,
                                   "devMessage": self.devMessage,
                                   "userMessage": self.userMessage])
    }
}

extension DataError: Equatable {
    public static func ==(lhs: DataError, rhs: DataError) -> Bool {
        return lhs.statusCode == rhs.statusCode
            && rhs.devMessage == lhs.devMessage
            && lhs.userMessage == rhs.userMessage
    }
}

struct ErrorModel: ModelProtocol {
    var code: Int?
    var devMessage: String?
    var errorMessage: String?
}

public struct ErrorHandler: ErrorHandlerProtocol {
    
    public typealias ErrorType = DataError
    
    public static func handleError<T>(statusCode: Int, response: DataResponse<T>) -> DataError {
        func parseErrorJson(_ json: DictionaryAlias) -> DataError {
            guard let errorJson = json["error"] as? DictionaryAlias,
                let errorModel = ErrorModel(JSON: errorJson)
                else { return DataError.default }
            
            return DataError(model: errorModel)
        }
        if let json = response.result.value as? DictionaryAlias {
            return parseErrorJson(json)
        }
        
        if let data = response.data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? DictionaryAlias {
                    return parseErrorJson(json)
                }
            } catch {
                return .default
            }
        }
        
        return .default
    }
}
