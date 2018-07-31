//
//  EmergencyContact.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 05/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation

struct EmergencyContact: Codable {
    var ID: Int?
    var name: String?
    var picture: String?
    var address: String?
    var email: String?
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "name"
        case picture = "picture"
        case address = "address"
        case email = "email"
        case phone = "phone"
    }
}
