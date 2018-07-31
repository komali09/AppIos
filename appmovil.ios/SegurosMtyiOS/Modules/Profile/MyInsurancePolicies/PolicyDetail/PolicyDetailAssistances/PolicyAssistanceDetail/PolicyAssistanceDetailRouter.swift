//
//  PolicyAssistanceDetailRouter.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/24/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PolicyAssistanceDetailRoutingLogic {
    func goToAssitanceInfo()
}

protocol PolicyAssistanceDetailDataPassing {
    var dataStore: PolicyAssistanceDetailDataStore? { get }
}

class PolicyAssistanceDetailRouter: NSObject, PolicyAssistanceDetailRoutingLogic, PolicyAssistanceDetailDataPassing {
    weak var viewController: PolicyAssistanceDetailViewController?
    var dataStore: PolicyAssistanceDetailDataStore?

    func goToAssitanceInfo() {
        let storyBoard = UIStoryboard.emergency()
        let vc = storyBoard.instantiateViewController(withIdentifier: "EmergencyMexicoViewController") as! EmergencyMexicoViewController
        vc.type = .Assistance
        vc.modalTransitionStyle = .crossDissolve
        viewController?.present(vc, animated: true, completion: nil)
    }
}