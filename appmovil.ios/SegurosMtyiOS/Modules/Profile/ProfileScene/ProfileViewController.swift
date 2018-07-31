//
//  ProfileViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/7/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProfileDisplayLogic: class {
    func displayUserInfo(viewModel: Profile.UserInfo.ViewModel)
    func displayInsurancePolicies(viewModel: Profile.InsurancePolicies.ViewModel)
    func displayAdvisor(_ advisor: Profile.AdvisorInfo.ViewModel)
    func displayOnscreenError(type: IAErrorAlertType)
    func displayAdvisorOnscreenError(type: IAErrorAlertType)
    func displayLogout()
}

class ProfileViewController: UIViewController, ExpiredSessionDisplayLogic, ErrorDisplayLogic {
    var interactor: (ProfileBusinessLogic & ProfileDataStore)?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var lblPoliza: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var mainSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topSpaceName: NSLayoutConstraint!
    @IBOutlet weak var trailingClosebtn: NSLayoutConstraint!
    @IBOutlet weak var bottomEdithbtn: NSLayoutConstraint!
    @IBOutlet weak var bottomClosebtn: NSLayoutConstraint!
    @IBOutlet weak var topUserImage: NSLayoutConstraint!
    @IBOutlet weak var topName: NSLayoutConstraint!
    
    private var secondTimeAppearing: Bool = false
    
    var welcomeView: WelcomeMenuSceneViewController?
    
    var currentViewController: UIViewController?

    lazy var infoViewController: ProfileInformationViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "profileInfo") as? ProfileInformationViewController
        return vc
    }()
    
    lazy var policiesViewController: MyInsurancePoliciesViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "policies") as? MyInsurancePoliciesViewController
        vc?.interactor = self.interactor
        vc?.router = self.router
        return vc
    }()
    
    
    lazy var advisorsViewController: AdvisorViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "advisors") as? AdvisorViewController
        vc?.interactor = self.interactor
        vc?.router = self.router
        return vc
    }()
    
    
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
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTranslucentNavigationBar()
        self.setCustomBackButton()
        self.showWelcome()
        self.title = "Perfil"
        
        mainSegmentedControl.sendActions(for: .valueChanged)
        loadData()
        setupConstrainsInIphonePlus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         UIApplication.shared.statusBarStyle = .lightContent
        
        if secondTimeAppearing {
            interactor?.loadProfileData()
        }
    }
    
    func showWelcome() {
        let storyboard = UIStoryboard.welcomeMenu()
        welcomeView = storyboard.instantiateInitialViewController() as? WelcomeMenuSceneViewController
        welcomeView?.modalPresentationStyle = .custom
        self.present(welcomeView!, animated: true, completion: nil)
    }
    
    func hideWelcome() {
        self.welcomeView?.dismiss(animated: true, completion: nil)
    }
    
    
    func loadData() {
        interactor?.loadProfileData()
    }
    
    //MARK: Actions
    @IBAction func editPressed() {
        self.secondTimeAppearing = true
        self.router?.goToEditProfileViewController()
    }
    
    @IBAction func closeSeesionPressed() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.logout, style: .destructive, handler: { action in
            self.interactor?.logout()
        }))
        alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupConstrainsInIphonePlus() {
        if !DeviceDetector.DeviceType.IS_IPHONE_5 {
            self.topSpaceName.constant = 15
            self.trailingClosebtn.constant = 50
            self.bottomEdithbtn.constant = 15
            self.bottomClosebtn.constant = 15
            
            if DeviceDetector.DeviceType.IS_IPHONE_X {
                self.topName.constant = 85
                self.topUserImage.constant = 85
            }
        }
    }
}

//MARK: - ProfileDisplayLogic
extension ProfileViewController : ProfileDisplayLogic {
    func displayUserInfo(viewModel: Profile.UserInfo.ViewModel) {
        
        lblName.text = viewModel.firstName
        lastName.text = viewModel.lastName
        userImgView.image = viewModel.profilePic
        lblPoliza.text = viewModel.polizy
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.infoViewController?.updateUserInfo(with: viewModel.birthDate, email: viewModel.email)
        }
    }
    
    func displayInsurancePolicies(viewModel: Profile.InsurancePolicies.ViewModel) {
        policiesViewController?.reloadData()
    }
    
    func displayAdvisor(_ advisor: Profile.AdvisorInfo.ViewModel) {
        advisorsViewController?.displayAdvisor(advisor)
    }
    
    func displayLogout() {
        IALoader.shared.hide()
        UIStoryboard.loadWelcome()
    }
    
    func displayOnscreenError(type: IAErrorAlertType) {
        IALoader.shared.hide()
        policiesViewController?.displayError(of: type)
    }
    
    func displayAdvisorOnscreenError(type: IAErrorAlertType) {
        IALoader.shared.hide()
        advisorsViewController?.displayError(of: type)
    }
}

//MARK: - SegmentedControl Value Changed
extension ProfileViewController {
    
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.container.alpha = 0.0
            self.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -5)
        }) { (completed) in
            self.currentViewController?.view.removeFromSuperview()
            self.currentViewController?.removeFromParentViewController()
            
            self.displayCurrentTab(sender.selectedSegmentIndex)
            self.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 5)
            UIView.animate(withDuration: 0.2) {
                self.container.alpha = 1.0
                self.container.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
            }
        }
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.container.bounds
            self.container.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        switch index {
        case 0:
            return infoViewController
        case 1:
            return policiesViewController
        case 2:
            return advisorsViewController
        default:
            return nil
        }
    }
    
}