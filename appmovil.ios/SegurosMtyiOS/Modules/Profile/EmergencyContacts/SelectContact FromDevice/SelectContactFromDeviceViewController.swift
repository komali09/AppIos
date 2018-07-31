//
//  SelectContactFromDeviceViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 22/01/18.
//  Copyright (c) 2018 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectContactFromDeviceDisplayLogic: class {
    func displayContacts(viewModel: SelectContactFromDevice.GetContacts.ViewModel)
    func displayGroupContactsByAlphabet(viewModel: SelectContactFromDevice.GroupContactsByAlphabet.ViewModel)
    func displayGroupContactsFilteredBySearchText(viewModel: SelectContactFromDevice.GroupContactsFilteredBySearchText.ViewModel)
    func displayErrorNoDataContact(viewModel:  SelectContactFromDevice.AddemergencyContact.ViewModel)
    func displayAddEmergencyContact()
}

class SelectContactFromDeviceViewController: UIViewController, ExpiredSessionDisplayLogic, ErrorDisplayLogic {
    var interactor: SelectContactFromDeviceBusinessLogic?
    var router: (NSObjectProtocol & SelectContactFromDeviceRoutingLogic & SelectContactFromDeviceDataPassing)?
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellSectionIdentifier = "letterTableViewCell"
    let cellIdentifier = "contactCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var alphabet: [String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var groupContacts: [String: [Contact]]?
    var groupContactsFiltered: [String : [Contact]]?
    
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
        let interactor = SelectContactFromDeviceInteractor()
        let presenter = SelectContactFromDevicePresenter()
        let router = SelectContactFromDeviceRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        interactor?.getContactsFromDevice()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        if #available(iOS 11.0, *) {
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Buscar"
            searchController.searchBar.delegate = self
            navigationItem.searchController = searchController
            definesPresentationContext = true
        } else {
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 65.0))
            searchBar.searchBarStyle = .minimal
            searchBar.placeholder = "Buscar"
            searchBar.backgroundColor = UIColor.smLightGray
            searchBar.delegate = self
            self.view.addSubview(searchBar)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
    private func showActionSheetToAddEmergencyContac(contact: Contact) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addSelectionEmergencyContactAction = UIAlertAction(title: "Agregar contacto", style: .default, handler: { [unowned self] _ in
            let request = SelectContactFromDevice.AddemergencyContact.Request(contact: contact)
            self.interactor?.addEmergencyContact(request: request)
        })
        actionSheet.addAction(addSelectionEmergencyContactAction)
     
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.router?.goToPerfilViewController()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        self.router?.goToAddManualEmergencyContact()
    }
}

/**
 Extensión para trabajar con el protocolo desde el presenter
 */
extension SelectContactFromDeviceViewController: SelectContactFromDeviceDisplayLogic {
    func displayContacts(viewModel: SelectContactFromDevice.GetContacts.ViewModel) {
        if viewModel.contacts.count == 0 {
            self.showAlert(with: nil, message: LocalizableKeys.EmergencyContacts.notGetContactsFromDevice, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: { (action) in
                self.router?.goToPerfilViewController()
            })
        } else {
            let request = SelectContactFromDevice.GroupContactsByAlphabet.Request(contacts: viewModel.contacts)
            self.interactor?.groupContactsByAlphabet(request: request)
        }
    }
    
    func displayGroupContactsByAlphabet(viewModel: SelectContactFromDevice.GroupContactsByAlphabet.ViewModel) {
        self.groupContacts = viewModel.groupContacts
        self.alphabet = Array(viewModel.groupContacts.keys).sorted()
    }
    
    func displayGroupContactsFilteredBySearchText(viewModel: SelectContactFromDevice.GroupContactsFilteredBySearchText.ViewModel) {
        self.groupContactsFiltered = viewModel.groupContacts
        self.alphabet = Array(viewModel.groupContacts.keys).sorted()
    }
    
    func displayErrorNoDataContact(viewModel: SelectContactFromDevice.AddemergencyContact.ViewModel) {
        self.showAlert(with: nil, message: viewModel.errorMessage, actionTitle: LocalizableKeys.General.AlertOptions.accept, action: nil)
    }
    
    func displayAddEmergencyContact() {
        IALoader.shared.hide()
       self.router?.goToPerfilViewControllerAndRefreshEmergencyContacts()
    }
}

/**
 Extensión para trabajar con los protocolos de UITableview
 */
extension SelectContactFromDeviceViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.alphabet?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.alphabet {
            if self.isFiltering() {
                return self.groupContactsFiltered![sections[section]]!.count
            } else  {
                return self.groupContacts![sections[section]]!.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: cellSectionIdentifier)
        guard let cell = cellDefault as? LetterTableViewCell else { return cellDefault }
        
        cell.configureCell(letter: self.alphabet![section])
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.alphabet
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cellDefault as? ContacTableViewCell else { return cellDefault }
        
        if self.isFiltering() {
            cell.configureCell(contact: self.groupContactsFiltered![self.alphabet![indexPath.section]]![indexPath.row])
        } else {
           cell.configureCell(contact: self.groupContacts![self.alphabet![indexPath.section]]![indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.resignFirstResponder()
        
        if self.isFiltering() {
            self.showActionSheetToAddEmergencyContac(contact: self.groupContactsFiltered![self.alphabet![indexPath.section]]![indexPath.row])
        } else {
           self.showActionSheetToAddEmergencyContac(contact: self.groupContacts![self.alphabet![indexPath.section]]![indexPath.row])
        }
    }
}

/**
 Extensión para los métodos del delegado de searchBar
 */
extension SelectContactFromDeviceViewController: UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let searchText = searchBar.text {
            if searchText == "" {
                interactor?.getContactsFromDevice()
            }
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            interactor?.getContactsFromDevice()
        } else {
            let request = SelectContactFromDevice.GroupContactsFilteredBySearchText.Request(searchText: searchText)
            interactor?.groupContactsfilteredBySearchText(request: request)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText == "" {
                interactor?.getContactsFromDevice()
            }
        }
    }
}
