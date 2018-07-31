//
//  Util.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/4/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

class Util {
    
    class func getAppVersion() -> String {
        #if PROD
            return "\(LocalizableKeys.General.version) \( DeviceDetector.getVersionApp())"
        #elseif TESTING
            return "\(LocalizableKeys.General.version) \(DeviceDetector.getVersionApp()) (\(getBuild())) QA"
        #else
            return "\(LocalizableKeys.General.version) \(DeviceDetector.getVersionApp()) (\(getBuild())) STAGE"
        #endif
    }
    
    
    class func getBuild() -> String {
        return Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
    }
   
    class func getMaskedPhoneNumber(_ phoneNumber:String) -> String {
        if phoneNumber.count == 10 {
            let lastDigits = phoneNumber.suffix(4)
            let maskedCard = "******\(lastDigits)"
            return maskedCard
        } else {
            return phoneNumber
        }
    }
    
    class func validatePassword(_ password:String) -> Bool {
        let regexstr:String = "^(?=.*[A-Z])(?=.*\\d)(?=.*[À-ÿ$@$¡!%*¿?&#.:='\"´¨~\\-_,;+^¬°\\\\/|{}()<>\\s])[A-zÀ-ÿ\\d$@$¡!%*¿?&#.:='\"´¨~\\-_,;+^¬°\\\\/|{}()<>\\s]{8,}$"
        return evaluate(string: password, with: regexstr)
    }
    
    class func validateEmail(_ email: String) -> Bool {
        let regexstr:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return evaluate(string: email, with: regexstr)
    }
    
    class func validateName(_ value: String) -> Bool {
        let characterset = CharacterSet(charactersIn: "aábcdeéfghiíjklmnñoópqrstuúvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ., ")
        if value.rangeOfCharacter(from: characterset.inverted) != nil || value == "" {
            return false
        } else {
            return true
        }
    }
    
    class func validatePhoneNumberLength(_ value: String) -> Bool {
        return value.count == 10 ? true : false
    }
    
    class func validatePolicy(_ value: String) -> Bool {
        if value.count > 0 && value.count <= 15 {
            return true
        } else {
            return false
        }
    }
    
    class func validateCertificate(_ value: String) -> Bool {
        if value.count > 0 && value.count <= 15 {
            return true
        } else {
            return false
        }
    }
    
    fileprivate class func evaluate(string:String, with regexstr:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexstr)
            let nsString = string as NSString
            let results = regex.matches(in: string, range: NSRange(location: 0, length: nsString.length))
            return results.map({ nsString.substring(with: $0.range)}).count > 0
        } catch let error {
            debugPrint("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}
