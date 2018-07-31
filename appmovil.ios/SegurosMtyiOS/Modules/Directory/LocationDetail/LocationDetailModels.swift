//
//  LocationDetailModels.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/2/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoogleMaps
import MapKit

enum LocationDetail {
    // MARK: Use cases
    
    enum LoadDetail {
        struct Request { }
        struct Response {
            var location:Location
        }
        struct ViewModel {
            var title: String
            var city: String
            var type: String
            var isFavorite: Bool
            var bgImage: UIImage
            var address: String?
            var phone: String?
            var website: String?
            var marker: GMSMarker?
            var isPolicyHidden: Bool
            var policyList: String?
            var policyMessage: String?
            var isBenefitsHidden: Bool
        }
    }
    
    enum ShowNavigationApps {
        
        struct ViewModel {
            
            var alertController: UIAlertController?
            var maps: MKMapItem?
            
        }
        
    }
}


enum BenefitServiceDetail {
    enum BenefitServices{
        struct Response {
            var benefits: [BenefitService]
        }
        struct ViewModel {
            var benefits: [BenefitService]
        }
    }
}