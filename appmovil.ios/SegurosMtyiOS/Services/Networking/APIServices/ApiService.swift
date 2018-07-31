//
//  ApiService.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Moya

extension TargetType {
    var parameterEncoding : Moya.ParameterEncoding { return URLEncoding.default }
    var timeout: TimeInterval { return 60.0 }
    var task : Task { return Task.requestPlain }
}

enum ApiService {
    case validateNumber(phone: String)
    
    case login(phone: String, password: String)
    
    case generateCodeToRecoverPassword(phone: String)
    
    case generateCodeToActiveAccount(phone: String)
    
    case getServerTimestamp

    case verifyCodeSMS(phone: String, code: String, totpCode: String, type: ValidationCodeProccessType)
    
    case renewPassword(phone: String, password: String, smsCode: String, totpCode: String)
    
    case changePassword(oldPassword: String, newPassword: String)
    
    case register(name: String, fatherLastName: String, motherLastName: String?, email: String, phone: String, password: String, date: String, policyId: String, certificateId: String?)
    
    case insurancePolicies()
    
    case insurancePolicyDetail(policyId: String, certificateId: String?)
    
    case setPrincipalPlan(policyId: String, certificateId: String?)
    
    case insurancePolicyBeneficiaries(policyId: String, certificateId: String?)
    
    case wallet(isTitularBeneficiare: Bool, nameBeneficiare: String?, fatherNameBeneficiare: String?, motherNameBeneficiare: String?, policyId: String, certificateId: String?)
    
    case certificate(policyId: String, certificateId: String?)
    
    case assistances(type: Int)
    
    case advisorInfo()
    
    case locations(isPlanIncluded: Bool, serviceTypes: [ServiceType], state:Int, doctorTypes:[Specialty], searchTerms:String?)
    
    case locationDetail(businessId: String, providerId: String)
    
    case addLocationToFavorites(businessId: String, providerId: String)
    
    case removeLocationFromFavorites(businessId: String, providerId: String)
    
    case favoriteLocations(state:Int)
    
    case locationSearchSuggestions(searchTerms:String, state:Int)
    
    case states()
    
    case doctorSpecialities()

    case editProfile(email: String)
    
    case logout()
    
    case getEmergencyContacts()
    
    case addEmergencyContact(emergencyContact: EmergencyContact)
    
    case editEmergencyContact(emergencyContact: EmergencyContact)
    
    case deleteEmergencyContact(emergencyContactID: Int)
    
    case emergencyPetition(type: Int)
    
    case validatePolicy(policy: String, certificate: String?)
    
    case addPolicy(policy: String, certificate: String?)
    
    case validatePolicyRegister(policy: String, certificate: String?)
    
    case getBenefitsHospital(providerId: String)
    
    case getCoveragesOfPolicy(policy: String, certificate: String?)
    
}

extension ApiService : TargetType {
    var baseURL: URL {
        var url:String = ""
        switch self {
        default:
            #if STAGE
                url = "https://148.243.174.54/AppMovil/seguros-monterrey"
            #elseif TESTING
                url = "https://148.243.174.61/AppMovil/seguros-monterrey"
            #elseif PROD
                url = "https://www.smnyl-clientes.com.mx/AppMovil2/seguros-monterrey"
            #endif
        }
        debugPrint("📡 Making request to base url: \(url)")
        return URL(string: url)!
    }
   
