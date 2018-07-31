//
//  RecoverPasswordInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 06/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxSwift

protocol RecoverPasswordBusinessLogic {
    func preloadData()
    func validatePhoneNumber(_ phoneNumber: String)
}

protocol RecoverPasswordDataStore {
    var phoneNumber: String? { get set }
    var recoverPasswordType: RecoverPasswordType { get set }
    var isValidPhoneNumber: Bool { get set }
}

class RecoverPasswordInteractor: RecoverPasswordBusinessLogic, RecoverPasswordDataStore {
    var presenter: RecoverPasswordPresentationLogic?
    var worker: LoginWorker?
    
    var disposableBag: DisposeBag = DisposeBag()
    
    var isValidPhoneNumber: Bool = false
    
    // MARK: DataStore
    public var phoneNumber: String?
    public var recoverPasswordType: RecoverPasswordType = .reset
    
    // MARK: Do something
    
    // MARK: - Interactor Methods
    /**
     Precarga los datos necesarios en caso de que el usuario ya haya iniciado sesión anteriormente.
     */
    func preloadData() {
        if let phoneNumber = self.phoneNumber {
            self.validatePhoneNumber(phoneNumber)
        }
    }
    
    /**
     Es disparado cuando se necesita validar el número telefonico utilizado para iniciar sesión
     - parameter phoneNumber: Número de teléfono a validar.
     */
    func validatePhoneNumber(_ phoneNumber: String) {
        if worker == nil {
            worker = LoginWorker()
        }
        self.isValidPhoneNumber = false
        
        if phoneNumber.count != 10 {
            let response = RecoverPassword.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: "", error: NetworkingError.noData)
            self.presenter?.presentPhoneNumberValidation(response: response)
            return
        }
        
        var number = phoneNumber
        if number.contains("*") {
            let originPhone = Array(self.phoneNumber!)
            let newPhone = Array(phoneNumber)
            number = ""
            for position in 0...9 {
                if originPhone[position] == newPhone[position]{
                    number += String(originPhone[position])
                } else {
                    if newPhone[position] == "*" {
                        number += String(originPhone[position])
                    } else {
                        number += String(newPhone[position])
                    }
                }
            }
        }
        
        worker?.validatePhoneNumber(number).subscribe({ [weak self] event in
            switch event {
            case .next(let result):
                self?.isValidPhoneNumber = true
                self?.phoneNumber = number
                let response = RecoverPassword.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: result.fullName, error: nil)
                self?.presenter?.presentPhoneNumberValidation(response: response)
            case .error(let error):
                self?.isValidPhoneNumber = false
                let response = RecoverPassword.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: "", error: error)
                self?.presenter?.presentPhoneNumberValidation(response: response)
            default:
                break
            }
        }).disposed(by: self.disposableBag)
    }
}