//
//  SpecialtyTagCell.swift
//  SegurosMtyiOS
//
//  Created by Juan Eduardo Pacheco Osornio on 21/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class SpecialtyTagCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var removeButton: UIButton!

    // MARK: - Object Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.layer.cornerRadius = nameLabel.frame.size.height / 2
    }
}
