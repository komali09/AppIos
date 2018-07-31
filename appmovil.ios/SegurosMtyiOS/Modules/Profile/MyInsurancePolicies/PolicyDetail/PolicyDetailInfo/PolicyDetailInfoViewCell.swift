//
//  PolicyDetailInfoViewCell.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/9/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

//MARK: - struct declaration
struct PolicyDetailInfoDataItem {
    var title: String
    var detail: String?
    
    init(title: String, detail: String?) {
        self.title = title
        self.detail = detail ?? LocalizableKeys.General.noInformation
    }
}

struct PolicyCopaymentParticipationData {
    var title: String
    var items: [PolicyCopaymentParticipationDataItem]
}

struct PolicyCopaymentParticipationDataItem {
    var level: String
    var copayment: String
    var participation: String
}

//MARK: - Collection ViewCell
class PolicyDetailInfoViewCell: UICollectionViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var detail: UILabel!
    
    func setup(item: PolicyDetailInfoDataItem?) {
        self.title.text = item?.title ?? ""
        self.detail.text = item?.detail ?? ""
    }
}


class PolicyDetailInfoHeaderView: UICollectionReusableView {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var vigency: UILabel!
    @IBOutlet private weak var activeIcon: UIView!
    
    func setup(item: InsurancePolicy?) {
        self.name.text = item?.titularName.capitalized
        if let isActive = item?.isActive {
            self.vigency.text = isActive ? LocalizableKeys.Profile.MyInsurancePolicies.activePolicy : "VENCIDA"
            self.activeIcon.backgroundColor = isActive ? UIColor.smGreen : UIColor.smPinkish
        } else {
            self.vigency.isHidden = true
            self.activeIcon.isHidden = true
        }
    }
}

//MARK: - Table ViewCell
class CopaymentParticipationViewCell: UITableViewCell {
    @IBOutlet private weak var container: UIView!
    
    @IBOutlet private weak var title: UILabel!
    
    @IBOutlet private weak var aLevel: UILabel!
    @IBOutlet private weak var aCopayment: UILabel!
    @IBOutlet private weak var aParticipation: UILabel!
    
    @IBOutlet private weak var aaLevel: UILabel!
    @IBOutlet private weak var aaCopayment: UILabel!
    @IBOutlet private weak var aaParticipation: UILabel!
    
    @IBOutlet private weak var aaaLevel: UILabel!
    @IBOutlet private weak var aaaCopayment: UILabel!
    @IBOutlet private weak var aaaParticipation: UILabel!
    
    @IBOutlet private weak var vipLevel: UILabel!
    @IBOutlet private weak var vipCopayment: UILabel!
    @IBOutlet private weak var vipParticipation: UILabel!
    
    func setup(item: PolicyCopaymentParticipationData?) {
        
        self.addShadow()
        
        self.title.text = item?.title ?? ""
        
        if let dataItem = item?.items.first(where: { $0.level.uppercased() == "A" }) {
            self.aLevel.text = dataItem.level
            self.aCopayment.text = dataItem.copayment
            self.aParticipation.text = dataItem.participation
        }
        
        if let dataItem = item?.items.first(where: { $0.level.uppercased() == "AA" }) {
            self.aaLevel.text = dataItem.level
            self.aaCopayment.text = dataItem.copayment
            self.aaParticipation.text = dataItem.participation
        }
        
        if let dataItem = item?.items.first(where: { $0.level.uppercased() == "AAA" }) {
            self.aaaLevel.text = dataItem.level
            self.aaaCopayment.text = dataItem.copayment
            self.aaaParticipation.text = dataItem.participation
        }
        
        if let dataItem = item?.items.first(where: { $0.level.uppercased() == "PREFERENTE" }) {
            self.vipLevel.text = dataItem.level
            self.vipCopayment.text = dataItem.copayment
            self.vipParticipation.text = dataItem.participation
        }
    }
    
    private func addShadow() {
        self.container.clipsToBounds = false
        self.container.layer.shadowColor = UIColor.black.cgColor
        self.container.layer.shadowOpacity = 0.1
        self.container.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.container.layer.shadowRadius = 4
    }
}
