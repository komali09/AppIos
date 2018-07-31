//
//  EmergencyContactsWorker.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 08/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import RxSwift
import Contacts

class EmergencyContactsWorker {
    /**
     Asocia la foto de un contacto con el usuario en el dispostivo
     */
    func savePictureOfEmergencyContact(picture: IAUIImageView) -> Observable<String> {
        return Observable.create { observable in
            
            if FilesManager.createDirectoryInsideDocuments(name:UserDefaultsManager.shared.directoryPicturesEmergencyContacts) {
                let identifier = NSUUID().uuidString
                if FilesManager.saveImageInDirectoryInsideDocuments(directory: UserDefaultsManager.shared.directoryPicturesEmergencyContacts, name: "\(identifier).jpg", image: picture.image!) {
                    observable.onNext("\(identifier).jpg")
                } else {
                     observable.onError(NetworkingError.noData)
                }
            } else {
               observable.onError(NetworkingError.noData)
            }
           
            return Disposables.create()
        }
    }
    
    /**
     Realiza la peticion al servicio para agregar un contacto de emergencia
     */
    func addEmergencyContact(emergencyContactID: Int, picture: String, name: String, phone: String, email: String) ->  Observable<Bool> {
        let contact = EmergencyContact(ID: emergencyContactID, name: name, picture: picture, address: nil, email: email, phone: phone)
        
        IALoader.shared.show(LocalizableKeys.Loader.addEmergencyContact)
        return Observable.create { observable in
            let disposable = ServiceManager.addEmergencyContact(emergencyContact: contact).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la peticion al servicio para editar un contacto de emergencia
     */
    func editEmergencyContact(emergencyContactID: Int, picture: String, name: String, phone: String, email: String) ->  Observable<Bool> {
        let contact = EmergencyContact(ID: emergencyContactID, name: name, picture: picture, address: nil, email: email, phone: phone)
        
        IALoader.shared.show(LocalizableKeys.Loader.editEmergencyContact)
        return Observable.create { observable in
            let disposable = ServiceManager.editEmergencyContact(emergencyContact: contact).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la peticion al servicio para eliminar un contacto de emergencia
     */
    func deleteEmergencyContact(emergencyContactID: Int) ->  Observable<Bool> {
        IALoader.shared.show(LocalizableKeys.Loader.deleteEmergencyContact)
        return Observable.create { observable in
            let disposable = ServiceManager.deleteEmergencyContact(emergencyContactID: emergencyContactID).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la validación del nombre utilizada para editar un contacto de emergencia
     - parameter name: nombre a validar.
     */
    func validateName(_ name: String) -> TextFieldValidationState {
        if name.isEmpty {
            return .invalid(message: LocalizableKeys.EmergencyContacts.errorNameEmpty)
        } else {
            return .valid(message: "")
        }
    }
    
    /**
     Realiza la validación del teléfono utilizada para editar un contacto de emergencia
     - parameter phoneNumber: número de teléfono a validar.
     */
    func validatePhoneNumber(_ phoneNumber: String) -> TextFieldValidationState {
            if Util.validatePhoneNumberLength(phoneNumber) {
                return .valid(message: "")
            } else {
                return .invalid(message: phoneNumber.isEmpty ? LocalizableKeys.EmergencyContacts.errorPhoneEmpty : LocalizableKeys.EmergencyContacts.invalidPhoneNumber)
            }
    }
    
    /**
     Realiza la validación del email utilizada para editar un contacto de emergencia
     - parameter name: nombre a validar.
     */
    func validateEmail(_ email: String) -> TextFieldValidationState {
        if email.isEmpty || email == "" {
            return .notValidated
        }
        
        if Util.validateEmail(email) {
            return .valid(message: "")
        } else {
            return .invalid(message: LocalizableKeys.Profile.EditProfile.errorEmailInvalid)
        }
    }
    
    /**
     Método que obtiene los contactos del dispostivo
     */
    func getContactsFromDevice() -> [Contact]? {
        var contacts = [Contact]()
        
        let keys = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        let contactStore = CNContactStore()
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stopPointer) in
                let identifier = contact.identifier
                let name = "\(contact.givenName.capitalized) \(contact.familyName.capitalized)" 
                
                //Asignación y validación de email
                var email: String?
              
                if Util.validateEmail(contact.emailAddresses.first?.value.abbreviatingWithTildeInPath ?? "") {
                    email = contact.emailAddresses.first?.value.abbreviatingWithTildeInPath ?? ""
                }
                
                //Asignación y validación de teléfono
                let phoneWithoutFormat = contact.phoneNumbers.first?.value.stringValue ?? ""
                let phoneWithoutWhiteSpaces = phoneWithoutFormat.components(separatedBy: .whitespaces).joined()
                let phoneWithoutPlus = phoneWithoutWhiteSpaces.replacingOccurrences(of: "+", with: "")
                let phoneWithoutScript = phoneWithoutPlus.replacingOccurrences(of: "-", with: "")
                let phoneWithoutLeftParentheses = phoneWithoutScript.replacingOccurrences(of: "(", with: "")
                let phone = phoneWithoutLeftParentheses.replacingOccurrences(of: ")", with: "")
                
                //Asignación y validación de foto
                var picture: UIImage?
                
                if let imageData = contact.imageData {
                    picture = UIImage(data: imageData)
                }
                
                let contact = Contact(ID: identifier, name: name, picture: picture, email: email, phone: phone)
                
                contacts.append(contact)
            }
        } catch {
            return nil
        }
        
        return contacts
    }
    
    /**
     Método que agrupa los contactos por letra
     */
    func groupContactsByAlphabet(contacts: [Contact]) -> [String: [Contact]] {
        var groupContacts = [String: [Contact]]()
        
        let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        for index in 0...(alphabet.count - 1) {
            let contactsFiltered = contacts.filter({ (contact) -> Bool in
                return String(describing: contact.name!.lowercased().prefix(1)) == alphabet[index].lowercased()
            }).sorted {
                $0.name! <= $1.name!
            }
            
            if contactsFiltered.count > 0 {
                groupContacts[alphabet[index]] = contactsFiltered
            }
        }
        
        return groupContacts
    }
    
    /**
     Método que filtra y agrupa los contactos por texto
     */
    func groupContactsfiltered(by searchText: String, contacts: [Contact]) -> [String: [Contact]] {
        var groupContacts = [String: [Contact]]()
        
        let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        let contactsFiltered = contacts.filter { (contact) -> Bool in
            return contact.name!.lowercased().contains(searchText.lowercased())
        }
        
        for index in 0...(alphabet.count - 1) {
            let contactsFiltered = contactsFiltered.filter({ (contact) -> Bool in
                return String(describing: contact.name!.lowercased().prefix(1)) == alphabet[index].lowercased()
            }).sorted {
                $0.name! <= $1.name!
            }
            
            if contactsFiltered.count > 0 {
                groupContacts[alphabet[index]] = contactsFiltered
            }
        }
        
        return groupContacts
    }
}







