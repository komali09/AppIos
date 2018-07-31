//
//  User.swift
//  SegurosMtyiOS
//
//  Created by Rafael Jimeno Osornio on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var lastname: String?
    var birthDate: String?
    var email: String?
    var polizas: [Poliza]?
}

struct Poliza {
    var name: String?
}
