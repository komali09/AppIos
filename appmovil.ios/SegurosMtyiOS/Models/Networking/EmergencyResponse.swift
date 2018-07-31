//
//  EmergencyResponse.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 05/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct EmergencyResponse: Codable {
    var sessionToken: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionToken = "sToken"
    }
}
