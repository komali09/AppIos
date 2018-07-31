//
//  AddPolicyPresenter.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 17/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol AddPolicyPresentationLogic {
    func presentPolicyValidationError(response: AddPolicy.AddPolicyValid.Response)
    func presentPolicyValidationSuccess(response: AddPolicy.AddPolicyValid.Response)
    func presentAddIndividualPolicy()
    func presentAddCollectivePolicy() 
}

class AddPolicyPresenter: AddPolicyPresentationLogic {
    weak var viewController: (AddPolicyDisplayLogic & ExpiredSessionDisplayLogic & ErrorDisplayLogic)?
    
    var type: PolicyType?
    
    // MARK: Do something
    
    func presentPolicyValidationError(response: AddPolicy.AddPolicyValid.Response) {
        var message = ""
        switch response.type {
        case .individual:
            message = LocalizableKeys.Register.invalidIndividualPolicy
        default:
            message = LocalizableKeys.Register.invalidCertificate
        }
        var type: PolicyType = response.type
        
        switch response.error! {
        case NetworkingError.noInternet:
            viewController?.displayError(with: LocalizableKeys.Profile.EditProfile.errorNoInternet)
            return
        case NetworkingError.noSuccessStatusCode(let code , _):
            // Poliza correcta pero certificado incorrecto
            if code == 1 {
                type = .collective
                self.viewController?.displayCertificatePolicy()
                message = LocalizableKeys.Profile.AddPolicy.Error.emptyCertificate
            }
        default:
            break
        }
        let state = TextFieldValidationState.invalid(message: message)
        let viewModel = AddPolicy.AddPolicyValid.ViewModel(type: type, validationState: state)
        self.viewController?.displayPolicyValidation(viewModel: viewModel)
    }
    
    func presentPolicyValidationSuccess(response: AddPolicy.AddPolicyValid.Response) {
        let state = TextFieldValidationState.valid(message: "")
        let type = response.type
        let viewModel = AddPolicy.AddPolicyValid.ViewModel(type: type, validationState: state)
        self.viewController?.displayPolicyValidation(viewModel: viewModel)
    }
    
    func presentAddIndividualPolicy() {
        self.viewController?.displayAddIndividualPolicy()
    }
    
    func presentAddCollectivePolicy() {
        self.viewController?.displayAddCollectivePolicy()
    }

}

/**
 Extensión para mostrar alerta con un tipo de error
 */
extension AddPolicyPresenter: ErrorPresentationLogic {
    func presentError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            viewController?.displayError(with: LocalizableKeys.Profile.EditProfile.errorNoInternet)
        case VerifyCollectiveError.notValidCertificate:
            viewController?.displayError(with: LocalizableKeys.Register.invalidPolicyColective)
        case NetworkingError.noSuccessStatusCode(let code , _):
            switch code{
            case 1:
                viewController?.displayError(with: LocalizableKeys.Register.invalidPolicyColective)
            case 2:
                viewController?.displayError(with: LocalizableKeys.Register.invalidPolicy)
            default:
                viewController?.displayError(with: LocalizableKeys.General.serviceError)
            }
        default:
            viewController?.displayError(with: LocalizableKeys.General.serviceError)
        }
    }
}

/**
 Extensión para mostrar alerta de expiración de token
 */
extension AddPolicyPresenter : ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        self.viewController?.displayExpiredSession()
    }
}
