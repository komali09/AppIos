//
//  PolicyWalletPresenter.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/19/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import PassKit

protocol PolicyWalletPresentationLogic {
    func presentPolicy(response: InsurancePolicy)
    func presentWallet(response: PKPass)
}

class PolicyWalletPresenter: PolicyWalletPresentationLogic {
    weak var viewController: (PolicyWalletDisplayLogic & ErrorDisplayLogic & ExpiredSessionDisplayLogic)?
    
    // MARK: Do something
    
    func presentPolicy(response: InsurancePolicy) {
        var policyCode = "\(response.titularName.uppercased()), \(response.policyId.uppercased())"
        if response.planForm == .collective,
            let certificateId = response.certificateId {
            policyCode.append(", \(certificateId.uppercased())")
        }
        let viewModel = PolicyWallet.LoadData.ViewModel(expDate: response.endDate.monthYear().capitalized,
                                                        userName: response.titularName,
                                                        name: response.productName.capitalized,
                                                        planName: response.planName.capitalized,
                                                        number: response.policyId.uppercased(),
                                                        certificateId: response.certificateId?.uppercased(),
                                                        cardId: response.cardId,
                                                        isCertificateHidden: response.planForm == .individual,
                                                        planForm: response.planForm == .individual ? "PÓLIZA INVIDIDUAL" : "PÓLIZA COLECTIVA",
                                                        policyCode: policyCode)
        
        self.viewController?.displayPolicy(viewModel: viewModel)
    }
    
    func presentWallet(response: PKPass) {
        self.viewController?.displayWallet(viewModel: response)
    }
}

// MARK: - Error Presentation Logic
extension PolicyWalletPresenter: ErrorPresentationLogic {
    func presentError(_ error: Error) {
        var message: String!
        switch error {
        case NetworkingError.noInternet:
            message = LocalizableKeys.Profile.EditProfile.errorNoInternet
        default:
            message = LocalizableKeys.General.serviceError
        }
        viewController?.displayError(with: message)
    }
}

// MARK: - Expired Session Presentation Logic Methods
extension PolicyWalletPresenter: ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        viewController?.displayExpiredSession()
    }
}
