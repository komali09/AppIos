//
//  KeychainManager.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/30/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared: KeychainManager = KeychainManager()
    private var keychain: KeychainSwift
    
    init() {
        keychain = KeychainSwift()
    }
    
    private func getValue(settingName:String = #function) -> String? {
        guard let setting = keychain.get(settingName) else { return nil }
        return setting
    }
    
    private func addOrUpdateValue(_ newValue: String?, settingName: String = #function) {
        if let value = newValue {
            debugPrint("🔵 Saving Keychain Setting \(settingName): \(String(describing: newValue))")
            keychain.set(value, forKey: settingName)
        } else {
            debugPrint("🔵 Deleting Keychain Setting \(settingName): \(String(describing: newValue))")
            keychain.delete(settingName)
        }
    }
    
    /**
     Obtiene o asigna el telefono del usuario que usa para iniciar sesión
     */
    var phoneNumber: String? {
        get {
            return self.getValue()
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene o asigna el token del usuario para realizar peticiones
     */
    var sessionToken: String? {
        get {
            return self.getValue()
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
}
