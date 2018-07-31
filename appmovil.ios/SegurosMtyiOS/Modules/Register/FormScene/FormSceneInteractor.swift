//
//  FormSceneInteractor.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 18/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import Foundation
import RxSwift

protocol FormSceneBusinessLogic {
    func validatePassword(_ attemptOfOriginalPassword: String)
    func validateRepeatedPassword(_ password: String, repeatedPassword: String)
    func validateName(_ name: String, type: TypeName)
    func validateMail(_ mail: String)
    func validatePhone(_ phone: String)
    func validateDate(_ date: Date?)
    func register()
}

protocol FormSceneDataStore {
    var name: String? { get set }
    var fatherLastName: String? { get set }
    var motherLastName: String? { get set }
    var password: String? { get set }
    var email: String? { get set }
    var phone: String? { get set }
    var birthDate: Date? { get set }
    var policy: String? { get set }
    var certificate: String? {get set}
}

class FormSceneInteractor: FormSceneBusinessLogic, FormSceneDataStore {
    var presenter: (FormScenePresentationLogic & ErrorPresentationLogic)?
    var worker: RegisterWorker?
    var disposableBag: DisposeBag = DisposeBag()
    // MARK: DataStore
    
    var name: String?
    var fatherLastName: String?
    var motherLastName: String?
    var password: String?
    var email: String?
    var phone: String?
    var birthDate: Date?
    var policy: String?
    var certificate: String?
    
    // MARK: Do something
    
    func validatePassword(_ attemptOfOriginalPassword: String) {
        worker = RegisterWorker()
        let validationState = worker?.validatePassword(attemptOfOriginalPassword) ?? .notValidated
        presenter?.presentMessageForValidatingPassword(validationState: validationState)
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) {
        worker = RegisterWorker()
        let validationState = worker?.validateBothPasswordString(password, repeatedPasswordString: repeatedPassword) ?? .notValidated
        if validationState == .valid(message: "") {
            self.password = password
        }else {
            self.password = nil
        }
        presenter?.presentMessageForRepeatPassword(validationState: validationState)
    }
    
    func validateName(_ name: String, type: TypeName){
        worker = RegisterWorker()
        let validationState = worker?.validateName(name, type: type) ?? .notValidated
        if validationState == .valid(message: "") {
            switch type {
            case .name:
                self.name = name
            case .firtsName:
                self.fatherLastName = name
            case .secondName:
                self.motherLastName = name
            }
        }else {
            switch type {
            case .name:
                self.name = nil
            case .firtsName:
                self.fatherLastName = nil
            case .secondName:
                self.motherLastName = nil
            }
        }
        presenter?.presentMessageForValidatingName(validationState: validationState , type: type)
    }
    
    func validateMail(_ email: String){
        worker = RegisterWorker()
        let validationState = worker?.validateMail(email) ?? .notValidated
        if validationState == .valid(message: "") {
            self.email = email
        } else {
            self.email = nil
        }
        presenter?.presentMessageForMail(validationState: validationState)
    }
    
    func validatePhone(_ phone: String){
        worker = RegisterWorker()
        let validationState = worker?.validatePhone(phone) ?? .notValidated

        if validationState == .valid(message: "") {
            self.phone = phone
        } else {
            self.phone = nil
        }
        presenter?.presentMessageForPhone(validationState: validationState)
    }
    
    func validateDate(_ date: Date?) {
        guard let date = date else {
            self.birthDate = nil
            return
        }
        self.birthDate = date
        presenter?.presentMessageForDate(validationState: .valid(message: ""))
    }
    
    func register() {
        
        worker = RegisterWorker()
        worker?.register(name: name! , fatherLastName: fatherLastName!, motherLastName: motherLastName, email: email!, phone: phone!, password: password!, date: birthDate!, policyId: policy!, certificateId: certificate).subscribe({ (event) in
            switch event {
            case .next(_):
                
                self.presenter?.presentRegisterSuccess()
            case .error(let error):
                self.presenter?.presentError(error)
            default:
                break
            }
        }).disposed(by: disposableBag)
    }
}