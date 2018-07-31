//
//  AdvisorViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/28/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class AdvisorViewController: UIViewController {
    
    @IBOutlet weak private var errorView: IAErrorView!
    @IBOutlet weak private var mainView: UIStackView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak private var advisorNameView: UIView?
    @IBOutlet weak private var advisorName: UILabel!
    
    @IBOutlet weak private var advisorPhoneView: UIView?
    @IBOutlet weak private var advisorPhone: UIButton!
    
    @IBOutlet weak private var advisorEmailView: UIView?
    @IBOutlet weak private var advisorEmail: UIButton!
    
    private var phone:String?
    private var email:String?
    
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        mainView.isHidden = true
        errorView.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getAdvisorData()
    }
    
    func displayError(of type: IAErrorAlertType) {
        activityIndicator.stopAnimating()
        mainView.isHidden = true
        
        if type == .noInternet {
            errorView.show(type: .noInternet, message: LocalizableKeys.General.noInternet, actionMessage: "Reintentar") {
                self.activityIndicator.startAnimating()
                self.mainView.isHidden = true
                self.errorView.hide()
                self.interactor?.getAdvisorData()
            }
        } else if type == .emptyPolicies {
            errorView.show(type: .noSearchResults, message: LocalizableKeys.Profile.emptyPolicies)
        } else {
            errorView.show(type: .noSearchResults, message: LocalizableKeys.Profile.noAdvisor)
        }
    }

    func displayAdvisor(_ advisor: Profile.AdvisorInfo.ViewModel) {
        activityIndicator.stopAnimating()
        mainView.isHidden = false
        errorView.hide()
        
        self.phone = advisor.phone
        self.email = advisor.email
        
        if let name = advisor.name {
            advisorName.text = name
        } else {
            advisorNameView?.removeFromSuperview()
        }
        if let phone = advisor.phone {
            advisorPhone.setTitle(phone, for: .normal)
        } else {
            advisorPhoneView?.removeFromSuperview()
        }
        if let email = advisor.email {
            advisorEmail.setTitle(email, for: .normal)
        } else {
            advisorEmailView?.removeFromSuperview()
        }
    }
    
    @IBAction func phoneNumberPressed(_ sender: Any) {
        guard let phoneNumber = self.phone,
            let url = URL(string: "telprompt://\(phoneNumber)") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func emailPressed(_ sender: Any) {
        guard let email = self.email,
        let url = URL(string: "mailto:\(email)") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
