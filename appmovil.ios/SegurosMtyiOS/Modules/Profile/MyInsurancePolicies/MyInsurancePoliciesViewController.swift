//
//  MyInsurancePoliciesViewController.swift
//  SegurosMtyiOS
//
//  Created by Israel Gutiérrez Castillo on 19/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import UIKit

class MyInsurancePoliciesViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak private var errorView: IAErrorView!
    @IBOutlet weak var optionsButton: IAGradientButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
    let kCellReuseIdentifier: String = "InsuranceViewCell"
    var insurancePolicies: [InsurancePolicy]? {
        get {
            return self.router?.dataStore?.insurancePolicies
        }
    }
    
    // MARK: View lifecycle
    @IBAction func optionsButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController.init(title: nil, message: "Opciones", preferredStyle: .actionSheet)
        let addPolicyAction = UIAlertAction.init(title: "Agregar nueva póliza", style: .default) { (alert) in
            self.router?.goToAddPolicy()
        }
        
        let cancelAction = UIAlertAction.init(title: LocalizableKeys.General.AlertOptions.cancel, style: .destructive, handler: nil)
        actionSheet.addAction(addPolicyAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.interactor?.getInsurancePoliciesData()
    }
    
    private func setupUI() {
        optionsButton.isHidden = true
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        errorView.hide()
        setupMainTableView()
        mainTableView.isHidden = true
    }
    
    private func setupMainTableView() {
        mainTableView.isHidden = false
        mainTableView.separatorStyle = .none
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
    
    func displayError(of type: IAErrorAlertType) {
        activityIndicator.stopAnimating()
        optionsButton.isHidden = true
        mainTableView.isHidden = true
        
        var alertType: IAErrorAlertType = .noSearchResults
        var message: String = ""
        var titleButton = "Reintentar"
        switch type {
        case .noInternet:
            alertType = .noInternet
            message = LocalizableKeys.General.noInternet
        default:
            alertType = .noSearchResults
            message = LocalizableKeys.Profile.noPolicies
            
            if type == .noRegisters {
                titleButton = "Agregar nueva póliza"
            }
        }
        
        errorView.show(type: alertType, message: message, actionMessage: titleButton) {
            self.activityIndicator.startAnimating()
            self.errorView.hide()
            self.mainTableView.isHidden = true
            
            if type == .noRegisters {
                self.router?.goToAddPolicy()
            } else {
                self.interactor?.getInsurancePoliciesData()
            }
        }
    }
    
    func reloadData() {
        if let insurancePolicies = insurancePolicies,
            insurancePolicies.count > 0 {
            mainTableView?.reloadData()
            activityIndicator.stopAnimating()
            optionsButton.isHidden = false
            mainTableView.isHidden = false
            errorView?.hide()
        } else {
            activityIndicator.stopAnimating()
            self.displayError(of: .noSearchResults)
        }
    }
    
}

extension MyInsurancePoliciesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.insurancePolicies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath)
        guard let cell:InsurancePolicyViewCell = _cell as? InsurancePolicyViewCell,
            let item = self.insurancePolicies?[indexPath.row]
            else { return _cell }
        
        cell.adaptAppearance(item)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MyInsurancePoliciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let item = self.insurancePolicies?[indexPath.row] else { return }
        self.router?.routeToPolicyDetail(item)
    }
}
