//
//  UIColorExtension.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/30/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc class var smBlue: UIColor {
        return UIColor(red: 0.0, green: 122.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smSlateGrey: UIColor {
        return UIColor(red: 83.0 / 255.0, green: 85.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smWarmGrey: UIColor {
        return UIColor(white: 124.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smSoftGrey: UIColor {
        return UIColor(white: 135.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smPinkish: UIColor {
        return UIColor(red: 218.0 / 255.0, green: 96.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smGreen: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 211.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smTealBlue: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 161.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smLightGray: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smBlueLight: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smBlueloader: UIColor {
        return UIColor(red: 0.0, green: 122.0 / 255.0, blue: 194.0 / 255.0, alpha: 0.8)
    }
    
    @nonobjc class var smGreenLight: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 207.0 / 255.0, blue: 154.0 / 255.0, alpha: 0.8)
    }
    
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
}
