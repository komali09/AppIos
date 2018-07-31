//
//  LocationDetailBenefits.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/23/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit

protocol LocationDetailBenefitsViewControllerDelegate : class {
    func didUpdateContentSize(viewController: UIViewController, contentSize: CGSize)
}

class LocationDetailBenefitsViewController: UIViewController {
    var interactor: LocationDetailBusinessLogic?
    private let ContentSizeName = "contentSize"
    @IBOutlet weak var benefitServices: UITableView!
    @IBOutlet weak var indicatorBenefits: UIActivityIndicatorView!
    weak var delegate : LocationDetailBenefitsViewControllerDelegate?
    
    var heigthTableView : Int?
    
    var backController: LocationDetailViewController?
    
    var listBenefit: [BenefitService]? {
        didSet {
            benefitServices.reloadData()
        }
    }
    
    var errorView:IAErrorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        benefitServices.estimatedRowHeight = 90
        benefitServices.rowHeight = UITableViewAutomaticDimension
        benefitServices.sectionHeaderHeight = 100
        setupErrorView()
        self.interactor?.getBenefits()
        self.heigthTableView = 0
        self.benefitServices?.addObserver(self, forKeyPath: ContentSizeName, options: .new, context: nil)
    }
    
    
    func setupErrorView() {
        errorView = IAErrorView(frame: self.view.bounds)
        errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        errorView.isHidden = true
        self.view.addSubview(errorView)
        
    }
    
    func displayBenefits(arrayBenefit: [BenefitService]){
        self.errorView.hide()
        self.listBenefit = arrayBenefit
        self.indicatorBenefits.stopAnimating()
        self.benefitServices.reloadData()
        self.benefitServices.layoutIfNeeded()
    }
    
    func displayOnscreenError(type: IAErrorAlertType) {
        switch type {
        case .noInternet:
            errorView?.show(type: .noInternet, message: LocalizableKeys.General.noInternet, actionMessage: LocalizableKeys.General.AlertOptions.reintentar, action: {
                self.interactor?.getBenefits()
            })
        case .noLocationsResults:
            errorView?.show(type: .noLocationsResults, message: LocalizableKeys.Directory.Map.benefitsError )
        default:
            errorView?.show(type: .noSearchResults, message: LocalizableKeys.General.serviceError)
        }
        
    }
    
    func checkTypeIcon (id: String) -> String {
        switch id {
        case "1","2":
            return "benefit8"
        case "3":
            return "benefit7"
        case "4","5":
            return "benefit15"
        case "6","7":
            return "benefit10"
        case "8":
            return "benefit9"
        case "9":
            return "benefit12"
        case "10":
            return "benefit14"
        case "11":
            return "benefit2"
        case "12":
            return "benefit17"
        case "13":
            return "benefit1"
        case "14":
            return "benefit3"
        case "15":
            return "benefit11"
        case "16":
            return "benefit5"
        case "17":
            return "benefit4"
        case "18":
            return "benefit16"
        case "19","20":
            return "benefit6"
        case "21":
            return "benefit13"
        default:
            return "benefit18"
        }
    }
    deinit {
        self.benefitServices?.removeObserver(self, forKeyPath: ContentSizeName)
        debugPrint("deinit LocationDetailBenefitsViewController")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == ContentSizeName else { return }
        guard let contentSize = change?[.newKey] as? CGSize else { return }
      
        self.delegate?.didUpdateContentSize(viewController: self, contentSize: contentSize)
    }
}

extension LocationDetailBenefitsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBenefit?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Benefit", for: indexPath) as! BenefitDetailTableViewCell
        
        let typeIcon = self.checkTypeIcon(id: (listBenefit?[indexPath.row].icon)!)
        cell.icon.image = UIImage(named: ("\(typeIcon)"))
        cell.benefit.text = listBenefit?[indexPath.row].benefit
        
        if listBenefit?[indexPath.row].clause != nil {
            cell.clause.text = listBenefit?[indexPath.row].clause
            cell.clause.alpha = 1
            cell.triangle.alpha = 1
        } else {
            cell.clause.text = ""
            cell.clause.alpha = 0
            cell.triangle.alpha = 0
        }
        
        return cell
    }
    
}

extension LocationDetailBenefitsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "Header")
        return header
    }
    
}
