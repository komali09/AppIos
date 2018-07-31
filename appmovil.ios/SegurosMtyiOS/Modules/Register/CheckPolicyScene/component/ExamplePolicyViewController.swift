//
//  NumPolicyViewController.swift
//  SegurosMtyiOS
//
//  Created by Claudia Mariana Parente Ramos on 17/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class ExamplePolicyViewController: IAPopupViewController {
    
    var type : PolicyType = .individual
    
    @IBOutlet weak var textInfo: UILabel!
    @IBOutlet weak var example: UIImageView!
    @IBOutlet weak var selectTypePolicy: UISegmentedControl!
    
    override func viewDidLoad() {
        super.show()
        super.viewDidLoad()
        self.setupSegment(type: type.rawValue)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func pressTypePolicyExample(_ sender: UISegmentedControl) {
        self.setupSegment(type: sender.selectedSegmentIndex)
    }
    
    
    @IBAction func claseView(_ sender: UIButton) {
        super.close(completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    private func setupSegment (type: Int) {
        switch type {
        case 0:
            selectTypePolicy.selectedSegmentIndex = type
            self.textInfo.text = "Aquí puedes encontrar el No. de póliza"
            self.example.image = UIImage(named: "policyIndividual")
        default:
            selectTypePolicy.selectedSegmentIndex = type
            self.textInfo.text = "Aquí puedes encontrar el No. de póliza y No. de certificado"
            self.example.image = UIImage(named: "policyCollective")
        }
    }
    
}
