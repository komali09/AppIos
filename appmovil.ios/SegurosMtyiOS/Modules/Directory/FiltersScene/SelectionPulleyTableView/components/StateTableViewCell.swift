//
//  StateTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 20/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icoSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(state: State, isSelected: Bool){
        self.name.text = state.name
        self.icoSelected.image = isSelected ? UIImage(named: "locateOn") : UIImage(named: "locateOff")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
