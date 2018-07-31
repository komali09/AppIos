//
//  IADominosLoader.swift
//  Dominos
//
//  Created by Isidro Adan Garcia Solorio  on 5/23/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import UIKit
import Lottie

public class IALoader: UIView {
    
    public class var shared: IALoader {
        struct Singleton {
            static let instance = IALoader(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    private var text:UILabel!
    private var containerLayer:CALayer?
    
    var width:CGFloat = 0
    var height:CGFloat =  0
    
    public override var frame: CGRect {
        didSet {
            if frame == CGRect.zero {
                return
            }
            containerLayer?.position = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initContainer()
        
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    

    public func show(_ message:String = "", function: String = #function) {
        debugPrint("🔄 Loader showed by: \(function)")
        
        self.updateFrame()
        
        if let _ = self.text {
            self.text.text = message
        }
        
        if self.superview == nil {
            
            guard let containerView = IALoader.containerView() else {
                fatalError("\n`UIApplication.keyWindow` is `nil`. If you're trying to show a spinner from your view controller's `viewDidLoad` method, do that from `viewWillAppear` instead. Alternatively use `useContainerView` to set a view where the spinner should show")
            }
            self.alpha = 0
            containerView.addSubview(self)
            self.start()
            
            
        }
    }
    
    public func hide(function: String = #function) {
        debugPrint("🔄 Loader hidded by: \(function)")
       
        if self.superview == nil {
            return
        }
        self.stop()
        
    }
    
    private func start() {
        self.initAnimation()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    private func stop() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion:nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.removeFromSuperview()
            self.containerLayer?.removeAllAnimations()
        }
    }
    
    private func initContainer(){
        
        if let containerView = IALoader.containerView() {
            let length:CGFloat = containerView.bounds.size.width * 0.5
            
            width = length
            height = length
            
            addGradiant(initialGradientColor: UIColor.brown , endGradientColor: UIColor.blue , opacity: 0.0)
            
            containerLayer = CALayer()
            containerLayer?.backgroundColor = UIColor.clear.cgColor
            containerLayer?.frame = CGRect(x: 0, y: 0, width: width, height: height)
            containerLayer?.contents = UIImage(named: "loader")!.cgImage
            containerLayer?.contentsGravity = kCAGravityResizeAspectFill
            containerLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            containerLayer?.position = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
            
            layer.addSublayer(containerLayer!)
            
            let textSize = length - 20

            let textFrame = CGRect(x: containerView.bounds.size.width * 0.5 - textSize * 0.5, y: containerView.bounds.size.height * 0.5 - textSize * 0.5, width: textSize, height: textSize)
            self.text = UILabel(frame: textFrame)
            self.text.textAlignment = .center
            self.text.numberOfLines = 0
            self.text.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            self.text.textColor = UIColor.white
            self.addSubview(self.text)
            
            self.backgroundColor = UIColor.smBlueloader
        }
    }
    
    public func initAnimation(){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Float.pi * 2)
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = HUGE
        rotateAnimation.isCumulative = false
        
        self.containerLayer?.add(rotateAnimation, forKey: "rotationAnimation")
    }
    
    public func updateFrame() {
        if let containerView = IALoader.containerView() {
            self.frame = containerView.bounds
        }
        
    }
    
    private static func containerView() -> UIView?{
        return UIApplication.shared.keyWindow
    }
}
