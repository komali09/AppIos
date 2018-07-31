//
//  VerifyPolicyResponse.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/30/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct VerifyPolicyResponse: Codable {
    
    var publicKey: String
    
    enum CodingKeys: String, CodingKey {
        case publicKey = "publicKey"
    }
}
