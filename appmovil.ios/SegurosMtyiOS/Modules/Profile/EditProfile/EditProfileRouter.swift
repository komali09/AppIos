//
//  EditProfileRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

@objc protocol EditProfileRoutingLogic {
    func goToEditPasswordViewController()
}

protocol EditProfileDataPassing {
    var dataStore: EditProfileDataStore? { get }
}

class EditProfileRouter: NSObject, EditProfileRoutingLogic, EditProfileDataPassing {
    weak var viewController: EditProfileViewController?
    var dataStore: EditProfileDataStore?
    
    // MARK: Routing
    func goToEditPasswordViewController() {
        let storyBoard = UIStoryboard.editPassword()
        guard let editPasswordVC = storyBoard.instantiateInitialViewController() as? EditPasswordViewController else { return }
        viewController?.show(editPasswordVC, sender: nil)
    }
}
