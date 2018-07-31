//
//  AboutViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 15/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

protocol AboutDisplayLogic: class {
    
    func displayMailCompose(viewModel: About.SendMail.ViewModel)
    
}

class AboutViewController: UIViewController {
    
    @IBOutlet weak var copyright: UILabel!
    @IBOutlet weak var version: UILabel!
    
    var interactor: AboutInteractor = AboutInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let viewController = self
        let presenter = AboutPresenter()
        interactor.presenter = presenter
        presenter.viewController = viewController
        
    }
    
    func setupView () {
        self.title = LocalizableKeys.Profile.About.aboutTitle
        self.copyright.text = "© 2018 Seguros Monterrey New York Life \nTodos los derechos reservados."
        self.version.text = Util.getAppVersion()
      
    }
    
    @IBAction func sendToLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard.login()
        let termsConditions = storyboard.instantiateViewController(withIdentifier: "login")
        termsConditions.hidesBottomBarWhenPushed = true
        self.show(termsConditions, sender: nil)
    }
    
    @available(iOS 11.0, *)
    @IBAction func sendToPrivaci(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        let privacy = storyboard.instantiateViewController(withIdentifier: "privacy") as! PrivacyViewController
        privacy.hidesBottomBarWhenPushed = true
        privacy.setURL = "https://www.mnyl.com.mx/aviso-de-privacidad.aspx"
        self.show(privacy, sender: nil)
    }
    
    @IBAction func supportMailButtonPressed(_ sender: Any) {
    
        MFMailComposeViewController().mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail() {
            let request = About.SendMail.Request.init(emailDirectionToSend: LocalizableKeys.Profile.About.supportEmail)
            
            self.interactor.sendMail(request)
            
        } 
        
    }
    
}

extension AboutViewController: AboutDisplayLogic {
    
    func displayMailCompose(viewModel: About.SendMail.ViewModel) {
        
        viewModel.mailComposeViewController.mailComposeDelegate = self
        self.present(viewModel.mailComposeViewController, animated: true, completion: nil)
        
    }
    
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .sent, .cancelled, .saved:
            
            controller.dismiss(animated: true, completion: nil)
        
        case .failed:
            
            let sendMailErrorAlert = UIAlertController.init(title: LocalizableKeys.Profile.About.Error.errorSendingEMailTitle, message: LocalizableKeys.Profile.About.Error.errorDescriptionSendingEMail, preferredStyle: .alert)
            let acceptAction = UIAlertAction.init(title: LocalizableKeys.General.AlertOptions.accept, style: .default, handler: { _ in
                
                controller.dismiss(animated: true, completion: nil)
                
            })
            
            sendMailErrorAlert.addAction(acceptAction)
            
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        
        
    }
    
}