    var path: String {
        switch self {
        case .validateNumber:
            return "/v1/users/validate-number"
            
        case .login:
            return "/v1/users/login"
            
        case .generateCodeToRecoverPassword, .generateCodeToActiveAccount:
            return "/v1/sms/generate-code"
            
        case .getServerTimestamp:
            return "/v1/users/sync"
            
        case .verifyCodeSMS:
            return "/v1/sms/verifyCode"
            
        case .renewPassword:
            return "v1/users/renew-password"
            
        case .changePassword:
            return "/v1/users/change-password"
            
        case .register:
            return "/v1/users/register"
            
        case .insurancePolicies:
            return "/v1/policies/find-policies"
            
        case .insurancePolicyDetail:
            return "/v1/policies/find-policy-detail"
            
        case .setPrincipalPlan:
            return "/v1/policies/setPrincipalPlan"
            
        case .insurancePolicyBeneficiaries:
            return "/v1/policies/find-insured"
            
        case .wallet:
            return "/v1/pkpass"
            
        case .certificate:
            return "/v1/policies/get-collective-policy-contract"
            
        case .assistances:
            return "/v1/assistance/find-assistance-info"
            
        case .advisorInfo:
            return "/v1/adviser/get-adviser-data"
            
        case .locations:
            return "/v1/locations/get-location-list"
            
        case .locationDetail:
            return "/v1/locations/get-location-detail"
            
        case .addLocationToFavorites:
            return "/v1/favorites/addFavorite"
        
        case .removeLocationFromFavorites:
            return "/v1/favorites/deleteFavorite"
            
        case .favoriteLocations:
            return "/v1/favorites/get-favorites"
            
        case .locationSearchSuggestions:
            return "/v1/locations/find-location-name-list"
            
        case .states:
            return "/v1/states/get-states"
            
        case .doctorSpecialities:
            return "/v1/business-category/get-doctor-list"

        case .editProfile:
            return "/v1/users/edit-profile"

        case .logout:
            return "/v1/users/logout"
            
        case .getEmergencyContacts:
            return "/v1/emergencycontact/getEmergencyContact"
            
        case .addEmergencyContact:
            return "/v1/emergencycontact/addEmergencyContact"
            
        case .editEmergencyContact:
            return "/v1/emergencycontact/editEmergencyContact"
            
        case .deleteEmergencyContact:
            return "/v1/emergencycontact/delete-emergency-contact"
            
        case .emergencyPetition:
            return "/v1/emergency/send-message"
        
        case .validatePolicy:
            return "/v1/policies/verify-policy"
            
        case .addPolicy:
            return "/v1/policies/add-policy"
            
        case .validatePolicyRegister:
            return "/v1/policies/verify-policy"
            
        case .getBenefitsHospital:
            return "/v1/locations/get-benefits-hospital"
            
        case .getCoveragesOfPolicy:
            return "/v1/policies/find-coverage-info"
        
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .editEmergencyContact, .setPrincipalPlan:
            return .put
        case .deleteEmergencyContact, .removeLocationFromFavorites:
            return .delete
        case .getServerTimestamp:
            return .get
        default:
            return .post
        }
    }
    
    var headers: [String: String]? {
        var parameters: [String : String] = ["udid": UserDefaultsManager.shared.udid]
        switch self {
        case .validateNumber, .login, .generateCodeToRecoverPassword, .generateCodeToActiveAccount, .verifyCodeSMS, .renewPassword, .register:
            break
        default:
            parameters["token"] = KeychainManager.shared.sessionToken
        }
        return parameters
    }
    
