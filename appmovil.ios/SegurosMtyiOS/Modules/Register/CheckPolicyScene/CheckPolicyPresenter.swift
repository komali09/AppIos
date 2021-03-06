//
//  CheckPolicyPresenter.swift
//  SegurosMtyiOS
//
//  Created by Mariana on 19/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol CheckPolicyPresentationLogic {
    func presentPolicyValidationError(response: CheckPolicy.RegisterPolicy.Response)
    func presentPolicyValidationSuccess(response: CheckPolicy.RegisterPolicy.Response)
}

class CheckPolicyPresenter: CheckPolicyPresentationLogic {
    weak var viewController: (CheckPolicyDisplayLogic & ErrorDisplayLogic)?
    
    var intent: Bool = false
    var type: PolicyType?
    
    // MARK: Do something
    
    func presentPolicyValidationError(response: CheckPolicy.RegisterPolicy.Response) {
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
        let viewModel = CheckPolicy.RegisterPolicy.ViewModel(type: type, validationState: state)
        self.viewController?.displayPolicyValidation(viewModel: viewModel)
    }
    
    func presentPolicyValidationSuccess(response: CheckPolicy.RegisterPolicy.Response) {
        let state = TextFieldValidationState.valid(message: "")
        let type = response.type
        let viewModel = CheckPolicy.RegisterPolicy.ViewModel(type: type, validationState: state)
        self.viewController?.displayPolicyValidation(viewModel: viewModel)
    }
}

extension CheckPolicyPresenter : ErrorPresentationLogic {
    func presentError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            viewController?.displayError(with: LocalizableKeys.Profile.EditProfile.errorNoInternet)
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
