//
//  TermsAndConditionsViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 28/02/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    
    @IBOutlet weak var termsAndConditions: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupView () {
        self.termsAndConditions.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
}
