//
//  IAErrorView.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/15/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class IAErrorView: IAUIView {
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var icon: UIView!
    
    var lottieLogo : LOTAnimationView?
    
    private var action:(() -> Void)?
    
    @IBAction  func buttonPressed(_ sender: Any) {
        self.action?()
    }
    
    func show(type: IAErrorAlertType, message:String, actionMessage:String? = nil, action:(() -> Void)? = nil) {
        
        switch type {
        case .noInternet:
            self.displayAnimationLogo(name: "noInternet")
        case .noLocationsResults:
            self.displayAnimationLogo(name: "noLocations")
        case .noSearchResults:
            self.displayAnimationLogo(name: "noResults")
        default:
            return
        }
        
        self.message.text = message
        self.actionButton.setTitle(actionMessage, for: .normal)
        self.actionButton.isHidden = action == nil
        self.action = action
        
        self.isHidden = false
    }
    
    func displayAnimationLogo(name: String) {
        lottieLogo?.stop()
        
        if let logo = lottieLogo {
            logo.play()
        } else {
            lottieLogo = LOTAnimationView(name: name)
            
            lottieLogo?.frame = icon.bounds
            lottieLogo?.loopAnimation = false
            lottieLogo?.contentMode = UIViewContentMode.scaleAspectFill
            lottieLogo?.animationSpeed = 1.0
            self.icon.addSubview(lottieLogo!)
            self.lottieLogo?.play()
        }
    }
    
    func hide() {
        self.isHidden = true
    }
}
