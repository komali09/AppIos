//
//  VerifyCodeResponse.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/22/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct VerifyCodeResponse: Codable {
    var code: String?
    var expirationDate: String?
    var timestamp: Int?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case expirationDate = "expirationDate"
        case timestamp = "timestamp"
    }
}
