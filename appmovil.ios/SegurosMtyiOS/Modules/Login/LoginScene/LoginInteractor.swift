//
//  LoginInteractor.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/1/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxSwift

protocol LoginBusinessLogic {
    func preloadData()
    func validatePhoneNumber(_ phoneNumber: String)
    func validatePassword(_ password: String)
    func login()
}

protocol LoginDataStore {
    var phoneNumber: String? { get set }
    var password: String? { get set }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    
    // MARK: DataStore
    var disposableBag: DisposeBag = DisposeBag()
    var phoneNumber:String?
    var password:String?
    var isWorking:Bool = false
    
    // MARK: - Interactor Methods
    /**
     Precarga los datos necesarios en caso de que el usuario ya haya iniciado sesión anteriormente.
     */
    func preloadData() {
        if let phoneNumber = KeychainManager.shared.phoneNumber {
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
        if isWorking {
            return
        }
        
        if phoneNumber.count != 10 {
            let response = Login.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: "", isFirstEntry: false, error: NetworkingError.noData)
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
        
        self.isWorking = true
        worker?.validatePhoneNumber(number).subscribe({ [weak self] event in
            self?.isWorking = false
            self?.phoneNumber = number
            switch event {
            case .next(let result):
                let response = Login.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: result.fullName, isFirstEntry: result.isFirstEntry, error: nil)
                self?.presenter?.presentPhoneNumberValidation(response: response)
            case .error(let error):
                let response = Login.ValidatePhoneNumber.Response(phoneNumber: phoneNumber, userName: "", isFirstEntry: false, error: error)
                self?.presenter?.presentPhoneNumberValidation(response: response)
            default:
                break
            }
        }).disposed(by: self.disposableBag)
    }
    
    /**
     Es disparado cuando se necesita validar la contraseña utilizada para iniciar sesión
     - parameter password: contraseña a validar.
     */
    func validatePassword(_ password: String) {
        if worker == nil {
            worker = LoginWorker()
        }
        if let result = worker?.validatePassword(password) {
            self.password = password
            self.presenter?.presentPasswordValidation(validationState: result)
        }
    }
    
    /**
     Es disparado cuando se necesita realizar un inicio de sesión
     */
    func login() {        
        if worker == nil {
            worker = LoginWorker()
        }
        if isWorking {
            return
        }
        self.isWorking = true
        
        worker?.login(phoneNumber: self.phoneNumber ?? "", password: self.password ?? "").subscribe({ [weak self] event in
            self?.isWorking = false
            var resultError:Error?
            switch event {
            case .next(let result):
                self?.worker?.saveLoggedInUser(response: result, phoneNumber: self?.phoneNumber ?? "")
            case .error(let error):
                resultError = error
                debugPrint(error)
                
            default:
                break
            }
            let response = Login.Login.Response(error: resultError)
            self?.presenter?.presentLogin(response: response)
            
        }).disposed(by: self.disposableBag)
    }
}