//
//  DetailEmergencyContactRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 07/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol DetailEmergencyContactRoutingLogic {
    func goToEditEmergencyContact()
}

protocol DetailEmergencyContactDataPassing {
    var dataStore: DetailEmergencyContactDataStore? { get set}
}

class DetailEmergencyContactRouter: NSObject, DetailEmergencyContactRoutingLogic, DetailEmergencyContactDataPassing {
    weak var viewController: DetailEmergencyContactViewController?
    var dataStore: DetailEmergencyContactDataStore?
    
    // MARK: Routing
    func goToEditEmergencyContact() {
        let storyBoard = UIStoryboard.emergencyContacts()
        guard let editEmergencyContactVC = storyBoard.instantiateViewController(withIdentifier: "EditEmergencyContactViewController") as? EditEmergencyContactViewController else { return }
        
        editEmergencyContactVC.router?.dataStore?.emergencyContact = (dataStore?.emergencyContact)!
        viewController?.navigationController?.pushViewController(editEmergencyContactVC, animated: true)
    }
}
