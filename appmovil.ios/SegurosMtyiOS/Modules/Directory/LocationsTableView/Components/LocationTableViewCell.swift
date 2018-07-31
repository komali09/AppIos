//
//  UbicationTableViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 14/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

protocol LocationTableViewCellDelegate : class {
    func favoriteButtonPressed(cell: LocationTableViewCell)
}

class LocationTableViewCell: UITableViewCell {
    weak var delegate: LocationTableViewCellDelegate?
    
    @IBOutlet private weak var building: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet private weak var favorite: UIButton!
    
    var isFavorite:Bool = false {
        didSet {
            favorite.isSelected = isFavorite
        }
    }
    var imageName:String = "" {
        didSet {
            building.image = UIImage(named: imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        self.delegate?.favoriteButtonPressed(cell: self)
    }
}
