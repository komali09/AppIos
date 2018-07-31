//
//  Assistance.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/23/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

enum AssistanceType: Int {
    case travel = 1
    case medic = 2
    case nutrition = 3
    case psychology = 4
    case legal = 5
    case funerary = 6
    
    var stringValue: String {
        get {
            switch self {
            case .travel:
                return "viajes"
            case .medic:
                return "médica"
            case .nutrition:
                return "nutricional"
            case .psychology:
                return "psicológica"
            case .legal:
                return "legal"
            case .funerary:
                return "funeraria"
            }
        }
    }
    
    var color: UIColor {
        get {
            switch self {
            case .travel, .nutrition, .legal:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
    }
    
    var image: UIImage? {
        get {
            switch self {
            case .travel:
                return UIImage(named: "asistenciasViajes")
            case .medic:
                return UIImage(named: "asistenciasMedica")
            case .nutrition:
                return UIImage(named: "asistenciasNutricional")
            case .psychology:
                return UIImage(named: "asistenciasPsicologica")
            case .legal:
                return UIImage(named: "asistenciasLegal")
            case .funerary:
                return UIImage(named: "asistenciasFuneraria")
            }
        }
    }
}

struct AssistanceItem: Codable, Comparable {
    var id: Int
    var name: String
    var event: String
    var type: String
    var limitations: String?
    var exclusions: String?
}

func ==(lhs:AssistanceItem, rhs: AssistanceItem) -> Bool {
    return lhs.id == rhs.id
}

func >(lhs:AssistanceItem, rhs: AssistanceItem) -> Bool {
    return lhs.id > rhs.id
}

func <(lhs:AssistanceItem, rhs: AssistanceItem) -> Bool {
    return lhs.id < rhs.id
}

func >=(lhs:AssistanceItem, rhs: AssistanceItem) -> Bool {
    return lhs.id >= rhs.id
}

func <=(lhs:AssistanceItem, rhs: AssistanceItem) -> Bool {
    return lhs.id <= rhs.id
}
