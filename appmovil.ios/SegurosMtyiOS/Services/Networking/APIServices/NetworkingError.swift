//
//  NetworkingError.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

enum NetworkingError : Swift.Error {
    case couldNotParseJSON
    case noData
    case noSuccessStatusCode(code:Int, body:ErrorBody)
    case noInternet
    case unauthorized
    case unknown
    case timeout
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        var message: String
        switch self {
        case .couldNotParseJSON:
            message = "no se pudo parsear json"
        case .noSuccessStatusCode(let code, let body):
            message = "noSuccessStatusCode: \(code); \(body.message)"
        default:
            message = "generico"
        }
        return message
    }
}
