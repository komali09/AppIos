//
//  BenefitDetailTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 23/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class BenefitDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var clause: UILabel!
    @IBOutlet weak var triangle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
