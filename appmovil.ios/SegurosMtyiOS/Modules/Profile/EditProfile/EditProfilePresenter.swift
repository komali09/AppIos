//
//  EditProfilePresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

protocol EditProfilePresentationLogic {
    func presentUserInfo(response: EditProfile.GetUserInfo.Response)
    func presentSaveProfile()
}

class EditProfilePresenter: EditProfilePresentationLogic {
    weak var viewController: (EditProfileDisplayLogic & ExpiredSessionDisplayLogic & ErrorDisplayLogic)?

    func presentUserInfo(response: EditProfile.GetUserInfo.Response) {
        let viewModel = EditProfile.GetUserInfo.ViewModel(email: response.email, userPicture: response.profilePic)
        viewController?.displayUserInfo(viewModel: viewModel)
    }

    func presentSaveProfile() {
        let message = LocalizableKeys.Profile.EditProfile.successEdit
        viewController?.displaySaveProfile(viewModel: EditProfile.SaveProfile.ViewModel(msg: message))
    }
}

// MARK: - Error Presentation Logic
extension EditProfilePresenter: ErrorPresentationLogic {
    func presentError(_ error: Error) {
        var message: String!
        switch error {
        case NetworkingError.noInternet:
            message = LocalizableKeys.Profile.EditProfile.errorNoInternet
        default:
            message = LocalizableKeys.Profile.EditProfile.errorGeneric
        }
        viewController?.displayError(with: message)
    }
}

// MARK: - Expired Session Presentation Logic Methods
extension EditProfilePresenter: ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        viewController?.displayExpiredSession()
    }
}
