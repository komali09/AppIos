//
//  PolicyDetailInfoViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/9/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit
import Reachability

class PolicyDetailInfoViewController: UIViewController, PolicyDetailVipLogic {
    @IBOutlet private weak var collectionView: UICollectionView?
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var errorFooter: IAErrorView?
    @IBOutlet weak var successFooter: UIView?
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableHeaderLabel: UILabel!
    
    private let ContentSizeName = "contentSize"
    
    var interactor: PolicyDetailBusinessLogic?
    var router: (NSObjectProtocol & PolicyDetailRoutingLogic & PolicyDetailDataPassing)?
    
    var items:[PolicyDetailInfoDataItem?] = []
    var copaymentParticipationItems: [PolicyCopaymentParticipationData] = []
    var policy:InsurancePolicy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.collectionView?.addObserver(self, forKeyPath: ContentSizeName, options: .new, context: nil)
        self.tableView?.addObserver(self, forKeyPath: ContentSizeName, options: .new, context: nil)
    }
    
    private func setupUI() {
        guard ReachabilityManager.shared.isOnline else {
            return (self.successFooter?.isHidden = true)!
        }
    }
    
    func reloadCollectionData(items:[PolicyDetailInfoDataItem?]) {
        self.items = items
        collectionView?.reloadData()
    }
    
    func reloadData(viewModel: PolicyDetail.loadRemotePolicyDetail.ViewModel) {
        errorFooter?.removeFromSuperview()
        successFooter?.isHidden = false
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        reloadCollectionData(items:viewModel.items)
        copaymentParticipationItems = viewModel.copaymentParticipationItems ?? []
        tableHeaderLabel.isHidden = policy?.cardId != .alfaMedicalFlexA
        tableView?.reloadData()
    }
    
    func displayError(message:String) {
        successFooter?.isHidden = true
        collectionView?.reloadData()
        tableView?.reloadData()
        
        if let _ = scrollView {
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.errorFooter?.show(type: .noInternet, message: message, actionMessage: "Reintentar") {
                IALoader.shared.show(LocalizableKeys.Loader.getInfoPolicy)
                self.interactor?.loadPolicyData()
            }
        }
    }
    @IBAction func optionsPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LocalizableKeys.Profile.PolicyDetail.viewWallet, style: .default, handler: { action in
            IALoader.shared.show(LocalizableKeys.Loader.searchInsured)
            self.interactor?.loadBeneficiariesDataToWallet()
        }))
        
//        if self.router?.dataStore?.policy?.planForm == .collective {
//            alert.addAction(UIAlertAction(title: LocalizableKeys.Profile.PolicyDetail.showCertificate, style: .default, handler: { action in
//                self.router?.routerToCertificate()
//            }))
//        }
        
        if !(self.router?.dataStore?.policy?.isMainPolicy ?? false) {
            alert.addAction(UIAlertAction(title: LocalizableKeys.Profile.PolicyDetail.setAsPrincipal, style: .default, handler: { action in
                IALoader.shared.show(LocalizableKeys.Loader.setPrincipalPolicy)
                self.interactor?.setPrincipalPolicy()
            }))
        }
       
        alert.addAction(UIAlertAction(title: LocalizableKeys.General.AlertOptions.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit{
        self.collectionView?.removeObserver(self, forKeyPath: ContentSizeName)
        self.tableView?.removeObserver(self, forKeyPath: ContentSizeName)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == ContentSizeName else { return }
        guard let view = object as? UIView else { return }
        guard let constraint = view.getConstraint(identifier: "height") else { return }
        guard let contentSize = change?[.newKey] as? CGSize else { return }
        
        constraint.constant =  contentSize.height
    }
}

extension PolicyDetailInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = _cell as? PolicyDetailInfoViewCell else { return _cell}
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        switch kind {
        case UICollectionElementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        case UICollectionElementKindSectionHeader:
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            guard let headerView = view as? PolicyDetailInfoHeaderView else { return view }
            headerView.setup(item: policy)
            return headerView
        default:
            break
        }
        return view
    }
}

extension PolicyDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenRect = self.view.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 2.0
        let cellHeight:CGFloat = 62
        let size = CGSize(width: cellWidth, height: cellHeight)
        
        return size
    }
}

extension PolicyDetailInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return copaymentParticipationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        guard let cell = _cell as? CopaymentParticipationViewCell else { return _cell! }
        cell.setup(item: copaymentParticipationItems[indexPath.row])
        return cell
    }
}

extension PolicyDetailInfoViewController: UITableViewDelegate {
    
}

