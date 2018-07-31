//
//  PolicyDetailBeneficiariesViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/17/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailBeneficiariesViewController: UIViewController, PolicyDetailVipLogic {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorFooter: IAErrorView?
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var interactor: PolicyDetailBusinessLogic?
    var router: (NSObjectProtocol & PolicyDetailRoutingLogic & PolicyDetailDataPassing)?
    
    var items:[BeneficiarieDataItem?] = []
    var policy:InsurancePolicy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = UIColor.gray
        interactor?.loadBeneficiariesData()
    }
    
    func reloadData(items:[BeneficiarieDataItem?]) {
        self.activityIndicator.stopAnimating()
        self.items = items
        self.tableView.reloadData()
        self.errorFooter?.hide()
        self.tableView.isHidden = false
    }
    
    func displayError(type: IAErrorAlertType, message: String) {
        self.activityIndicator.stopAnimating()
        self.tableView.isHidden = true
        switch type {
        case .noInternet:
            self.errorFooter?.show(type: type, message: message, actionMessage: "Reintentar") {
                self.interactor?.loadBeneficiariesData()
            }
        default:
            self.errorFooter?.show(type: type, message: message)
        }
    }
}

extension PolicyDetailBeneficiariesViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        guard let cell = _cell as? PolicyDetailBeneficiariesViewCell else { return _cell! }
        cell.setup(item: items[indexPath.row])
        cell.backgroundColor =  indexPath.row % 2 == 0 ? UIColor.white : UIColor.smBlue.withAlphaComponent(0.1)
        return cell
    }
}
