//
//  FormSceneViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 18/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import ActionSheetPicker_3_0
import IQKeyboardManagerSwift

class FormSceneViewController: UIViewController {
    
    var interactor: FormSceneBusinessLogic?
    var router: (NSObjectProtocol & FormSceneRoutingLogic & FormSceneDataPassing)?
    
    @IBOutlet weak var name: FloatingTextField!
    @IBOutlet weak var firtsName: FloatingTextField!
    @IBOutlet weak var secondName: FloatingTextField!
    @IBOutlet weak var birthdate: FloatingTextField!
    @IBOutlet weak var mail: FloatingTextField!
    @IBOutlet weak var phone: FloatingTextField!
    @IBOutlet weak var password: FloatingTextField!
    @IBOutlet weak var passwordValid: FloatingTextField!
    
    @IBOutlet weak var formScroll: UIScrollView!
    
    var datePicker: IAPickerView!
    
    var nameSuccess: Bool = false
    var firtsNameSuccess: Bool = false
    var mailSuccess: Bool = false
    var birthdaySuccess: Bool = false
    var phoneSuccess: Bool = false
    var passwordSuccess: Bool = false
    var validPasswordSuccess: Bool = false
    
    var focusInvalidField : Bool = true
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.delegate = self
        self.firtsName.delegate = self
        self.secondName.delegate = self
        self.birthdate.delegate = self
        self.mail.delegate = self
        self.phone.delegate = self
        self.password.delegate = self
        self.passwordValid.delegate = self
        self.focusInvalidField = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    @IBAction func datePressed(_ sender: Any) {
        
        let picker = ActionSheetDatePicker(title: "", datePickerMode: .date, selectedDate: Date().addYears(-18), minimumDate: Date().addYears(-100), maximumDate: Date(), target: self, action: nil, origin: self.parent!.view)
        picker?.locale = Locale(identifier: "es_MX")
        picker?.setDoneButton(UIBarButtonItem(title: LocalizableKeys.General.AlertOptions.accept, style: .plain, target: nil, action: nil))
        picker?.setCancelButton(UIBarButtonItem(title: LocalizableKeys.General.AlertOptions.cancel, style: .plain, target: nil, action: nil))
        picker?.onActionSheetDone = { picker, date, some in
            let date = date as? Date
            self.interactor?.validateDate(date)
        }
        picker?.show()
    }
}

extension FormSceneViewController {
    func dsiplayMessagePassword(_ validation: TextFieldValidationState) {
        password.validate({ () -> TextFieldValidationState in
            return validation
        })
        switch validation {
        case .valid(_):
            passwordSuccess = true
        case .invalid(_):
            passwordSuccess = false
            if focusInvalidField {
                self.password.focus()
                formScroll.setContentOffset(CGPoint(x: 0 ,y: password.frame.origin.y - 85), animated: true)
                self.focusInvalidField = false
            }
        default:
            passwordSuccess = false
        }
    }
    
    func dsiplayMessagePasswordValidate(_ validation: TextFieldValidationState) {
        passwordValid.validate({ () -> TextFieldValidationState in
            return validation
        })
        switch validation {
        case .valid(_):
            validPasswordSuccess = true
        case .invalid(_):
            validPasswordSuccess = false
            if focusInvalidField {
                self.passwordValid.focus()
                formScroll.setContentOffset(CGPoint(x: 0 ,y: passwordValid.frame.origin.y), animated: true)
                self.focusInvalidField = false
            }
        default:
            validPasswordSuccess = false
        }
    }
    
    func dsiplayMessageMail(_ validation: TextFieldValidationState) {
        mail.validate({ () -> TextFieldValidationState in
            return validation
        })
        switch validation {
        case .valid(_):
            mailSuccess = true
        case .invalid(_):
            mailSuccess = false
            if focusInvalidField {
                self.mail.focus()
                formScroll.setContentOffset(CGPoint(x: 0 ,y: mail.frame.origin.y), animated: true)
                self.focusInvalidField = false
            }
        default:
            mailSuccess = false
        }
    }
    
