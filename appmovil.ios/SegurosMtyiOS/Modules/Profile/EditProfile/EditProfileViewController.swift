//
//  EditProfileViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 28/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit
import RxSwift

protocol EditProfileDisplayLogic: class {
    func displayUserInfo(viewModel: EditProfile.GetUserInfo.ViewModel)
    func displaySaveProfile(viewModel: EditProfile.SaveProfile.ViewModel)
}

class EditProfileViewController: UIViewController, ExpiredSessionDisplayLogic, ErrorDisplayLogic {

    // MARK: - Properties
    var interactor: EditProfileBusinessLogic?
    var router: (NSObjectProtocol & EditProfileRoutingLogic & EditProfileDataPassing)?
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var imageChanged = false
    fileprivate var emailChanged = false

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var saveButton: IAGradientButton!
    
    var disposableBag: DisposeBag = DisposeBag()
    
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
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        let router = EditProfileRouter()
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
        setupUI()
    }

    // MARK: - Actions
    @objc private func profileImagePressed() {
        RequestResourcesManager.isAuthorizedToUseCamera().subscribe { (event) in
            switch event {
            case .next(let isAuthorized):
                self.requestPhotosLibrary(isAuthorizedCamera: isAuthorized)
            default:
                break
            }
        }.disposed(by: self.disposableBag)
    }
    
    private func requestPhotosLibrary(isAuthorizedCamera: Bool) {
        RequestResourcesManager.isAuthorizedToAccessPhotos().subscribe { (event) in
            switch event {
            case .next(let isAuthorized):
                self.prepareUIImagePickerViewController(isAuthorizedCamera: isAuthorizedCamera, isAuthorizedPhotos: isAuthorized)
            default:
                break
            }
            }.disposed(by: self.disposableBag)
    }
    
    private func prepareUIImagePickerViewController(isAuthorizedCamera: Bool, isAuthorizedPhotos: Bool) {
        if isAuthorizedCamera == false && isAuthorizedPhotos == false {
            let alert = IABlurAlertController(title: nil, message: LocalizableKeys.General.openSettingsCameraAndGaleryPhotos, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.cancel, style: .default, handler: nil))
            
            alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.configuration, style: .default, handler: { (action) in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: { (completion) in
                            alert.dismiss(animated: true, completion: nil)
                        })
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        DispatchQueue.main.async(execute: {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if isAuthorizedCamera {
                let cameraAction = UIAlertAction(title: "Tomar foto", style: .default, handler: { [unowned self] _ in
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.imagePicker.delegate = self
                        self.imagePicker.sourceType = .camera
                        self.imagePicker.allowsEditing = false
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                })
                actionSheet.addAction(cameraAction)
            }
            
            if isAuthorizedPhotos {
                let libraryAction = UIAlertAction(title: "Seleccionar foto", style: .default, handler: { [unowned self] _ in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        self.imagePicker.delegate = self
                        self.imagePicker.sourceType = .photoLibrary
                        self.imagePicker.allowsEditing = false
                        
                        self.imagePicker.setCustomNavigation()
                        
                        
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                })
                actionSheet.addAction(libraryAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        })
    }

    @IBAction func editPasswordPressed(_ sender: Any) {
        self.router?.goToEditPasswordViewController()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        if emailChanged {
            emailTextField.validate {
                let email = emailTextField.text
                if Util.validateEmail(email) {
                    let req = EditProfile.SaveProfile.Request(email: email, image: imageChanged ? profileImageView.image : nil)
                    interactor?.requestSaveProfile(request: req)
                    return .valid(message: "")
                    
                } else {
                    return .invalid(message: email.isEmpty ? LocalizableKeys.Profile.EditProfile.errorEmailEmpty : LocalizableKeys.Profile.EditProfile.errorEmailInvalid)
                }
            }
        }

    }

    // MARK: - Private Methods
    private func setupUI() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImagePressed)))
        emailTextField.delegate = self
        interactor?.requestUserInfo()
    }

}

// MARK: - Display Logic Methods
extension EditProfileViewController: EditProfileDisplayLogic {
    func displayUserInfo(viewModel: EditProfile.GetUserInfo.ViewModel) {
        emailTextField.text = viewModel.email
        emailTextField.titleText.alpha = 1
        emailTextField.titleText.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        if let image = viewModel.userPicture {
            profileImageView.image = image
        }
    }

    func displaySaveProfile(viewModel: EditProfile.SaveProfile.ViewModel) {
        IALoader.shared.hide()
        self.showAlert(with: nil, message: viewModel.msg, actionTitle: LocalizableKeys.General.AlertOptions.accept) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - FloatingTextField Delegate
extension EditProfileViewController: FloatingTextFieldDelegate {
    func textFieldShouldReturn(_ textField: FloatingTextField) {}
    
    
    func textFieldDidBeginEditing(_ floatingTextField: FloatingTextField) {

    }

    func textFieldDidEndEditing(_ floatingTextField: FloatingTextField) {
        let email = emailTextField.text
        emailChanged = true
        emailTextField.validate {
            if Util.validateEmail(email) {
                return .valid(message: "")
            } else {
                return .invalid(message: email.isEmpty ? LocalizableKeys.Profile.EditProfile.errorEmailEmpty : LocalizableKeys.Profile.EditProfile.errorEmailInvalid)
            }
        }
    }
}

// MARK: - Image Picker Delegate Methods
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageChanged = true
            profileImageView.image = image
            let req = EditProfile.SaveProfile.OnlyImageRequest(image: profileImageView.image)
            interactor?.requestOnlySaveImage(requestOnlyImage: req)
        }
        dismiss(animated: true, completion: nil)
    }
}
