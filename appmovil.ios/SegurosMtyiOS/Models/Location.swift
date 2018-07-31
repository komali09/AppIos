//
//  Location.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 15/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    var businessId: Int
    var providerId: String
    var name: String
    var address: String?
    var phone: String
    var city: String?
    var website: String?
    var isFavorite: Bool? = false
    var policyList: [String]?
    var policyMessage: String?
    
    private var lat: String?
    private var lon: String?
    private var _type: Int?
    
    var type:ServiceType {
        get {
            guard let typeString = _type else { return .other }
            guard let typeEnum = ServiceType(rawValue:typeString) else { return .other }
            return typeEnum
        }
    }
    
    var coordinates:CLLocationCoordinate2D? {
        get {
            guard let latString = lat else { return  nil }
            guard let lonString = lon else { return  nil }
            guard let lat = Double(latString) else { return  nil }
            guard let lon = Double(lonString) else { return  nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case businessId = "businessId"
        case providerId = "providerId"
        case name = "name"
        case address = "address"
        case phone = "phone"
        case lat = "lat"
        case lon = "lon"
        case _type = "type"
        case isFavorite = "is_favorite"
        case city = "city"
        case website = "linkWeb"
        case policyList = "list"
        case policyMessage = "Pnote"
    }
    
    mutating func setLocation(location: CLLocation) {
        self.lat = "\(location.coordinate.latitude)"
        self.lon = "\(location.coordinate.longitude)"
    }
    
    mutating func setFavorite(value: Bool?) {
        self.isFavorite = value
    }
}
