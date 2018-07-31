//
//  RecoverPasswordPresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 06/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol RecoverPasswordPresentationLogic {
    func presentPhoneNumberValidation(response: RecoverPassword.ValidatePhoneNumber.Response)
}

class RecoverPasswordPresenter: RecoverPasswordPresentationLogic {
    weak var viewController: RecoverPasswordDisplayLogic?
    
    // MARK: Do something
    
    // MARK: - Presenter Methods
    /**
     Presenta el resultado de la validación del numero telefonico, realiza la preparación adecuada dependiendo si es un dato válido o no.
     */
    func presentPhoneNumberValidation(response: RecoverPassword.ValidatePhoneNumber.Response) {
        
        var validationState:TextFieldValidationState = .notValidated
        var message:String?
        var phoneNumber:String = response.phoneNumber
        
        if let error = response.error {
            switch error {
            case NetworkingError.noInternet:
                message = LocalizableKeys.General.noInternet
            case NetworkingError.unknown:
                message = LocalizableKeys.General.serviceError
            case WorkerError.noInput:
                validationState = .notValidated
            default:
                validationState = .invalid(message: LocalizableKeys.Login.invalidNumber)
            }
            
        } else {
            phoneNumber = Util.getMaskedPhoneNumber(response.phoneNumber)
            validationState = .valid(message: String(format: LocalizableKeys.Login.welcomeUsername, response.userName))
        }
        let viewModel = RecoverPassword.ValidatePhoneNumber.ViewModel(phoneNumber: phoneNumber, validationState: validationState, alertString: message)
        viewController?.displayPhoneNumberValidation(viewModel: viewModel)
    }
}
