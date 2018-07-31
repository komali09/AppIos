//
//  RecoverPasswordRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 06/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RecoverPasswordRoutingLogic {
    func goToCheckCode(validationCodeProccessType:ValidationCodeProccessType)
}

protocol RecoverPasswordDataPassing {
    var dataStore: RecoverPasswordDataStore? { get set }
}

class RecoverPasswordRouter: NSObject, RecoverPasswordRoutingLogic, RecoverPasswordDataPassing {
    weak var viewController: RecoverPasswordViewController?
    var dataStore: RecoverPasswordDataStore?
    
    // MARK: Routing
    
    func goToCheckCode(validationCodeProccessType:ValidationCodeProccessType) {
        if dataStore?.isValidPhoneNumber ?? false {
            let storyBoard = UIStoryboard.recoverPassword()
            let checkCodeVC = storyBoard.instantiateViewController(withIdentifier: "CheckCodeViewController") as! CheckCodeViewController
            checkCodeVC.router?.dataStore?.phoneNumber = dataStore?.phoneNumber ?? ""
            checkCodeVC.router?.dataStore?.validationCodeProccessType = validationCodeProccessType
            viewController?.show(checkCodeVC, sender: nil)
        }
    }
}
