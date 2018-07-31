//
//  WorkerError.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/5/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

enum WorkerError : Swift.Error {
    case noInput
    case invalidInput
    case unknown
    case noPublicKey
    case other(Error)
}

extension WorkerError: LocalizedError {
    public var errorDescription: String? {
        var message: String
        switch self {
        case .noInput:
            message = "input vacio"
        case .invalidInput:
            message = "validacion de input no válida"
        case .noPublicKey:
            message = "No se tiene la llave publica"
        default:
            message = "generico"
        }
        return message
    }
}
