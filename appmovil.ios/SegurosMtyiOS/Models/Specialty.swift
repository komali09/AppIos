//
//  Specialty.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 21/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct Specialty: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case name = "title"
    }
}
