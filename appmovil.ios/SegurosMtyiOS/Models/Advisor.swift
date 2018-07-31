//
//  Advisor.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/28/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct Advisor: Codable {
    var name: String?
    var fatherLastName: String?
    var motherLastName: String?
    var mobilePhone: String?
    var officePhone: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "nombre"
        case fatherLastName = "ape_paterno"
        case motherLastName = "ape_materno"
        case email = "mail"
        case officePhone = "telefono_oficina"
        case mobilePhone = "celular"
    }
}
