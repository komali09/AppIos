//
//  EmergencyContactCollectionViewCell.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 04/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class EmergencyContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: IAUIImageView!
    @IBOutlet weak var name: UILabel!
    
    var emergencyContactID: Int?
    
    func configureCell(emergencyContact: EmergencyContact?) {
        if let contact = emergencyContact {
            self.emergencyContactID = contact.ID ?? 0
            self.name.text = contact.name ?? ""
            self.photo.image = FilesManager.getImageInDirectoryInsideDocuments(directory: UserDefaultsManager.shared.directoryPicturesEmergencyContacts, name: emergencyContact?.picture ?? "") ?? UIImage(named: "defaultAvatar")
            self.photo.backgroundColor = UIColor.white
            self.photo.contentMode = .scaleToFill
        } else {
            self.photo.image = UIImage(named: "addUser")
            self.photo.contentMode = .center
            self.photo.backgroundColor = UIColor.smGreenLight
            self.name.text = "Añadir contacto"
        }
    }
    
}
