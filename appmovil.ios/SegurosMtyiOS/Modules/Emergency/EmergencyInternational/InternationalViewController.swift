//
//  InternacionalViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 02/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class InternationalViewController: IAPopupViewController {
    var interactor: InternationalInteractor?
    var router: (NSObjectProtocol & InternationalRoutingLogic & InternationalDataPassing)?
    
    @IBOutlet weak var phoneUSA: UIButton!
    @IBOutlet weak var phoneWorld: UIView!
    
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
        let interactor = InternationalInteractor()
        let router = InternationalRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.show()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeModal(_ sender: UIButton) {
        self.router?.goToEmergencyViewController()
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        var assistancePhone: AssistancePhone?
        switch sender.tag {
        case 1:
            assistancePhone = .withinUSAAndCanada
        case 2:
            assistancePhone = .withinRestOfTheWorld
        default:
            return
        }
        
        let request = International.CallAtPhone.Request(assistancePhone: assistancePhone!)
        self.interactor?.doCallAtPhone(request: request)
    }
}
