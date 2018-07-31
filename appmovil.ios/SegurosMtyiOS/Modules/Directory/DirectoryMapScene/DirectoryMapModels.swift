//
//  DirectoryMapModels.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/14/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import GoogleMaps

enum DirectoryMap {
    // MARK: Use cases
    
    enum Locations {
        struct Response {
            var isPlanIncluded: Bool
            var locations:[Location]
        }
        struct ViewModel {
            var markers: [GMSMarker]
        }
    }
}