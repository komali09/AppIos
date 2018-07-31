//
//  InsurancePolicyViewCell.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 19/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class InsurancePolicyViewCell: UITableViewCell {
    
    @IBOutlet weak var gradientView: IAGradientView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var insurancePoliceTitleLabel: UILabel!
    @IBOutlet weak var policyTypeImage: UIImageView!
    @IBOutlet weak var typePolicyLabel: UILabel!
    @IBOutlet weak var fullUserNameLabel: UILabel!
    @IBOutlet weak var policyCodeLabel: UILabel!
    @IBOutlet weak var deductibleLabel: UILabel!
    @IBOutlet weak var insuredAmountLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var shadowBackground: UIView!
    @IBOutlet weak var certificationStackView: UIStackView!
    @IBOutlet weak var certificationLabel: UILabel!
    @IBOutlet weak var mainInsurancePoliceImage: UIImageView!
    
    @IBOutlet weak var deductibleTitleLabel: UILabel!
    @IBOutlet weak var coassuranceTitleLabel: UILabel!
    @IBOutlet weak var planFormLabel: UILabel!
    //  Active/Deactive View
    @IBOutlet weak var activeBackgroundView: UIView!
    @IBOutlet weak var activeDeactiveLabel: UILabel!
    @IBOutlet weak var circleActiveDeactiveView: UIView!
    
    //Static Labels
    @IBOutlet weak var aseguradoLabel: UILabel!
    @IBOutlet weak var polizaLabel: UILabel!
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        addaptActiveDeactiveBackground()
        
    }
    
    private func addaptActiveDeactiveBackground() {
        
        activeBackgroundView.layer.cornerRadius = 9.0
        circleActiveDeactiveView.layer.cornerRadius = 3.5
        
    }
    
    public func adaptAppearance(_ insurancePolicy: InsurancePolicy) {
        
        resetAppearance(insurancePolicy)
        applyLogicBusiness(insurancePolicy)
        changeAllLabels(insurancePolicy)
        changeBackgroundColorAndImages(insurancePolicy)
        
    }
    
    private func resetAppearance(_ insurancePolicy: InsurancePolicy) {
        
        self.deductibleLabel.alpha = 1.0
        self.insuredAmountLabel.alpha = 1.0
        self.certificationStackView.alpha = 0.0
        self.certificationLabel.text = insurancePolicy.certificateId != nil ? String(insurancePolicy.certificateId!) : " "
        
    }
    
    private func applyLogicBusiness(_ insurancePolicy: InsurancePolicy) {
        
        mainInsurancePoliceImage.alpha = insurancePolicy.isMainPolicy ? 1.0 : 0.0
        
        if insurancePolicy.planForm == .collective {
            planFormLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.collectiveForm
        } else {
            planFormLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.individualForm
        }
        
        if insurancePolicy.isActive ?? false {
            circleActiveDeactiveView.backgroundColor = UIColor.smGreen
            activeDeactiveLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.activePolicy
        } else {
            circleActiveDeactiveView.backgroundColor = UIColor.smPinkish
            activeDeactiveLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.expiredPolicy
        }
        
    }
    
    private func changeAllLabels(_ insurancePolicy: InsurancePolicy) {
        
        insurancePoliceTitleLabel.text = insurancePolicy.productName.capitalized
        
        switch insurancePolicy.cardId {
            
        case .alfaMedicalFlexA:
            typePolicyLabel.text = ""
            self.hideDeductibleLabel()
            self.hideInsuredAmmountLabel()
            
        case .alfaMedical:
            typePolicyLabel.text =  insurancePolicy.planName.capitalized
            if insurancePolicy.deductible != nil {
                self.showDeductibleLabel(insurancePolicy.deductible!)
            } else {
                self.hideDeductibleLabel()
            }
            if insurancePolicy.coassurance != nil {
                self.showInsuredAmmountLabel(insurancePolicy.coassurance!)
            } else {
                self.hideInsuredAmmountLabel()
            }
        
        case .alfaMedicalInternational:
            insurancePoliceTitleLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.alfaMedicalCardLabel.capitalized
            typePolicyLabel.text =  LocalizableKeys.Profile.MyInsurancePolicies.alfaMedicalInternationalCardLabel
            self.hideDeductibleLabel()
            self.hideInsuredAmmountLabel()
        
        case .optaMedica:
            typePolicyLabel.text = ""
            if insurancePolicy.deductible != nil {
                self.showDeductibleLabel(insurancePolicy.deductible!)
            } else {
                self.hideDeductibleLabel()
            }
            if insurancePolicy.coassurance != nil {
                self.showInsuredAmmountLabel(insurancePolicy.coassurance!)
            } else {
                self.hideInsuredAmmountLabel()
            }
        }
        
        if insurancePolicy.planForm == .collective {
            activeBackgroundView.isHidden = true
            planFormLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.collectiveForm
            certificationLabel.alpha = 1.0
            certificationStackView.alpha = 1.0
            certificationLabel.text = insurancePolicy.certificateId!
        } else {
            activeBackgroundView.isHidden = false
            planFormLabel.text = LocalizableKeys.Profile.MyInsurancePolicies.individualForm
            certificationLabel.alpha = 0.0
            certificationStackView.alpha = 0.0
            certificationLabel.text = ""
        }
    
        fullUserNameLabel.text = insurancePolicy.titularName
        policyCodeLabel.text = insurancePolicy.policyId
        updateValidityLabel(stringBeginningWithUppercase(insurancePolicy.endDate.monthYear()))
    }
    
    private func changeBackgroundColorAndImages(_ insurancePolicy: InsurancePolicy) {
        
        //BackgroundImage
        backImageView.image = insurancePolicy.cardId.backGroundImage
        
        //FrontImage
        policyTypeImage.image = insurancePolicy.cardId.icon
        
        let firstColor = insurancePolicy.cardId.gradientPrimaryColor
        let secondColor = insurancePolicy.cardId.gradientSecondaryColor
        changeGradientViewColor(firstColor, toColor: secondColor)
    }
    
    private func changeGradientViewColor(_ fromColor: UIColor, toColor: UIColor) {
        gradientView.initialGradientColor = fromColor
        gradientView.endGradientColor = toColor
        gradientView.cornerRadius = 5.0
        gradientView.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientView.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        setupShadow(toColor)
    }
    
    private func setupShadow(_ shadowColor: UIColor) {
        shadowBackground.backgroundColor = shadowColor
        shadowBackground.layer.cornerRadius = 5.0
        shadowBackground.layer.masksToBounds = false
        shadowBackground.layer.shadowColor = shadowColor.withAlphaComponent(0.5).cgColor
        shadowBackground.layer.shadowOffset = CGSize.init(width: 0.4, height: 15.0)
        shadowBackground.layer.shadowOpacity = 0.4
        shadowBackground.layer.shadowRadius = 4.5
    }
    
    private func stringBeginningWithUppercase(_ stringTochange: String) -> String {
        let finalString = stringTochange.trimmingCharacters(in: .whitespaces)
        if finalString.count > 1 {
            return String(finalString.first!).uppercased() + finalString.dropFirst().lowercased()
        } else
        if finalString.count == 1 {
            return finalString.uppercased()
        }
        return ""
    }
    
    private func numberWithformat(_ stringNumber: String) -> String {
        if let number = Double(stringNumber) {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = NumberFormatter.Style.decimal
            currencyFormatter.locale = NSLocale.current
            let finalQuantity = currencyFormatter.string(from: NSNumber.init(value: number)) ?? ""
            return finalQuantity != "" ? "\(finalQuantity) \(LocalizableKeys.Profile.MyInsurancePolicies.deductibleMoneySymbol)" : ""
        }
        return ""
    }
    
    private func updateValidityLabel(_ stringDate: String) {
        let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10.0),
                            NSAttributedStringKey.foregroundColor: UIColor.white]
        let mySecondAttribute = [ NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10.0),
                                  NSAttributedStringKey.foregroundColor: UIColor.white]
        let myString = NSMutableAttributedString(string: LocalizableKeys.Profile.MyInsurancePolicies.validityLabel, attributes: myAttribute )
        let dateAttributedString = NSAttributedString.init(string: stringDate, attributes: mySecondAttribute)
        myString.append(dateAttributedString)
        validityLabel.attributedText = myString
        validityLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func hideDeductibleLabel() {
        deductibleLabel.alpha = 0.0
        deductibleLabel.text = ""
        deductibleTitleLabel.alpha = 0.0
    }
    
    private func showDeductibleLabel(_ deductible: String) {
        deductibleLabel.alpha = 1.0
        deductibleLabel.text = "\(self.numberWithformat(deductible))"
        deductibleTitleLabel.alpha = 1.0
    }
    
    private func hideInsuredAmmountLabel() {
        insuredAmountLabel.alpha = 0.0
        insuredAmountLabel.text = ""
        coassuranceTitleLabel.alpha = 0.0
    }
    
    private func showInsuredAmmountLabel(_ coassurance: String) {
        insuredAmountLabel.alpha = 1.0
        var finalQuantity: String = ""
        if let number = Double(coassurance) {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = NumberFormatter.Style.none
            currencyFormatter.locale = NSLocale.current
            finalQuantity = currencyFormatter.string(from: NSNumber.init(value: number)) ?? "0"
        }
        insuredAmountLabel.text = "\(finalQuantity)%"
        coassuranceTitleLabel.alpha = 1.0
    }
    
}
