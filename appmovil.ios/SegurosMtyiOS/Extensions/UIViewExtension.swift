//
//  UIViewExtension.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 27/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     función que agrega un gradiant a un UIView.
     */
    func addGradiant(initialGradientColor : UIColor , endGradientColor : UIColor, opacity : Float ) {
        
        layer.backgroundColor = UIColor.clear.cgColor
        clipsToBounds = true
    
        //Add Gradient
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [initialGradientColor.cgColor, endGradientColor.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 0.0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = self.bounds
        
        //Add opacity
        self.layer.opacity = opacity
    }
    
    func getConstraint(identifier:String) -> NSLayoutConstraint?{
        for constraint in self.constraints {
            guard let constraintIdentifier = constraint.identifier
                else {continue}
            if constraintIdentifier == identifier{
                return constraint
            }
        }
        return nil
    }
}