    var task: Task {
        switch self {
        case .validateNumber(let phoneNumber):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .login(let phoneNumber, let password):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            parameters["pass"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .generateCodeToRecoverPassword(let phoneNumber):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            parameters["action"] = "1"
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .generateCodeToActiveAccount(let phoneNumber):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            parameters["action"] = "2"
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getServerTimestamp:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
            
        case .verifyCodeSMS(let phoneNumber, let code, let totpCode, let type):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            parameters["action"] = "\(type.rawValue)" //1 para recuperar contraseña o 2 para activar cuenta
            parameters["code"] = code
            parameters["token3"] = totpCode
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .renewPassword(let phoneNumber, let password, let smsCode, let totpCode):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = phoneNumber
            parameters["pass"] = password
            parameters["smsCode"] = smsCode
            parameters["token3"] = totpCode
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .changePassword(let oldPass, let newPassword):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["old_pass"] = oldPass
            parameters["new_pass"] = newPassword
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .register(let name, let fatherLastName, let motherLastName, let email, let phone, let password, let date, let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["name"] = name
            parameters["father_lastname"] = fatherLastName
            parameters["mother_lastname"] = motherLastName ?? NSNull()
            parameters["email"] = email
            parameters["phone"] = phone
            parameters["pass"] = password
            parameters["birthday"] = date
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .insurancePolicies:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case .insurancePolicyDetail(let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .setPrincipalPlan(let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .insurancePolicyBeneficiaries(let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .wallet(let isTitularBeneficiare, let nameBeneficiare, let fatherNameBeneficiare, let motherNameBeneficiare, let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            
            if isTitularBeneficiare == false {
                parameters["name"] = nameBeneficiare
                parameters["fatherLastName"] = fatherNameBeneficiare
                parameters["motherLastName"] = motherNameBeneficiare
            }
         
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .certificate(let policyId, let certificateId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["policy_id"] = policyId
            parameters["certificate_id"] = certificateId
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .assistances(let type):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["id"] = type
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .advisorInfo:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["email"] = UserDefaultsManager.shared.userInfo?.email ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .locations(let isPlanIncluded, let locationTypes, let state, let doctorTypes, let searchTerms):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["plan_included"] = isPlanIncluded
            parameters["ltype"] = locationTypes.map { $0.rawValue }
            parameters["doctor_types"] = doctorTypes.map { $0.id }
            parameters["location"] = state
            if let search = searchTerms {
                parameters["search"] = search
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .locationDetail(let businessId, let providerId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["businessId"] = businessId
            parameters["providerId"] = providerId
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .addLocationToFavorites(let businessId, let providerId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["businessId"] = businessId
            parameters["providerId"] = providerId
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .removeLocationFromFavorites(let businessId, let providerId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["businessId"] = businessId
            parameters["providerId"] = providerId
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .favoriteLocations(let state):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["location"] = state
            parameters["sToken"] = KeychainManager.shared.sessionToken
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .locationSearchSuggestions(let searchTerms, let state):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["name"] = searchTerms
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["location"] = state
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .states:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .doctorSpecialities:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

        case .editProfile(let email):
            var parameters: [String: Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["email"] = email
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .logout:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getEmergencyContacts:
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .addEmergencyContact(let emergencyContact):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            
            var contact = [String: Any]()
            contact["id"] = "\(String(describing: emergencyContact.ID ?? 0))"
            contact["picture"] = emergencyContact.picture ?? ""
            contact["name"] = emergencyContact.name ?? ""
            contact["phone"] = emergencyContact.phone ?? ""
            contact["email"] = emergencyContact.email ?? ""
            
            parameters["e_contact"] = contact
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .editEmergencyContact(let emergencyContact):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            
            var contact = [String: Any]()
            contact["id"] = "\(String(describing: emergencyContact.ID ?? 0))"
            contact["picture"] = emergencyContact.picture ?? ""
            contact["name"] = emergencyContact.name ?? ""
            contact["phone"] = emergencyContact.phone ?? ""
            contact["email"] = emergencyContact.email ?? ""
            
            parameters["e_contact"] = contact
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .deleteEmergencyContact(let emergencyContactID):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["idEmergencyContact"] = emergencyContactID
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .emergencyPetition(let type):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["type"] = type
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .validatePolicy(let policy, let certificate):
            var parameters: [String: Any] = self.getBasicRequestParameters()
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["policy_id"] = policy
            if certificate != nil && certificate != "" {
                parameters["certificate_id"] = certificate!
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case .addPolicy(let newPolicy, let certificate):
            var parameters: [String: Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["policy_id"] = newPolicy
            parameters["certificate_id"] = certificate ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .validatePolicyRegister(let policy, let certificate):
            var parameters: [String: Any] = self.getBasicRequestParameters()
            parameters["policy_id"] = policy
            parameters["certificate_id"] = certificate
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case .getBenefitsHospital(let providerId):
            var parameters: [String : Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["sToken"] = KeychainManager.shared.sessionToken
            parameters["providerId"] = providerId
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .getCoveragesOfPolicy(let policy, let certificate):
            var parameters: [String: Any] = self.getBasicRequestParameters()
            parameters["phone"] = KeychainManager.shared.phoneNumber ?? ""
            parameters["policy_id"] = policy
            parameters["certificate_id"] = certificate
            parameters["sToken"] = KeychainManager.shared.sessionToken
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var sampleData: Data {
        switch self {
        case .states:
            return stubbedResponse("states")
        case .locations, .favoriteLocations:
            return stubbedResponse("locations")
        case .locationSearchSuggestions:
            return stubbedResponse("location-name-list")
        case .insurancePolicies:
            return stubbedResponse("insurancePolicies")
        case .advisorInfo:
            return stubbedResponse("advisor")
        case .doctorSpecialities:
            return stubbedResponse("doctorList")
        case .emergencyPetition:
            return stubbedResponse("emergencyCall")
        case .getBenefitsHospital:
            return stubbedResponse("benefits")
        default:
            return stubbedResponse("coveragesIndividual")
        }
    }
    
    fileprivate func stubbedResponse(_ filename: String) -> Data! {
        class TestClass { }
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
}

extension ApiService {
    fileprivate func getBasicRequestParameters() -> [String : Any] {
        let device: [String : Any] = self.getDeviceDictionary()
        let ipAddress:String = ReachabilityManager.getWiFiAddress() ?? ""
        var latitude:String = "0.00"
        var longitude:String = "0.00"
        if let lat = LocationManager.shared.location?.coordinate.latitude,
            let lon = LocationManager.shared.location?.coordinate.longitude {
            latitude = "\(lat)"
            longitude = "\(lon)"
        }
        
        let appVersion:String = DeviceDetector.getVersionApp()
        
        var parameters: [String : Any] = ["device" : device]
        parameters["ip"] = ipAddress
        parameters["lat"] = latitude
        parameters["lon"] = longitude
        parameters["appVersion"] = appVersion
        
        return parameters
    }
    
    fileprivate func getDeviceDictionary() ->  [String : Any] {
        let udid:String = UserDefaultsManager.shared.udid
        var device: [String : Any] = ["udid" : udid]
        device["name"] = UIDevice().type.rawValue
        device["version"] = DeviceDetector.getVersionApp()
        return device
    }
}
