//
//  UIViewControllerExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/1/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorDisplayLogic: class {
    func displayError(with message:String)
}

extension ErrorDisplayLogic where Self: UIViewController {
    func displayError(with message:String) {
        IALoader.shared.hide()
        self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
    }
}


protocol ExpiredSessionDisplayLogic: class {
    func displayExpiredSession()
}

extension ExpiredSessionDisplayLogic where Self: UIViewController {
    func displayExpiredSession() {
        IALoader.shared.hide()
        self.showAlert(with: nil, message: LocalizableKeys.General.expiredSession, actionTitle: LocalizableKeys.General.AlertOptions.accept) { (action) in
            //TODO: borrar datos
            UIStoryboard.loadWelcome()
        }
    }
}

extension UIViewController {
    func setCustomBackButton() {
        let yourBackImage = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = " "
    }
    
    func setTranslucentNavigationBar() {
        let image:UIImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                   NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]

        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func setOpaqueNavigationBar()  {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.smBlue
        self.navigationController?.navigationBar.backgroundColor = UIColor.smBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    
    func showAlert(with title:String?, message:String, actionTitle:String , action:((UIAlertAction) -> Void)?) {
        let alert = IABlurAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
}
