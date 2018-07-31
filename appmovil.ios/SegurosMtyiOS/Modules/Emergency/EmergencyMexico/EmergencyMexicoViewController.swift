//
//  EmergencyMexicoViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 27/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum TypeMexicoViewController {
    case Emergency
    case Assistance
}

class EmergencyMexicoViewController: IAPopupViewController {
    var interactor: EmergencyMexicoBusinessLogic?
    var router: (NSObjectProtocol & EmergencyMexicoRoutingLogic & EmergencyMexicoDataPassing)?
    
    @IBOutlet weak var titleAssistance: UILabel!
    @IBOutlet weak var phoneMexico: UIButton!
    @IBOutlet weak var phoneRestWorld: UIButton!
    
    
    var type : TypeMexicoViewController = .Emergency
    
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
        let interactor = EmergencyMexicoInteractor()
        let router = EmergencyMexicoRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.show()
        super.viewDidLoad()
        self.setupViewUI()
    }
    
    // MARK: Do something
    @IBAction func closeView(_ sender: UIButton) {
        self.router?.goToEmergencyViewController()
    }
    
    func setupViewUI() {
        switch type {
        case .Emergency:
            self.titleAssistance.text = "Asistencia en México"
        default:
            self.titleAssistance.text = "Solicitar asistencia"
        }
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        var assistancePhone: AssistancePhone?
        switch sender.tag {
        case 1:
            assistancePhone = .withinMexico
        case 2:
            assistancePhone = .wihtinRestOfMexico
        default:
            return
        }
        
        let request = EmergencyMexico.CallAtPhone.Request(assistancePhone: assistancePhone!)
        self.interactor?.doCallAtPhone(request: request)
    }
}
