//
//  IAUIView.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 11/30/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class IAUIView: UIView {
    
    var view: UIView!
    
    func viewSetup() {
        self.view = loadViewFromNib()
        
        self.view.frame = bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView {
        
        guard let className = String(describing: type(of: self)).components(separatedBy: ".").last
            else { return self }
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: className, bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        let view = views.first as! UIView
        return view
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewSetup()
    }
}
