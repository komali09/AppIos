//
//  SelectionBeneficiareToWalletTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 01/03/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class SelectionBeneficiareToWalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(titularName: String, isCurrentSelection: Bool) {
        self.name.text = titularName
        self.check.image = isCurrentSelection ? UIImage(named: "checkRadio") : UIImage(named: "uncheckRadio")
    }
    
    func configureCell(beneficiare: Beneficiarie, isCurrentSelection: Bool) {
        self.name.text = "\(String(describing: beneficiare.name ?? "")) \(String(describing: beneficiare.fatherLastName ?? "")) \(String(describing: beneficiare.motherLastName ?? ""))"
        self.check.image = isCurrentSelection ? UIImage(named: "checkRadio") : UIImage(named: "uncheckRadio")
    }
}