    func dsiplayMessagePhone(_ validation: TextFieldValidationState) {
        phone.validate({ () -> TextFieldValidationState in
            return validation
        })
        switch validation {
        case .valid(_):
            phoneSuccess = true
        case .invalid(_):
            phoneSuccess = false
            if focusInvalidField {
                self.phone.focus()
                formScroll.setContentOffset(CGPoint(x: 0 ,y: phone.frame.origin.y), animated: true)
                self.focusInvalidField = false
            }
        default:
            phoneSuccess = false
        }
    }
    
    func displayMessageDate(_ validation: TextFieldValidationState) {
        let date = router?.dataStore?.birthDate?.shortDate()
        birthdate.text = date ?? ""
        birthdate.validate({ () -> TextFieldValidationState in
            return validation
        })
        switch validation {
        case .valid(_):
            birthdaySuccess = true
        default:
            birthdaySuccess = false
        }
    }
    
    func dsiplayMessageName(_ validation: TextFieldValidationState, type: TypeName) {
        switch type {
        case .name:
            name.validate({ () -> TextFieldValidationState in
                return validation
            })
            switch validation {
            case .valid(_):
                nameSuccess = true
            case .invalid(_):
                nameSuccess = false
                if focusInvalidField {
                    self.name.focus()
                    formScroll.setContentOffset(CGPoint(x: 0 ,y: name.frame.origin.y), animated: true)
                    self.focusInvalidField = false
                }
            default:
                nameSuccess = false
            }
        case .firtsName:
            firtsName.validate({ () -> TextFieldValidationState in
                return validation
            })
            switch validation {
            case .valid(_):
                firtsNameSuccess = true
            case .invalid(_):
                firtsNameSuccess = false
                if focusInvalidField {
                    self.firtsName.focus()
                    formScroll.setContentOffset(CGPoint(x: 0 ,y: firtsName.frame.origin.y), animated: true)
                    self.focusInvalidField = false
                }
            default:
                firtsNameSuccess = false
            }
        case .secondName:
            secondName.validate({ () -> TextFieldValidationState in
                return validation
            })
            switch validation {
            case .invalid(_):
                if focusInvalidField {
                    self.secondName.focus()
                    formScroll.setContentOffset(CGPoint(x: 0 ,y: secondName.frame.origin.y), animated: true)
                    self.focusInvalidField = false
                }
            default:
                return
            }
        }
    }
    
}

// MARK: - FloatingTextField Delegate
extension FormSceneViewController: FloatingTextFieldDelegate {
    func textFieldShouldReturn(_ textField: FloatingTextField) {}
    
    func textFieldDidEndEditing(_ floatingTextField: FloatingTextField) {
        
        switch floatingTextField {
        case password:
            interactor?.validatePassword(password.text)
            
        case passwordValid:
            interactor?.validateRepeatedPassword(password.text, repeatedPassword: passwordValid.text)
            
        case mail:
            interactor?.validateMail(mail.text)
            
        case phone:
            interactor?.validatePhone(phone.text)
        
        case name:
            interactor?.validateName(name.text, type: .name)
         
        case firtsName:
            interactor?.validateName(firtsName.text, type: .firtsName)
            
        case secondName:
            interactor?.validateName(secondName.text, type: .secondName)
            
        default:
            break
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ floatingTextField: FloatingTextField) {
        
        switch floatingTextField {
        case birthdate:
            self.view.endEditing(true)
        case password:
            formScroll.setContentOffset(CGPoint(x: 0 ,y: floatingTextField.frame.origin.y - 85), animated: true)
        default:
            formScroll.setContentOffset(CGPoint(x: 0 ,y: floatingTextField.frame.origin.y), animated: true)
        }
        self.password.hideTooltip()
        
    }
    
}

