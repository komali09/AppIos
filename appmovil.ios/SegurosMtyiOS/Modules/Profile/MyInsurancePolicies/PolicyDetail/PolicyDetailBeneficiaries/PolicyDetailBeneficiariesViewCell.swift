//
//  PolicyDetailBeneficiariesViewCell.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/17/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

struct BeneficiarieDataItem {
    var name: String
    var relationship: String?
}

class PolicyDetailBeneficiariesViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var relationship: UILabel!
    
    func setup(item: BeneficiarieDataItem?) {
        self.name.text = item?.name ?? ""
        self.relationship.text = item?.relationship ?? ""
    }
}
