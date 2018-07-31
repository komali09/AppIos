//
//  PolicyAssistanceDetailViewCell.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/24/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

class PolicyAssistanceDetailViewCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var events: UILabel!
    @IBOutlet private weak var type: UILabel!
    @IBOutlet private weak var limitsTitle: UILabel?
    @IBOutlet private weak var limitsDescription: UILabel?
    @IBOutlet private weak var exclusionsTitle: UILabel?
    @IBOutlet private weak var exclusionsDescription: UILabel?
    
    func setup(_ item: AssistanceItem) {
        self.title.text = item.name
        self.events.text = item.event
        self.type.text = item.type
        
        if let limitations = item.limitations {
            limitsTitle?.text = "Limitantes:"
            limitsDescription?.text = limitations
        } else {
            limitsTitle?.text = nil
            limitsDescription?.text = nil
        }
        if let exclusions = item.exclusions {
            exclusionsTitle?.text = "Exclusiones:"
            exclusionsDescription?.text = exclusions
        } else {
            exclusionsTitle?.text = nil
            exclusionsDescription?.text = nil
        }
    }
}
