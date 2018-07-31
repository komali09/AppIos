//
//  UIImagePickerExtension.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 08/03/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

extension UIImagePickerController {
    func setCustomNavigation() {
        self.navigationBar.backgroundColor = UIColor.smBlue
        self.navigationBar.barTintColor = UIColor.smBlue
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
    }
}
