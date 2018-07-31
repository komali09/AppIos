//
//  IAUIImageView.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 03/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation


import UIKit
import CoreGraphics

/*
 Clase que agrega propiedades al interface builder del UIIimageView para agilizar el agregar bordes, sombras, corner radius, etc.
 */

@IBDesignable class IAUIImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
    }
}

