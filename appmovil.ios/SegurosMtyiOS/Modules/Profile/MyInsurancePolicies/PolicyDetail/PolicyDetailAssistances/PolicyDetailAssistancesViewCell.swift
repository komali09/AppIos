//
//  PolicyDetailAssistancesViewCell.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/23/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailAssistancesViewCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subtitle: UILabel!
    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var container: UIView!
    
    var containerFrame:CGRect {
        get {
            return container.frame
        }
    }
    
    func setup(_ type: AssistanceType) {
        self.addShadow()
        self.title.textColor = type.color
        self.subtitle.textColor = type.color
        
        self.title.text = type.stringValue.uppercased()
        background.image = type.image
    }
    
    private func addShadow() {
        container.clipsToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 10)
        container.layer.shadowRadius = 5
    }
}
