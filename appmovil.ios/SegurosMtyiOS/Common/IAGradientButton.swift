//
//  IAGradientButton.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 29/11/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

/*
    Clase que agrega propiedades al interface builder del UIButton para agilizar el agregar bordes, sombras, corner radius, etc.
*/

@IBDesignable class IAGradientButton : UIButton {
    
    private var gradient:CAGradientLayer!
    
    @IBInspectable var roundness: CGFloat = 0.0 {
        didSet{
            setup()
        }
    }
    
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
    
    @IBInspectable var initialGradientColor: UIColor = UIColor.smBlue {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var endGradientColor: UIColor = UIColor(red: 39.0/255.0, green: 151.0/255.0, blue: 217.0/255.0, alpha: 1) {
        didSet{
            setup()
        }
    }
    
    @IBInspectable var pressedColor: UIColor = UIColor(red: 0, green: 110.0/255.0, blue: 176.0/255.0, alpha: 1) {
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
        addTarget(self, action: #selector(buttonHighlight(_:)), for: .touchDown)
        addTarget(self, action: #selector(buttonHighlight(_:)), for: .touchDragInside)
        addTarget(self, action: #selector(buttonHighlight(_:)), for: .touchDragEnter)
        addTarget(self, action: #selector(buttonNormal(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(buttonNormal(_:)), for: .touchUpOutside)
        addTarget(self, action: #selector(buttonNormal(_:)), for: .touchDragExit)
        addTarget(self, action: #selector(buttonNormal(_:)), for: .touchDragOutside)
        
        
        gradient = CAGradientLayer()
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        layer.addSublayer(gradient)
        self.bringSubview(toFront: self.titleLabel!)
        self.bringSubview(toFront: self.imageView!)

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
        self.layer.backgroundColor = initialGradientColor.cgColor
        
        clipsToBounds = true
    
        //Add Gradient
        gradient.frame = self.bounds
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        layer.cornerRadius = roundness
    }
    
    @objc func buttonHighlight(_ sender: UIButton) {
        gradient.colors = [pressedColor.cgColor, pressedColor.cgColor]
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.beginFromCurrentState], animations: {
            let transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.layer.setAffineTransform(transform)
        }, completion: nil)
       
    }
    
    @objc func buttonNormal(_ sender: UIButton) {
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.beginFromCurrentState], animations: {
            let transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.layer.setAffineTransform(transform)
        }, completion: nil)
    }
}
