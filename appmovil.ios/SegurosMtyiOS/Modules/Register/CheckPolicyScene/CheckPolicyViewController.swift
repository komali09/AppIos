//
//  CheckPolicyViewController.swift
//  SegurosMtyiOS
//
//  Created by Mariana on 19/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CheckPolicyDisplayLogic: class {
    func displayPolicyValidation(viewModel: CheckPolicy.RegisterPolicy.ViewModel)
    func displayCertificatePolicy()
}

class CheckPolicyViewController: UIViewController, ErrorDisplayLogic {
    var interactor: CheckPolicyBusinessLogic?
    var router: (NSObjectProtocol & CheckPolicyRoutingLogic & CheckPolicyDataPassing)?
    
    @IBOutlet weak var policy: FloatingTextField!
    @IBOutlet weak var certificate: FloatingTextField!
    @IBOutlet weak var information: UILabel!
    
    @IBOutlet weak var certificateReference: UIView!
    @IBOutlet weak var policyReference: UIView!
    
    @IBOutlet weak var showExampleInd: UIButton!
    @IBOutlet weak var showExampleCol: UIButton!
    
    
    @IBOutlet weak var polTopCons: NSLayoutConstraint!
    @IBOutlet weak var certTopCons: NSLayoutConstraint!
    
    var isCertificateFieldHidden : Bool = true
    var isPolicyValid: Bool = false
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CheckPolicyInteractor()
        let presenter = CheckPolicyPresenter()
        let router = CheckPolicyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    //MARK: Actions
    @IBAction func continuePressed() {
        if isPolicyValid {
           router?.checkPolicyToForm()
        } else {
            if isCertificateFieldHidden {
                if policy.text.isEmpty {
                    policy.validate({ .invalid(message: LocalizableKeys.Register.registerWritePolicy) })
                } else {
                    self.displayError(with: LocalizableKeys.Register.invalidPolicy)
                }
            } else {
                if certificate.text.isEmpty {
                    certificate.validate({ .invalid(message: LocalizableKeys.Profile.AddPolicy.Error.emptyCertificate) })
                } else {
                    self.displayError(with: LocalizableKeys.Register.invalidPolicyColective)
                }
            }
        }
        
    }
    
    @IBAction func showExampleInd(_ sender: UIButton) {
        router?.checkPolicyToExamplePolicyInd()
    }
    
    @IBAction func showExampleCol(_ sender: UIButton) {
        router?.checkPolicyToExamplePolicyCol()
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificate.delegate = self
        policy.delegate = self
        self.setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isPolicyValid = false
        if !(policy.text.isEmpty) {
            interactor?.validatePolicy(request: CheckPolicy.RegisterPolicy.Request(policy: policy.text, certicate: certificate.text, type: .individual))
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func showCertifiacteField() {
        if !isCertificateFieldHidden {
            return
        }
        isCertificateFieldHidden = false
        polTopCons.constant = 30
        certTopCons.constant = 110
        UIView.animate(withDuration: 0.3) {
            self.information.alpha = 0
            self.certificate.alpha = 1
            self.certificateReference.alpha = 1
            self.policyReference.superview?.layoutIfNeeded()
            self.certificateReference.superview?.layoutIfNeeded()
        }
    }
   
    private func hideCertifiacteField() {
        if isCertificateFieldHidden {
            return
        }
        isCertificateFieldHidden = true
        polTopCons.constant = 118
        certTopCons.constant = 118
        UIView.animate(withDuration: 0.3) {
            self.information.alpha = 1
            self.certificate.alpha = 0
            self.certificateReference.alpha = 0
            self.policyReference.superview?.layoutIfNeeded()
            self.certificateReference.superview?.layoutIfNeeded()
        }
    }
    
    func setupLabel(){
        let attributedString = NSMutableAttributedString(string: "Puedes ingresar cualquiera de tus pólizas activas de Gastos Médicos Mayores para crear tu cuenta.")
        attributedString.addAttributes( [NSAttributedStringKey.foregroundColor : UIColor.smTealBlue] , range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.AppFonts.Regular.ofSize(18.0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.AppFonts.Bold.ofSize(18.0), range: NSRange(location: 53, length: 22))
        self.information.attributedText = attributedString
    }
}


extension CheckPolicyViewController: CheckPolicyDisplayLogic {
    func displayPolicyValidation(viewModel: CheckPolicy.RegisterPolicy.ViewModel) {
        let isValid = viewModel.validationState == .valid(message: "")
        isPolicyValid = isValid
        
        switch viewModel.type {
        case .individual:
            policy.validate({ viewModel.validationState })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showExampleInd.alpha = isValid ? 0 : 1
            }
        case .collective:
            certificate.validate({ viewModel.validationState })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showExampleCol.alpha = isValid ? 0 : 1
            }
        }
    }
    
    func displayCertificatePolicy(){
        self.policy.validate({ .valid(message: "") })
        self.showCertifiacteField()
        self.certificate.focus()
    }
}

//MARK: Floating field
extension CheckPolicyViewController: FloatingTextFieldDelegate {
    func textFieldShouldReturn(_ textField: FloatingTextField) {
        
    }
    
    func textFieldDidEndEditing(_ floatingTextField: FloatingTextField) {
        floatingTextField.isValidating = true
        
        if floatingTextField.text == "" {
            self.isPolicyValid = false
        }
        
        switch floatingTextField {
        case policy:
            if floatingTextField.text.isEmpty {
                floatingTextField.validate { .invalid(message: LocalizableKeys.Profile.AddPolicy.Error.emptyNewPolicy) }
                self.showExampleInd.alpha = 1
                return
            }
            self.showExampleInd.alpha = 0
            interactor?.validatePolicy(request: CheckPolicy.RegisterPolicy.Request(policy: policy.text, certicate: certificate.text, type: .individual))
        case certificate:
            if floatingTextField.text.isEmpty {
                floatingTextField.validate { .invalid(message: LocalizableKeys.Profile.AddPolicy.Error.emptyCertificate) }
                self.showExampleCol.alpha = 1
                return
            }
            self.showExampleCol.alpha = 0
            interactor?.validatePolicy(request: CheckPolicy.RegisterPolicy.Request(policy: policy.text, certicate: certificate.text, type: .collective))
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ floatingTextField: FloatingTextField) {
        if floatingTextField == policy {
            self.hideCertifiacteField()
            self.certificate.text = ""
        }
    }
}
