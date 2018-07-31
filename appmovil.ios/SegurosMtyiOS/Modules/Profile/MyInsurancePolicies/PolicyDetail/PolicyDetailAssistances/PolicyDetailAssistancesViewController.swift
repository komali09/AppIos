//
//  PolicyDetailAssistancesViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/23/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailAssistancesViewController: UIViewController, PolicyDetailVipLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: PolicyDetailBusinessLogic?
    var router: (NSObjectProtocol & PolicyDetailRoutingLogic & PolicyDetailDataPassing)?
    
    var items:[AssistanceType] = [.travel, .medic, .nutrition, .psychology, .legal, .funerary]
    var policy:InsurancePolicy?
    
    var imageExpandAnimationController: ImageExpandAnimationController?
    var imageShrinkAnimationController: ImageShrinkAnimationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PolicyDetailAssistancesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        guard let cell = _cell as? PolicyDetailAssistancesViewCell else { return _cell! }
        cell.setup(items[indexPath.row])
        return cell
    }
}

extension PolicyDetailAssistancesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PolicyDetailAssistancesViewCell else { return }
        guard let parentView = self.parent?.view else { return }
        let frame = cell.convert(cell.containerFrame, to: parentView)
        imageExpandAnimationController?.originFrame = frame
        imageShrinkAnimationController?.destinationFrame = frame
        
        self.router?.routeToAssistanceDetail(assistenceType: items[indexPath.row])
    }
}
