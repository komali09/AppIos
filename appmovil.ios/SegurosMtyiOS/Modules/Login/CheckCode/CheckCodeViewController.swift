//
//  CheckCodeViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 07/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CheckCodeDisplayLogic: class {
    func displayRequestCode(viewModel: RecoverPassword.GenerateCodeToRecoverPassword.ViewModel)
    func displayCodeValidation(validationState: TextFieldValidationState)
    func displayVerifyCode(viewModel: CheckCode.VerifyCode.ViewModel)
    func displayLogin(viewModel: Login.Login.ViewModel)
}

class CheckCodeViewController: UIViewController {
    var interactor: CheckCodeBusinessLogic?
    var router: (NSObjectProtocol & CheckCodeRoutingLogic & CheckCodeDataPassing)?
    
    @IBOutlet weak var codeTextFiled: FloatingTextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var checkCode: Bool = false
    
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
        let interactor = CheckCodeInteractor()
        let presenter = CheckCodePresenter()
        let router = CheckCodeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.codeTextFiled.delegate = self
        self.interactor?.requestCode()
        if self.navigationController?.viewControllers.contains(where: { $0 is FormViewController }) ?? false{
            pageControl.isHidden = false
        }
        self.setupTitleLabel()
    }
    
    func setupTitleLabel() {
        var size : CGFloat = 18.0
        if DeviceDetector.DeviceType.IS_IPHONE_5 {
            size = 16.0
        }
        let attributedString = NSMutableAttributedString(string: LocalizableKeys.RecoverPassword.descriptionSMS)
        attributedString.addAttributes( [NSAttributedStringKey.foregroundColor : UIColor.smTealBlue] , range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.AppFonts.Regular.ofSize(size), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.AppFonts.Bold.ofSize(size), range: NSRange(location: 17, length: 3))
        attributedString.addAttribute(.font, value: UIFont.AppFonts.Bold.ofSize(size), range: NSRange(location: 25, length: 20))
        self.titleLabel.attributedText = attributedString
    }
    
    // MARK: View lifecycle
    @IBAction func resendCodePressed(_ sender: Any) {
         self.interactor?.requestCode()
    }
    
    @IBAction func validateCode(_ sender: Any) {
        self.view.endEditing(true)
        if checkCode {
            IALoader.shared.show(LocalizableKeys.Loader.checkCode)
            self.interactor?.verifyCode()
        } else if checkCode == false && self.codeTextFiled.text == "" {
            self.displayCodeValidation(validationState: .invalid(message: LocalizableKeys.RecoverPassword.emptyCode))
        }
    }
    
}

extension CheckCodeViewController : CheckCodeDisplayLogic {
    func displayRequestCode(viewModel: RecoverPassword.GenerateCodeToRecoverPassword.ViewModel) {
        if !viewModel.success, let message = viewModel.message {
            self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
        }
    }
    
    func failedProcessRecoverPassword() {
        debugPrint("")
    }
    
    func displayCodeValidation(validationState: TextFieldValidationState) {
        switch validationState {
        case .valid:
            checkCode = true
        default:
            checkCode = false
        }
        self.codeTextFiled.validate { validationState }
    }
    
    func displayVerifyCode(viewModel: CheckCode.VerifyCode.ViewModel) {
        IALoader.shared.hide()
        switch viewModel.status {
        case .success(let message):
            if viewModel.validationCodeProccessType == .activate {
                self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.login, action: { (action) in
                    self.interactor?.login()
                })
            } else {
                self.router?.goToRenewPasswordViewController()
            }
        case .invalidPhoneOrCode(let message):
            self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
        case .errorWithData(let message):
            self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
        case .other(let message):
            self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
        }
    }
    
    func displayLogin(viewModel: Login.Login.ViewModel) {
        switch viewModel.status {
        case .ok:
            router?.goToMenu()
        case .other(let message):
            self.showAlert(with: nil, message: message, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
        default:
            break
        }
    }
}

// MARK: - FloatingTextFieldDelegate
extension CheckCodeViewController : FloatingTextFieldDelegate  {
    func textFieldShouldReturn(_ textField: FloatingTextField) {}
    
    func textFieldDidBeginEditing(_ textField: FloatingTextField){
        return
    }
    
    func textFieldDidEndEditing(_ textField: FloatingTextField){
        interactor?.validateCode(textField.text)
    }
}
