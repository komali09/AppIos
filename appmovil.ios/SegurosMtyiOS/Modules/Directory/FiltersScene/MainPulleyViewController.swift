//
//  MainPulleyViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit
import Pulley

class MainPulleyViewController: PulleyViewController {
    var interactor: FiltersBusinessLogic?
    var router: (NSObjectProtocol & FiltersRoutingLogic & FiltersDataPassing)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required init(contentViewController: UIViewController, drawerViewController: UIViewController) {
        super.init(contentViewController: contentViewController, drawerViewController: drawerViewController)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = FiltersInteractor()
        let router = FiltersRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideSelectionOptionsTableView()
        IALoader.shared.hide()
    }
    
    func showSelectionOptionsTableView(specialitiesSelected: [Specialty]?, show : Bool) {
        if let drawer = self.drawerContentViewController as? SelectionPulleyViewController {
            drawer.loadData(by: .specialities)
            drawer.specialitiesSelected = specialitiesSelected ?? []
            drawer.closeButton.isHidden = show
        }
        
        setDrawerPosition(position: .open, animated: true)
    }
    
    func showSelectionOptionsTableView(selectedState: State?, show : Bool) {
        if let drawer = self.drawerContentViewController as? SelectionPulleyViewController {
            drawer.loadData(by: .states)
            drawer.selectedState = selectedState
            drawer.closeButton.isHidden = show
        }
        
        setDrawerPosition(position: .open, animated: true)
    }
    
    func hideSelectionOptionsTableView() {
        setDrawerPosition(position: .closed, animated: true)
    }
    
    func addFiltersFromSelectionPulley(type: typeSelectionFilters, state: State?, specialities: [Specialty]?) {
        
        if let primary = self.primaryContentViewController as? FiltersViewController {
            switch type {
            case .states:
                primary.addStateFilter(state: state!)
            default:
                primary.addSpecialitiesFilter(specialities: specialities!)
            }
        }
        
        self.hideSelectionOptionsTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FiltersViewController {
            self.router?.routeToFilters(destinationVC: destination)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
