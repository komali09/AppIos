//
//  ProfileInformationInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 05/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxSwift

protocol ProfileInformationBusinessLogic {
    func getEmergencyContacts()
    func setEmergencyContact(request: ProfileInformation.SetEmergencyContact.Request)
}

protocol ProfileInformationDataStore {
    var emergencyContact: EmergencyContact { get set }
}

class ProfileInformationInteractor: ProfileInformationBusinessLogic, ProfileInformationDataStore {
    var presenter: (ProfileInformationPresentationLogic & ExpiredSessionPresentationLogic)?
    var worker: ProfileWorker?
    
    // MARK: DataStore
    var disposableBag: DisposeBag = DisposeBag()
    var emergencyContact: EmergencyContact = EmergencyContact()
    
    // MARK: Do something
    
    func getEmergencyContacts() {
        if worker == nil {
            worker = ProfileWorker()
        }
        
        worker?.getEmergencyContactsData().subscribe({ [weak self] event in
            switch event {
            case .next(let result):
                let response = ProfileInformation.GetEmergencyContacts.Response(emergencyContacts: result, error: nil)
                self?.presenter?.presentEmergencyContacts(response: response)
            case .error(let error):
                switch error {
                case NetworkingError.unauthorized:
                    self?.presenter?.presentExpiredSession()
                default:
                    let response = ProfileInformation.GetEmergencyContacts.Response(emergencyContacts: nil, error: error)
                    self?.presenter?.presentEmergencyContacts(response: response)
                }
            default:
                break
            }
        }).disposed(by: self.disposableBag)
    }
    
    func setEmergencyContact(request: ProfileInformation.SetEmergencyContact.Request) {
        self.emergencyContact = request.emergencyContact!
    }
}