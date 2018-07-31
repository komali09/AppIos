//
//  EditPasswordViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditPasswordDisplayLogic: class {
    func showMessageNewPassword(_ validation: TextFieldValidationState)
    func showMessageActualPassword(_ validation: TextFieldValidationState)
    func showMessageForRepeatPassword(_ validation: TextFieldValidationState)
    func successfullPasswordUpdate()
    func errorUpdatingPassword()
}

class EditPasswordViewController: UIViewController, EditPasswordDisplayLogic, ExpiredSessionDisplayLogic, ErrorDisplayLogic {
    var interactor: EditPasswordBusinessLogic?
    var router: (NSObjectProtocol & EditPasswordRoutingLogic & EditPasswordDataPassing)?
    
    //@IBOutlet weak var someTextField: UITextField!
    @IBOutlet weak var currentPasswordView: FloatingTextField!
    @IBOutlet weak var newPasswordView: FloatingTextField!
    @IBOutlet weak var repeatedNewPassword: FloatingTextField!
    @IBOutlet weak var changePassword: IAGradientButton!
    
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
        let interactor = EditPasswordInteractor()
        let presenter = EditPasswordPresenter()
        let router = EditPasswordRouter()
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        doSomething()
    }
    
    // MARK: Do something
    
    func setupViews() {
        
        currentPasswordView.isSecureTextEntry = true
        currentPasswordView.delegate = self
        
        newPasswordView.isSecureTextEntry = true
        newPasswordView.delegate = self
        
        repeatedNewPassword.isSecureTextEntry = true
        repeatedNewPassword.delegate = self
        
    }
    
    func doSomething() {
        let request = EditPassword.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        IALoader.shared.show(LocalizableKeys.Loader.changePassword)
        interactor?.changePassword(currentPasswordView.text, newPassword: newPasswordView.text, attemptNewPassword: repeatedNewPassword.text)
    }
    
    func showMessageActualPassword(_ validation: TextFieldValidationState) {
        currentPasswordView.validate { () -> TextFieldValidationState in
            return validation
        }
    }
    
    func showMessageNewPassword(_ validation: TextFieldValidationState) {
        
        newPasswordView.validate { () -> TextFieldValidationState in
            
            switch validation {
            case .invalid(message: LocalizableKeys.Login.invalidPassword):
                self.newPasswordView.isTooltipHidden = false
            
            case .invalid(message: LocalizableKeys.Profile.EditPassword.errorEmptyPassword):
                self.newPasswordView.isTooltipHidden = true
                
            default:
                break
            }
            return validation
        }
        
    }
    
    func showMessageForRepeatPassword(_ validation: TextFieldValidationState) {
        repeatedNewPassword.validate({ () -> TextFieldValidationState in
            return validation
        })
    }
    
    func successfullPasswordUpdate() {
        IALoader.shared.hide()
        self.showAlert(with: nil, message: LocalizableKeys.Profile.EditPassword.successfullEditPassword, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: { (action) in
             self.router?.moveToMenu()
        })
    }
    
    func errorUpdatingPassword() {
        IALoader.shared.hide()
        self.showAlert(with: nil, message: LocalizableKeys.Profile.EditPassword.errorTitle, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
    }
}

extension EditPasswordViewController: FloatingTextFieldDelegate {
    func textFieldShouldReturn(_ textField: FloatingTextField) {}
    
    func textFieldDidEndEditing(_ floatingTextField: FloatingTextField) {
        
        switch floatingTextField {
            case currentPasswordView:
            interactor?.validateOldPassword(currentPasswordView.text)
            
            case newPasswordView:
            interactor?.validateNewPassword(newPasswordView.text)
            
            case repeatedNewPassword:
                interactor?.validateRepeatedNewPassword(newPasswordView.text, repeatedPassword: repeatedNewPassword.text)
            
        default:
            break
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ floatingTextField: FloatingTextField) {}
    
}