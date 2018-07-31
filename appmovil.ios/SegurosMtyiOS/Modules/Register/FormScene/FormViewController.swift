//
//  FormViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 18/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

protocol FormSceneDisplayLogic: class {
    func dsiplayMessagePassword(_ validation: TextFieldValidationState)
    func dsiplayMessagePasswordValidate(_ validation: TextFieldValidationState)
    func dsiplayMessageMail(_ validation: TextFieldValidationState)
    func dsiplayMessagePhone(_ validation: TextFieldValidationState)
    func dsiplayMessageName(_ validation: TextFieldValidationState, type: TypeName)
    func dsiplayMessageDate(_ validation: TextFieldValidationState)
    func displayRegisterSuccess()
}

class FormViewController: UIViewController, ErrorDisplayLogic {
    
    var interactor: FormSceneBusinessLogic?
    var router: (NSObjectProtocol & FormSceneRoutingLogic & FormSceneDataPassing)?
    
    @IBOutlet weak var terms: UILabel!

    var form: FormSceneViewController? {
        return self.childViewControllers.first(where: { $0 is FormSceneViewController }) as? FormSceneViewController
    }
    
    
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
        let interactor = FormSceneInteractor()
        let presenter = FormScenePresenter()
        let router = FormSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    @IBAction func nextPressed() {
        self.form?.focusInvalidField = true
        self.form?.interactor?.validateName((form?.name.text)!, type: .name)
        self.form?.interactor?.validateName((form?.firtsName.text)!, type: .firtsName)
        self.form?.interactor?.validateName((form?.secondName.text)!, type: .secondName)
        self.form?.interactor?.validateDate((form?.birthdate.text.dateFormatPicker())!)
        self.form?.interactor?.validateMail((form?.mail.text)!)
        self.form?.interactor?.validatePhone((form?.phone.text)!)
        self.form?.interactor?.validatePassword((form?.password.text)!)
        self.form?.interactor?.validateRepeatedPassword((form?.password.text)!, repeatedPassword: (form?.passwordValid.text)!)
        
        if (form?.nameSuccess)! && (form?.firtsNameSuccess)! && (form?.birthdaySuccess)! && (form?.mailSuccess)! && (form?.phoneSuccess)! && (form?.passwordSuccess)! && (form?.validPasswordSuccess)! {
            interactor?.register()
        }
    }
    
    @IBAction func sendTerms(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.login()
        let termsConditions = storyboard.instantiateViewController(withIdentifier: "login")
        self.show(termsConditions, sender: nil)
    }
    
    func setupView () {
        self.setTranslucentNavigationBar()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                        NSAttributedStringKey.font: UIFont.AppFonts.Regular.ofSize(17.0)]
        self.setCustomBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? FormSceneViewController {
            viewController.interactor = self.interactor
            viewController.router = self.router
        }
    }

}

extension FormViewController: FormSceneDisplayLogic {
    func dsiplayMessagePassword(_ validation: TextFieldValidationState) {
        self.form?.dsiplayMessagePassword(validation)
    }
    
    func dsiplayMessagePasswordValidate(_ validation: TextFieldValidationState) {
        self.form?.dsiplayMessagePasswordValidate(validation)
    }
    
    func dsiplayMessageMail(_ validation: TextFieldValidationState) {
        self.form?.dsiplayMessageMail(validation)
    }
    
    func dsiplayMessagePhone(_ validation: TextFieldValidationState) {
        self.form?.dsiplayMessagePhone(validation)
    }
    
    func dsiplayMessageName(_ validation: TextFieldValidationState, type: TypeName) {
        self.form?.dsiplayMessageName(validation, type: type)
    }
    
    func dsiplayMessageDate(_ validation: TextFieldValidationState) {
        self.form?.displayMessageDate(validation)
    }
    
    func displayRegisterSuccess() {
        IALoader.shared.hide()
        let alert = IABlurAlertController(title: nil, message: LocalizableKeys.Register.registerSuccess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.activateAccount, style: .default, handler: { (action) in
                self.router?.goToCheckCode()
        }))
    self.present(alert, animated: true, completion: nil)
    
    }
}
