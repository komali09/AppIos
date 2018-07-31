//
//  LocationsResponse.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 15/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct ApiListResponse<T: Codable>: Codable {
    var list: [T]
    var sessionToken: String?
    
    enum CodingKeys: String, CodingKey {
        case list
        case sessionToken = "sToken"
    }
}
