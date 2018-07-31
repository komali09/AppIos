//
//  Beneficary.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/18/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct Beneficiarie: Codable {
    var name: String?
    var fatherLastName: String?
    var motherLastName: String?
    var relationship: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case fatherLastName = "fatherLastname"
        case motherLastName = "motherLastname"
        case relationship = "relationship"
    }
}
