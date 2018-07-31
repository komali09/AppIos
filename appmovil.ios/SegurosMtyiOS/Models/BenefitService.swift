//
//  BenefitService.swift
//  SegurosMtyiOS
//
//  Created by Mariana on 23/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct BenefitService: Codable {
    var icon: String
    var benefit: String
    var clause: String?
    
    enum CodingKeys: String, CodingKey {
        case icon = "id"
        case benefit = "benefit"
        case clause = "clause"
    }
}
