//
//  MoyaExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/7/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import RxSwift
import Moya

/// Extension for processing raw NSData generated by network access.
extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    public func filterSuccessStatusCodes() -> Single<ElementType> {
        return flatMap { response -> Single<ElementType> in
            return Single.just(try response.filterSuccessStatusCodes())
        }
    }
}

extension Response {
    /**
     Returns the `Response` if the `statusCode` falls within the range 200 - 299.
     
     - throws: `NetworkingError.noSuccessStatusCode` when others are encountered.
     */
    public func filterSuccessStatusCodes() throws -> Response {
        do {
            return try self.filterSuccessfulStatusCodes()
        } catch {
            switch error {
            case MoyaError.statusCode(let response):
                if let body = try? response.map(ApiResponse<ErrorBody>.self),
                    let integerStatusCode = Int(body.statusCode) {
                    let error = NetworkingError.noSuccessStatusCode(code: integerStatusCode, body: body.body)
                    debugPrint("❌ filterSuccessStatusCodes Error: \(error)")
                    throw error
                } else if response.statusCode == 401  {
                    debugPrint("❌ unauthorized!")
                    throw NetworkingError.unauthorized
                } else {
                    debugPrint("❌ filterSuccessStatusCodes Error: \(error)")
                    throw NetworkingError.couldNotParseJSON
                }
            default:
                debugPrint("❌ filterSuccessStatusCodes Error: \(error)")
                throw error
            }
        }
    }
}
