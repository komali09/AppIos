//
//  UserInfo.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/6/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//


struct UserInfo: Codable {
    var firstName: String
    var lastName: String
    var fullName: String {
        get {
            return  "\(self.firstName) \(self.lastName)"
        }
    }
    var birthday: String
    var email: String
    var lastSession: String?
    var polizy: String?
    var token: String
    var firstEntry: Bool
    
    enum CodingKeys: String, CodingKey {
        case firstName = "name"
        case lastName = "lastname"
        case birthday = "birthday"
        case email = "email"
        case lastSession = "lastSession"
        case polizy = "mpolizy"
        case token = "sToken"
        case firstEntry = "firstEntry"
    }
    
    mutating func updateEmail(_ newEmail: String) {
        self.email = newEmail
    }
    mutating func removeTokenFormResponse() {
        self.token = ""
    }
}

