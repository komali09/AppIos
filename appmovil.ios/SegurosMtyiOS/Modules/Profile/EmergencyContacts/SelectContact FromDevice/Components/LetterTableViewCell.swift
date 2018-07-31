//
//  LetterTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 23/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class LetterTableViewCell: UITableViewCell {

    @IBOutlet weak var letter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(letter: String) {
        self.letter.text = letter
    }

}
