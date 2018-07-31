//
//  IABannerAlert.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/15/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

enum IAErrorAlertType {
    case noInternet
    case noLocationsResults
    case noFavoritesResults
    case noSearchResults
    case emptyPolicies
    case noRegisters
    case none
    
}

class IABannerAlert: IAUIView {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var action:(() -> Void)?
    
    @IBAction  func buttonPressed(_ sender: Any) {
        self.action?()
    }
    
    func show(type: IAErrorAlertType, message:String, actionMessage:String? = nil, action:(() -> Void)? = nil) {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.addShadow()
            self.alpha = 0.0
            self.isHidden = false
            switch type {
            case .noInternet:
                self.icon.image = UIImage(named:"noInternetSmall")
            case .noLocationsResults:
                self.icon.image = UIImage(named:"noLocationsSmall")
            case .noSearchResults:
                self.icon.image = UIImage(named:"noResultsSmall")
            default:
                self.icon.image = nil
            }
            
            self.message.text = message
            
            self.actionButton.setTitle(actionMessage, for: .normal)
            self.actionButton.isHidden = action == nil
            self.bottomConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(action == nil ? 999 : 700))
            self.action = action
            
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
            }) { (completed) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.alpha = 0.0
                    }) { (completed) in
                        self.isHidden = false
                        self.action = nil
                    }
                })
            }
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { (success) in
            self.isHidden = true
        }
    }
    
    private func addShadow() {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
    }
}
