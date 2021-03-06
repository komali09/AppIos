//
//  ProfilePresenter.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/7/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfilePresentationLogic {
    func presentUserInfo(response: UserInfo, profilePic: UIImage)
    func presentInsurancePolicies(_ policies: [InsurancePolicy])
    func presentAdvisor(_ advisor:Advisor)
    func presentLogout()
    func presentOnScreenError(_ error:Error)
    func presentAdvisorOnScreenError(_ error:Error)
}

class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: (ProfileDisplayLogic & ExpiredSessionDisplayLogic & ErrorDisplayLogic)?
    
    // MARK: Do something
    
    func presentUserInfo(response: UserInfo, profilePic: UIImage) {
        let viewModel = Profile.UserInfo.ViewModel(firstName: response.firstName, lastName: response.lastName, polizy: response.polizy ?? LocalizableKeys.General.noInformation, birthDate: response.birthday, email: response.email, profilePic: profilePic)
        viewController?.displayUserInfo(viewModel: viewModel)
    }
    
    func presentInsurancePolicies(_ policies: [InsurancePolicy]) {
        
        let modelView = Profile.InsurancePolicies.ViewModel(insurancePolicies: policies)
        
        viewController?.displayInsurancePolicies(viewModel: modelView)
        
    }
    
    func presentAdvisor(_ advisor:Advisor) {
        let name = "\(advisor.name?.capitalized ?? "") \(advisor.fatherLastName?.capitalized ?? "") \(advisor.motherLastName?.capitalized ?? "")"
        let phone = advisor.mobilePhone ?? advisor.officePhone
        let email = advisor.email?.lowercased()
        let viewModel = Profile.AdvisorInfo.ViewModel(name: name, phone: phone, email: email)
        self.viewController?.displayAdvisor(viewModel)
    }
    
    func presentLogout() {
        viewController?.displayLogout()
    }
    
    func presentOnScreenError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            viewController?.displayOnscreenError(type: .noInternet)
        case NetworkingError.noSuccessStatusCode(let code, _):
            if code == 1 {
                viewController?.displayOnscreenError(type: .noRegisters)
            } else {
                viewController?.displayOnscreenError(type: .noSearchResults)
            }
        default:
            viewController?.displayOnscreenError(type: .noSearchResults)
        }
    }
    
    func presentAdvisorOnScreenError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            viewController?.displayAdvisorOnscreenError(type: .noInternet)
        case NetworkingError.noSuccessStatusCode(let code, _):
            switch code {
            case 2:
                viewController?.displayAdvisorOnscreenError(type: .noSearchResults)
            default:
                viewController?.displayAdvisorOnscreenError(type: .emptyPolicies)
            }
        default:
            viewController?.displayAdvisorOnscreenError(type: .noSearchResults)
        }
    }
}

extension ProfilePresenter : ErrorPresentationLogic {
    func presentError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            self.viewController?.displayError(with: LocalizableKeys.General.noInternet)
        case NetworkingError.noSuccessStatusCode(let code, _):
            if (500...599).contains(code) {
                self.viewController?.displayError(with: LocalizableKeys.General.serviceError)
            } else {
                self.viewController?.displayError(with: LocalizableKeys.Register.invalidData)
            }
        default:
            self.viewController?.displayError(with: LocalizableKeys.General.serviceError)
        }
    }
}

extension ProfilePresenter : ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        self.viewController?.displayExpiredSession()
    }
}

