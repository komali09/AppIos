//
//  ErrorMessage.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct ValidateNumberResponse: Codable {
    var fullName: String
    var publicKey: String
    var isFirstEntry: Bool
    
    enum CodingKeys: String, CodingKey {
        case fullName = "fullname"
        case publicKey = "publicKey"
        case isFirstEntry = "firstEntry"
    }
}
