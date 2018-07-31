//
//  IABlurAlertController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/29/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class IABlurAlertController : UIAlertController {
    var blurEffectView:UIVisualEffectView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        if let presnetingView = self.presentingViewController {
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = presnetingView.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            presnetingView.view.addSubview(blurEffectView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let blurEffectView = self.blurEffectView {
            blurEffectView.removeFromSuperview()
        }
    }
}
