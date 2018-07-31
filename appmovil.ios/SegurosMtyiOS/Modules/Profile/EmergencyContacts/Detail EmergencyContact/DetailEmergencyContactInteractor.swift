//
//  DetailEmergencyContactInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 07/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol DetailEmergencyContactBusinessLogic {
}

protocol DetailEmergencyContactDataStore {
    var emergencyContact: EmergencyContact { get set }
}

class DetailEmergencyContactInteractor: DetailEmergencyContactBusinessLogic, DetailEmergencyContactDataStore {
    var presenter: DetailEmergencyContactPresentationLogic?
    
    // MARK: DataStore
    var emergencyContact = EmergencyContact()
    
}