//
//  BeneficiarieResponse.swift
//  SegurosMtyiOS
//
//  Created by Adan Garcia on 01/02/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct BeneficiarieResponse: Codable {
    var list: [Beneficiarie]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}
