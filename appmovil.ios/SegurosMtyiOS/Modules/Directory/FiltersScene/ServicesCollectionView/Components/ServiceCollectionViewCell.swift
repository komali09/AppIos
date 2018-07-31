//
//  ServiceCollectionViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func configureCell(service: ServiceType) {
        self.icon.image = service.ico
        self.name.text = service.name
    }
    
    func select(animated:Bool = true)  {
        self.setUnelected()
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.check.alpha = 1
                self.icon.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            },completion: { completed in
                UIView.animate(withDuration: 0.2, animations: self.setSelected)
            })
        } else {
            self.setSelected()
        }
    }
    
    func deselect(animated:Bool = true) {
        self.setSelected()
        if animated {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.check.alpha = 0
                self.icon.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            },completion: { completed in
                UIView.animate(withDuration: 0.2, animations: self.setUnelected)
            })
        } else {
            self.setUnelected()
        }
    }
    
    private func setSelected() {
        self.check.alpha = 1
        self.check.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        self.icon.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
    }
    
    private func setUnelected() {
        self.check.alpha = 0
        self.check.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        self.icon.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
    }
}
