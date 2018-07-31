//
//  UIFontExtension.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 21/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

extension UIFont {
    enum AppFonts: String {
        case Regular = "SanFranciscoText-Regular"
        case Medium = "SanFranciscoText-Medium"
        case Bold = "SanFranciscoText-Bold"

        func ofSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: self.rawValue, size: size)!
        }
    }
}
