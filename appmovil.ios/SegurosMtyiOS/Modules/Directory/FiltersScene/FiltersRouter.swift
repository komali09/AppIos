//
//  FiltersRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 18/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol FiltersRoutingLogic {
    func routeToDirectory()
    func routeToFilters(destinationVC: FiltersViewController)
}

protocol FiltersDataPassing {
    var dataStore: FiltersDataStore? { get set }
}

class FiltersRouter: NSObject, FiltersRoutingLogic, FiltersDataPassing {
    weak var viewController: FiltersViewController?
    var dataStore: FiltersDataStore?
    
    func routeToFilters(destinationVC: FiltersViewController) {
        var destinationDS = destinationVC.router?.dataStore
        passDataToLocation(source: dataStore!, destination: &destinationDS)
    }
    
    func routeToDirectory() {
        self.passDataToDirecory()
        self.navigateToDirectory()
    }
    
    func passDataToDirecory() {
        guard let tabBarController = self.viewController?.presentingViewController as? UITabBarController else { return }
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
        guard let viewController = navigationController.viewControllers.first as? DirectoryViewController else { return }
        guard let dataStore = self.dataStore else { return }
        var destinationDS = viewController.router?.filterDataStore
        
        self.passDataToLocation(source: dataStore, destination: &destinationDS)
    }
    
    func passDataToLocation(source: FiltersDataStore, destination: inout FiltersDataStore?) {
        destination?.isPlanIncludedOnly = source.isPlanIncludedOnly
        destination?.isFavoritesOnly = source.isFavoritesOnly
        destination?.selectedServices = source.selectedServices
        destination?.selectedState = source.selectedState
        destination?.doctorTypes = source.doctorTypes
    }
    
    func navigateToDirectory() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
