//
//  State.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 20/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

struct State: Codable {
    var id: Int
    var name: String
    
    init(state:StateCode) {
        self.id = state.id
        self.name = state.name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "state"
    }
}

enum StateCode: String {
    case ags
    case bc
    case bcs
    case camp
    case chis
    case chih
    case cdmx
    case coah
    case col
    case dgo
    case gto
    case gro
    case hgo
    case jal
    case edomex
    case mich
    case mor
    case nay
    case nl
    case oax
    case pue
    case qro
    case qroo
    case slp
    case sin
    case son
    case tab
    case tamps
    case tlax
    case ver
    case yuc
    case zac
    
    var id: Int {
        switch self {
        case .ags:
            return 1
        case .bc:
            return 2
        case .bcs:
            return 3
        case .camp:
            return 4
        case .chis:
            return 5
        case .chih:
            return 6
        case .coah:
            return 7
        case .col:
            return 8
        case .cdmx:
            return 9
        case .dgo:
            return 10
        case .gto:
            return 11
        case .gro:
            return 12
        case .hgo:
            return 13
        case .jal:
            return 14
        case .edomex:
            return 15
        case .mich:
            return 16
        case .mor:
            return 17
        case .nay:
            return 18
        case .nl:
            return 19
        case .oax:
            return 20
        case .pue:
            return 21
        case .qro:
            return 22
        case .qroo:
            return 23
        case .slp:
            return 24
        case .sin:
            return 25
        case .son:
            return 26
        case .tab:
            return 27
        case .tamps:
            return 28
        case .tlax:
            return 29
        case .ver:
            return 30
        case .yuc:
            return 31
        case .zac:
            return 32
        }
    }
    
    var name: String {
        switch self {
        case .ags:
            return "AGUASCALIENTES"
        case .bc:
            return "BAJA CALIFORNIA"
        case .bcs:
            return "BAJA CALIFORNIA SUR"
        case .camp:
            return "CAMPECHE"
        case .chis:
            return "CHIAPAS"
        case .chih:
            return "CHIHUAHUA"
        case .coah:
            return "COAHUILA"
        case .col:
            return "COLIMA"
        case .cdmx:
            return "DISTRITO FEDERAL"
        case .dgo:
            return "DURANGO"
        case .gto:
            return "GUANAJUATO"
        case .gro:
            return "GUERRERO"
        case .hgo:
            return "HIDALGO"
        case .jal:
            return "JALISCO"
        case .edomex:
            return "MEXICO"
        case .mich:
            return "MICHOACAN"
        case .mor:
            return "MORELOS"
        case .nay:
            return "NAYARIT"
        case .nl:
            return "NUEVO LEON"
        case .oax:
            return "OAXACA"
        case .pue:
            return "PUEBLA"
        case .qro:
            return "QUERETARO"
        case .qroo:
            return "QUINTANA ROO"
        case .slp:
            return "SAN LUIS POTOSI"
        case .sin:
            return "SINALOA"
        case .son:
            return "SONORA"
        case .tab:
            return "TABASCO"
        case .tamps:
            return "TAMAULIPAS"
        case .tlax:
            return "TLAXCALA"
        case .ver:
            return "VERACRUZ"
        case .yuc:
            return "YUCATAN"
        case .zac:
            return "ZACATECAS"
        }
    }
}
