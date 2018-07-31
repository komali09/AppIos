//
//  EditEmergencyContactRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 08/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EditEmergencyContactRoutingLogic {
    func goToDetailEmergencyContact()
    func goToProfileViewController()
}

protocol EditEmergencyContactDataPassing {
    var dataStore: EditEmergencyContactDataStore? { get set }
}

class EditEmergencyContactRouter: NSObject, EditEmergencyContactRoutingLogic, EditEmergencyContactDataPassing {
    weak var viewController: EditEmergencyContactViewController?
    var dataStore: EditEmergencyContactDataStore?
    
    // MARK: Routing
    
    func goToDetailEmergencyContact() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func goToProfileViewController() {
        if let menuVC = self.viewController?.navigationController?.presentingViewController as? MenuViewController {
            if let navigationProfileVC = menuVC.viewControllers?.first as? UINavigationController {
                if let profileVC = navigationProfileVC.viewControllers.first as? ProfileViewController {
                    if let pruebaVC = profileVC.childViewControllers[0] as? ProfileInformationViewController {
                        pruebaVC.emergencyContacts = nil
                        pruebaVC.reloadEmergencyContacts()
                        self.viewController?.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}