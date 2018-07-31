//
//  EditProfileInteractor.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit
import RxSwift

enum EditProfileError: Error {
    case noUserData
}

protocol EditProfileBusinessLogic {
    func requestUserInfo()
    func requestSaveProfile(request: EditProfile.SaveProfile.Request)
    func requestOnlySaveImage(requestOnlyImage: EditProfile.SaveProfile.OnlyImageRequest)
}

protocol EditProfileDataStore {}

class EditProfileInteractor: EditProfileBusinessLogic, EditProfileDataStore {

    // MARK: - Properties
    var presenter: (EditProfilePresentationLogic & ExpiredSessionPresentationLogic & ErrorPresentationLogic)?
    var worker = ProfileWorker()
    var disposeBag = DisposeBag()

    // MARK: - Business Logic *************************************************************************************
    
    func requestUserInfo() {
        var email = ""
        let profilePic = worker.loadUserProfilePic()

        if let user = worker.loadUserInfo() {
            email = user.email
        }
        
        let response = EditProfile.GetUserInfo.Response(email: email, profilePic: profilePic)
        presenter?.presentUserInfo(response: response)
    }

    func requestSaveProfile(request: EditProfile.SaveProfile.Request) {

        guard var currentUser = worker.loadUserInfo(),
            let phoneNumber = worker.loadUserPhone()else {
            presenter?.presentError(EditProfileError.noUserData)
            return
        }
        worker.editUserEmail(email: request.email).subscribe { [weak self]  (event) in
            switch event {
            case .next(_):
                currentUser.updateEmail(request.email)
                self?.worker.saveUserInfo(currentUser)
                if let userImage = request.image {
                    if FilesManager.saveImageInDocuments(name: "UserProfile\(phoneNumber).png", image: userImage) {
                        self?.presenter?.presentSaveProfile()
                    } else {
                        self?.presenter?.presentError(NetworkingError.noData)
                    }
                } else {
                    self?.presenter?.presentSaveProfile()
                }
            case .error(let error):
                switch error {
                case NetworkingError.unauthorized:
                    self?.presenter?.presentExpiredSession()
                default:
                    self?.presenter?.presentError(error)
                }
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    func requestOnlySaveImage(requestOnlyImage: EditProfile.SaveProfile.OnlyImageRequest) {

        guard let phoneNumber = worker.loadUserPhone() else {
            presenter?.presentError(EditProfileError.noUserData)
            return
        }
        if let userImage = requestOnlyImage.image {
            if FilesManager.saveImageInDocuments(name: "UserProfile\(phoneNumber).png", image: userImage) {
                self.presenter?.presentSaveProfile()
            } else {
                 self.presenter?.presentError(NetworkingError.noData)
            }
        }
    }
}
