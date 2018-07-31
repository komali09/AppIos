//
//  EditPasswordRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EditPasswordRoutingLogic {
    func moveToMenu()
}

protocol EditPasswordDataPassing {
    var dataStore: EditPasswordDataStore? { get }
}

class EditPasswordRouter: NSObject, EditPasswordRoutingLogic, EditPasswordDataPassing {
    weak var viewController: EditPasswordViewController?
    var dataStore: EditPasswordDataStore?
    
    func moveToMenu() {
        self.viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
