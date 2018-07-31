//
//  Service.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceTypeName {
    var name: String { get }
    var ico: UIImage? { get }
}

enum ServiceType: Int, ServiceTypeName {
    case all = 0            // Todos
    case nursing = 1        // Enfermería
    case pharmacy = 2       // Farmacias
    case hospital = 3       // Hospital/Clínica
    case laboratory = 4     // Laboratorios
    case medic = 5          // Médicos
    case optics = 6         // Ópticas
    case other = 7          // Otros
    case rehabilitation = 8 // "Rehabilitación
    
    
    var name: String {
        switch self {
        case .all:
            return "Todos"
        case .nursing:
            return "Enfermería"
        case .pharmacy:
            return "Farmacias"
        case .hospital:
            return "Hospital o Clínica"
        case .laboratory:
            return "Laboratorios"
        case .medic:
            return "Médicos"
        case .optics:
            return "Ópticas"
        case .other:
            return "Otros"
        case .rehabilitation:
            return "Rehabilitación"
        }
    }
    
    var ico: UIImage? {
        switch self {
        case .all:
            return UIImage(named: "Todos")
        case .nursing:
            return UIImage(named: "icoServiceNursing")
        case .pharmacy:
            return UIImage(named: "icoServicePharmacy")
        case .hospital:
            return UIImage(named: "icoServiceHospital")
        case .laboratory:
            return UIImage(named: "icoServiceLaboratories")
        case .medic:
            return UIImage(named: "Médicos")
        case .optics:
            return UIImage(named: "icoServiceOptics")
        case .other:
            return UIImage(named: "icoServiceOthers")
        case .rehabilitation:
            return UIImage(named: "icoServiceRehabilitation")
        }
    }
}
