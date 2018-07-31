//
//  WelcomeViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 01/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var version: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTranslucentNavigationBar()
        self.setCustomBackButton()
        LocationManager.shared.updateLocation()
        
        #if !PROD
        self.version.text = Util.getAppVersion()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
