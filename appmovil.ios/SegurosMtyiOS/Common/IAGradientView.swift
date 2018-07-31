//
//  IAGradientView.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 04/12/17.
//  Copyright © 2017 Erwin Jonnatan Perez Téllez. All rights reserved.
//

import UIKit

/*
 Clase que agrega propiedades al interface builder del UIVIEW para agilizar el agregar bordes, sombras, corner radius, etc.
 */

@IBDesignable class IAGradientView: UIView {
    
    private var gradient:CAGradientLayer!
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            setup()
        }
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            setup()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var initialGradientColor: UIColor = UIColor.red {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var endGradientColor: UIColor = UIColor.blue {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var opacity: Float = 1.0 {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 1, y: 0.0) {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet{
            setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    
    func configure() {
        gradient = CAGradientLayer()
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.zPosition = -1
        layer.addSublayer(gradient)
    }
    
    /*
     Método que hace el render del botón para agregar los atributos al view del botón
     */
    func setup(){
        super.layoutSubviews()
        
        //Add border
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        //Add background
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }, completion: nil)
        
        clipsToBounds = false
        
        //Add Gradient
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        gradient.startPoint = self.startPoint
        gradient.endPoint = self.endPoint
        gradient.frame = self.bounds
        
        //Add cornerRadius
        layer.cornerRadius = self.cornerRadius
        gradient.cornerRadius = self.cornerRadius
        
        
        //Add opacity
         self.layer.opacity = opacity
        
        //Add Shadow
        layer.shadowColor = self.shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        
        self.layer.addSublayer(gradient)
       
    }
    
    func animateToColors(_ firstColor: UIColor, toColor: UIColor) {
        
        gradient?.removeAnimation(forKey: "colorChange")
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 0.35
        gradientChangeAnimation.toValue = [
            firstColor.cgColor,
            toColor.cgColor
        ]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient?.add(gradientChangeAnimation, forKey: "colorChange")
        
    }
    
    
}

