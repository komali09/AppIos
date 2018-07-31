//
//  EmergencyRouter.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/27/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol EmergencyRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol EmergencyDataPassing {
    var dataStore: EmergencyDataStore? { get }
}

class EmergencyRouter: NSObject, EmergencyRoutingLogic, EmergencyDataPassing {
    weak var viewController: EmergencyViewController?
    var dataStore: EmergencyDataStore?

}