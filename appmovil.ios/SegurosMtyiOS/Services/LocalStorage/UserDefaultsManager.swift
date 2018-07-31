//
//  UserDefaultsManager.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/4/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private func getValueOrDefault<T>(defaultValue: T, settingName:String = #function) -> T {
        let defaults = UserDefaults.standard
        guard let setting = defaults.object(forKey: settingName) as? T
            else {
                self.addOrUpdateValue(defaultValue, settingName:settingName)
                return defaultValue
        }
        
        return setting
    }
    
    private func addOrUpdateValue<T>(_ newValue: T?, settingName: String = #function) {
        debugPrint("🔵 Saving Setting \(settingName): \(String(describing: newValue))")
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: settingName)
        defaults.synchronize()
    }
}

extension UserDefaultsManager{
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    /**
     Obtiene o asigna si se ha mostrado la pantalla de tutorial
     */
    var isTutorialShown: Bool {
        get {
            return self.getValueOrDefault(defaultValue:false)
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene o asigna la llave pública que se necesita pra cifrar con RSA los datos
     */
    var publicKeyToCipherRSA: String {
        get {
            return self.getValueOrDefault(defaultValue:"")
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene el identificador unico (por instalación) del dispositivo
     */
    var udid: String {
        get {
            return self.getValueOrDefault(defaultValue:NSUUID().uuidString)
        }
    }
    
    /**
     Obtiene o asigna la latitud de ubicacion del usuario
     */
    var userLocatinLatitude: String {
        get {
            return self.getValueOrDefault(defaultValue:"")
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene o asigna la longitud de ubicacion del usuario
     */
    var userLocatinLongitude: String {
        get {
            return self.getValueOrDefault(defaultValue:"")
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene el nombre de la carpeta donde se alojan las fotos de los contactos de emergencia
     */
    var directoryPicturesEmergencyContacts: String {
        get {
            return self.getValueOrDefault(defaultValue:"picturesEmergencyContacts")
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Obtiene el nombre de la carpeta donde se alojan las fotos de los contactos de emergencia
     */
    var userInfo: UserInfo? {
        get {
            let jsonString = self.getValueOrDefault(defaultValue: "")
            guard !jsonString.isEmpty,
                let jsonData = jsonString.data(using: .utf8)
                else { return nil }

            let decoder = JSONDecoder()
            return try? decoder.decode(UserInfo.self, from: jsonData)
        }
        set {
            if let info = newValue {
                let encoder = JSONEncoder()
                if let jsonString = try? encoder.encode(info) {
                    self.addOrUpdateValue(jsonString.toString())
                }
            }
        }
    }
    
    /**
     Obtiene o asigna si es la primera vez que se piden permisos de acceder a los contactos del dispositivo
     */
    var isFirstAccessContacts: Bool {
        get {
            return self.getValueOrDefault(defaultValue:true)
        }
        set {
            self.addOrUpdateValue(newValue)
        }
    }
    
    /**
     Borra toda la informacion relacionada con el usuario 
     */
    func deleteAll() {
        self.publicKeyToCipherRSA = ""
        KeychainManager.shared.sessionToken = nil
    }
    
}
