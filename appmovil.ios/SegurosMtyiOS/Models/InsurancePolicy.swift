//
//  InsurancePolicy.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 20/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

enum PolicyCardType: Int {
    case alfaMedicalFlexA = 1
    case alfaMedical = 2
    case alfaMedicalInternational = 3
    case optaMedica = 0
    
    var icon:UIImage? {
        switch self {
        case .optaMedica:
            return UIImage(named: "icoLogoNY")
        default:
            return UIImage(named: "icoAlfaMedical")
        }
    }
    
    var backGroundImage: UIImage? {
        
        switch self {
        case .optaMedica:
            return UIImage.init()
        default:
            return UIImage(named: "appleBackImage")
        }
        
    }
    
    var gradientPrimaryColor: UIColor {
        switch self {
        case .optaMedica:
            return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        case .alfaMedicalInternational:
            return UIColor(red: 25.0/255.0, green: 64.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        default:
            return UIColor(red: 53.0/255.0, green: 167.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        }
    }
    
    var gradientSecondaryColor: UIColor {
        switch self {
        case .optaMedica:
            return UIColor(red: 66.0/255.0, green: 175.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        case .alfaMedicalInternational:
            return UIColor(red: 61.0/255.0, green: 180.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        default:
            return UIColor(red: 82.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        }
    }
    
}

enum PolicyType: Int {
    case individual = 0
    case collective = 1
    
    var stringValue: String {
        switch self {
        case .individual:
            return LocalizableKeys.Profile.MyInsurancePolicies.individualForm
        case .collective:
            return LocalizableKeys.Profile.MyInsurancePolicies.collectiveForm
        }
    }
}

struct InsurancePolicy: Codable {
    
    var policyId: String
    var certificateId: String?
    var productName: String
    var planName: String
    var titularName: String
    var coassurance: String?
    var nationalCoassurance: String?
    var internationalCoassurance: String?
    
    var deductible: String?
    var nationalDeductible: String?
    var internationalDeductible: String?
    
    var planType: Int
    var isMainPolicy: Bool
    var isActive: Bool?
    var isTitular: Bool? = true
    var expirationAlert: String?
    var assuredSum: String?
    var paymentFrequency: String?
    var currency: String?
    var maxCoassurance: String?
    var copaymentsParticipations: [copaymentsParticipations]?
    
    private var _cardId: Int
    var cardId:PolicyCardType {
        get {
            return PolicyCardType(rawValue:_cardId) ?? .optaMedica
        }
    }
    
    private var _startDate: String?
    var startDate: Date? {
        get {
            return _startDate?.shortDateFormat()
        }
    }
    
    private var _endDate: String
    var endDate: Date {
        get {
            return _endDate.shortDateFormat()
        }
    }
    
    private var _nextPaymentDate: String?
    var nextPaymentDate: Date? {
        get {
            return _nextPaymentDate?.shortDateFormat()
        }
    }
    
    private var _emissionDate: String?
    var emissionDate: Date? {
        get {
            return _emissionDate?.shortDateFormat()
        }
    }
    
    private var _planForm: Int
    var planForm: PolicyType {
        get {
            return PolicyType(rawValue:_planForm) ?? .individual
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case policyId = "policy_id"
        case certificateId = "certificate_id"
        case productName = "product_name"
        case planName = "plan_name"
        case titularName = "titular_name"
        case coassurance = "coassurance"
        case nationalCoassurance = "national_coassurance"
        case internationalCoassurance = "international_coassurance"
        case deductible = "deductible"
        case nationalDeductible = "national_deductible"
        case internationalDeductible = "international_deductible"
        case planType = "plan_type"
        case isMainPolicy = "principal"
        case isActive = "status"
        case isTitular = "is_titular"
        case expirationAlert = "expiration_alert"
        case assuredSum = "assured_sum"
        case paymentFrequency = "payment_frequency"
        case currency = "currency"
        case maxCoassurance = "max_coassurance"
        case _startDate = "start_date"
        case _endDate = "end_date"
        case _planForm = "plan_form"
        case _cardId = "card_id"
        case _nextPaymentDate = "next_payment_date"
        case _emissionDate = "emission_date"
        case copaymentsParticipations = "copayments_participations"
        
    }
    
    mutating func setAsPrincipal() {
        self.isMainPolicy = true
    }
}

struct copaymentsParticipations: Codable {
    var hospitalLevel: String
    var copaymentShortStay: String
    var participationShortStay: String
    var copaymentHospitalization: String
    var participationHospitalization: String
    var copaymentMedicalConsultation: String
    var participationMedicalConsultation: String
    var copaymentOutsideHospitalServices: String
    var participationOutsideHospitalServices: String
}
