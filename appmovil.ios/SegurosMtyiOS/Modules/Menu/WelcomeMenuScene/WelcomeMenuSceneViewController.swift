//
//  WelcomeMenuSceneViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 04/12/17.
//  Copyright (c) 2017 Erwin Jonnatan Perez Téllez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WelcomeMenuSceneDisplayLogic: class {
    func displayInfoUser(viewModel: WelcomeMenuScene.LoadUser.ViewModel)
}

class WelcomeMenuSceneViewController: UIViewController, WelcomeMenuSceneDisplayLogic {
    var interactor: WelcomeMenuSceneBusinessLogic?
    var router: (NSObjectProtocol & WelcomeMenuSceneRoutingLogic & WelcomeMenuSceneDataPassing)?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dateLastSesion: UILabel!
    @IBOutlet weak var lasSessionLabel: UILabel!
    
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
        let interactor = WelcomeMenuSceneInteractor()
        let presenter = WelcomeMenuScenePresenter()
        let router = WelcomeMenuSceneRouter()
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
        doSomething()
    }
    
    // MARK: Do something
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doSomething() {
        interactor?.loadUser()
    }
    
    func displayInfoUser(viewModel: WelcomeMenuScene.LoadUser.ViewModel) {
        self.name.text = viewModel.name
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd LLL YYYY 'a las' hh:mm a"
        let date = dateFormatter.string(from: viewModel.date.dateTimeFormat())
        self.dateLastSesion.text = "\(date)"
        
        self.dateLastSesion.isHidden = viewModel.date.isEmpty
        self.lasSessionLabel.isHidden = viewModel.date.isEmpty
    }
}