//
//  ContacTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 22/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class ContacTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    var contact: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(contact: Contact) {
        self.contact = contact
        self.name.text = contact.name ?? ""
    }

}
