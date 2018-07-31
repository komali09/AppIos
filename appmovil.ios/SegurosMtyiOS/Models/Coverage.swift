//
//  Coverage.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 25/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

enum CoverageType: Int {
    case general = 0
    case medicines = 1
    case medic = 2
    case pregnan = 3
    case dental = 4
    case ambulance = 5
    case heritage = 6
    case vih = 7
    case spouse = 8
    case border = 9
    
    var stringValue: String {
        get {
            switch self {
            case .general:
                return ""
            case .medicines:
                return "medicamentos"
            case .medic:
                return "médico"
            case .pregnan:
                return "embarazo"
            case .dental:
                return "dental"
            case .ambulance:
                return "ambulancia"
            case .heritage:
                return "patrimonio"
            case .vih:
                return "vih"
            case .spouse:
                return "cónyuge"
            case .border:
                return "frontera"
            }
        }
    }
    
    var image: UIImage? {
        get {
            switch self {
            case .general:
                return UIImage(named: "coverageGeneral")
            case .medicines:
                return UIImage(named: "coverageMedicines")
            case .medic:
                return UIImage(named: "coverageMedic")
            case .pregnan:
                return UIImage(named: "coveragePregnancy")
            case .dental:
                return UIImage(named: "coverageDental")
            case .ambulance:
                return UIImage(named: "coverageAmbulance")
            case .heritage:
                return UIImage(named: "coverageHeritage")
            case .vih:
                return UIImage(named: "coverageVIH")
            case .spouse:
                return UIImage(named: "coverageSpouse")
            case .border:
                return UIImage(named: "coverageBorder")
            }
        }
    }
}

struct Coverage: Codable {
    var name: String?
    var waitingPeriod: String?
    var caption: String?
    var ico: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case waitingPeriod = "waitingPeriod"
        case caption = "caption"
        case ico = "icon"
    }
}
