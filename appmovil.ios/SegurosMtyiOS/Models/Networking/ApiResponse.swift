//
//  APIResponse.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct ApiResponse<T: Codable>: Codable  {
    var statusCode: String
    var extras: [String]
    var body: T
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case body = "body"
        case extras = "extras"
    }
}

struct ErrorBody : Codable {
    var message: String
    var rattempts: Int?
    var rtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case rattempts = "rattempts"
        case rtime = "rtime"
    }
}
