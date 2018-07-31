//
//  EditEmergencyContactPresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 08/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol EditEmergencyContactPresentationLogic {
    func presentNameValidation(validationState: EditEmergencyContact.ValidateName.Response)
    func presentPhoneNumberValidation(validationState: EditEmergencyContact.ValidatePhoneNumber.Response)
    func presentEmailValidation(validationState: EditEmergencyContact.ValidateEmail.Response)
    func presentEmergencyContact(response: EditEmergencyContact.SetupEmergencycontact.Response)
    func presentEditEmergencyContact(response: EditEmergencyContact.EditEmergencyContact.Response)
    func presentDeleteEmergencyContact(response: EditEmergencyContact.DeleteEmergencyContact.Response)
    func presentSavePictureEmergencyContact(response: EditEmergencyContact.SavePictureEmergencyContact.Response)
}

class EditEmergencyContactPresenter: EditEmergencyContactPresentationLogic {
    weak var viewController: (EditEmergencyContactDisplayLogic & ExpiredSessionDisplayLogic & ErrorDisplayLogic)?
    
    // MARK: Do something
    func presentEmergencyContact(response: EditEmergencyContact.SetupEmergencycontact.Response) {
        let viewModel = EditEmergencyContact.SetupEmergencycontact.ViewModel(emergencyContact: response.emergencyContact)
        self.viewController?.displaySetupEmergencyContact(viewModel: viewModel)
    }
    
    func presentNameValidation(validationState: EditEmergencyContact.ValidateName.Response) {
        let viewModel = EditEmergencyContact.ValidateName.ViewModel(validationState: validationState.validationState)
        self.viewController?.displayNameValidation(viewModel: viewModel)
    }
    
    func presentPhoneNumberValidation(validationState: EditEmergencyContact.ValidatePhoneNumber.Response) {
        let viewModel = EditEmergencyContact.ValidatePhoneNumber.ViewModel(validationState: validationState.validationState)
        self.viewController?.displayPhoneNumberValidation(viewModel: viewModel)
    }
    
    func presentEmailValidation(validationState: EditEmergencyContact.ValidateEmail.Response) {
        let viewModel = EditEmergencyContact.ValidateEmail.ViewModel(validationState: validationState.validationState)
        self.viewController?.displayEmailValidation(viewModel: viewModel)
    }
    
    /**
     Método que manda al viewController el ViewModel para notificar el resultado de la edición de un contacto de emergencia
     Parameters:
     - response: ViewModel con un bool de success o failed
     */
    func presentEditEmergencyContact(response: EditEmergencyContact.EditEmergencyContact.Response) {
        let viewModel = EditEmergencyContact.EditEmergencyContact.ViewModel(isSuccess: response.isSuccess)
        self.viewController?.displayEditEmergencyContact(viewModel: viewModel)
    }
    
    /**
     Método que manda al viewController el ViewModel para notificar el resultado de la eliminación de un contacto de emergencia
     Parameters:
     - response: ViewModel con un bool de success o failed
     */
    func presentDeleteEmergencyContact(response: EditEmergencyContact.DeleteEmergencyContact.Response) {
        let viewModel = EditEmergencyContact.DeleteEmergencyContact.ViewModel(isSuccess: response.isSuccess)
        self.viewController?.displayDeleteEmergencyContact(viewModel: viewModel)
    }
    
    /**
     Método que manda al viewController el ViewModel para notificar el resultado de la asignación de una imagen a un contacto
     Parameters:
     - response: ViewModel con un bool de success o failed
     */
    func presentSavePictureEmergencyContact(response: EditEmergencyContact.SavePictureEmergencyContact.Response) {
        let viewModel = EditEmergencyContact.SavePictureEmergencyContact.ViewModel(isSuccess: response.isSuccess, path: response.path ?? "")
        self.viewController?.displaySavePictureEmergencyContact(viewModel: viewModel)
    }
}

/**
 Extensión para mostrar alerta con un tipo de error
 */
extension EditEmergencyContactPresenter: ErrorPresentationLogic {
    func presentError(_ error: Error) {
        var message: String!
        switch error {
        case NetworkingError.noInternet:
            message = LocalizableKeys.Profile.EditProfile.errorNoInternet
            viewController?.displayError(with: message)
        case NetworkingError.unauthorized:
            presentExpiredSession()
        case NetworkingError.noSuccessStatusCode(_, _):
            message = LocalizableKeys.General.serviceError
            viewController?.displayError(with: message)
        default:
            message = LocalizableKeys.General.serviceError
            viewController?.displayError(with: message)
        }
    }
}

/**
 Extensión para mostrar alerta de expiración de token
 */
extension EditEmergencyContactPresenter : ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        self.viewController?.displayExpiredSession()
    }
}