//
//  PolicySelectionBeneficiariesToWalletRouter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 01/03/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PolicySelectionBeneficiariesToWalletRoutingLogic {
    func goToDetailPolicy()
    func goToDetailWallet()
}

protocol PolicySelectionBeneficiariesToWalletDataPassing {
    var dataStore: PolicySelectionBeneficiariesToWalletDataStore? { get set }
}

class PolicySelectionBeneficiariesToWalletRouter: NSObject, PolicySelectionBeneficiariesToWalletRoutingLogic, PolicySelectionBeneficiariesToWalletDataPassing {
    weak var viewController: PolicySelectionBeneficiariesToWalletViewController?
    var dataStore: PolicySelectionBeneficiariesToWalletDataStore?
    
    // MARK: Routing
    func goToDetailPolicy() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
    func goToDetailWallet() {
        let storyboard = UIStoryboard.policyDetail()
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "Wallet") as? PolicyWalletViewController
        destinationVC?.router?.dataStore?.needsUpdate = true
        destinationVC?.router?.dataStore?.policy = self.dataStore?.policy
        destinationVC?.router?.dataStore?.isTitularBeneficiare = self.dataStore?.isTitularBeneficiare ?? true
        
        if self.dataStore?.isTitularBeneficiare == false {
            destinationVC?.router?.dataStore?.beneficiareName = self.dataStore?.beneficiareSelected?.name ?? ""
            destinationVC?.router?.dataStore?.beneficiareFatherName = self.dataStore?.beneficiareSelected?.fatherLastName ?? ""
            destinationVC?.router?.dataStore?.beneficiareMotherName = self.dataStore?.beneficiareSelected?.motherLastName ?? ""
        }
        
        guard let tabBarController = self.viewController?.presentingViewController as? UITabBarController else { return }
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else { return }
        guard let detailPolicyVC = navigationController.viewControllers.last as? PolicyDetailViewController else { return }
        
        self.viewController?.dismiss(animated: true, completion: {
            detailPolicyVC.navigationController?.pushViewController(destinationVC!, animated: true)
        })
    }
}