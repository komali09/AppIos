//
//  PolicysCoverageCollectionViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 24/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class PolicysCoverageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ico: UIImageView!
    @IBOutlet weak var caption: UILabel!
    
    
    func configureCell(coverage: Coverage) {
        self.name.text = coverage.name ?? ""
        self.caption.text = coverage.caption ?? ""
        
        switch coverage.ico {
        case CoverageType.general.hashValue?:
            self.ico.image = CoverageType.general.image
        case CoverageType.medicines.hashValue?:
            self.ico.image = CoverageType.medicines.image
        case CoverageType.medic.hashValue?:
            self.ico.image = CoverageType.medic.image
        case CoverageType.pregnan.hashValue?:
            self.ico.image = CoverageType.pregnan.image
        case CoverageType.dental.hashValue?:
            self.ico.image = CoverageType.dental.image
        case CoverageType.ambulance.hashValue?:
            self.ico.image = CoverageType.ambulance.image
        case CoverageType.heritage.hashValue?:
            self.ico.image = CoverageType.heritage.image
        case CoverageType.vih.hashValue?:
            self.ico.image = CoverageType.vih.image
        case CoverageType.spouse.hashValue?:
            self.ico.image = CoverageType.spouse.image
        case CoverageType.border.hashValue?:
            self.ico.image = CoverageType.border.image
        default:
            break
        }
    }
    
    /**
     Método que ajusta su frame verticalmente (Height).
     */
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = CGRect(x: layoutAttributes.frame.origin.x, y: 0, width: layoutAttributes.frame.size.width, height: layoutAttributes.frame.size.height)
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
