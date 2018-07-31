//
//  PolicyDetailCoveragesViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 24/01/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import UIKit

class PolicyDetailCoveragesViewController: UIViewController {
    
    @IBOutlet weak var collectionViewCoverages: UICollectionView!
    @IBOutlet weak var errorView: IAErrorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorScrollView: UIScrollView!
    
    let cellIdentifier = "policysCoverageCollectionViewCell"
    let sectionCellIdentifier = "sectionHeaderCoveragesCollectionReusableView"
    let footerSectionCellIdentifier = "sectionFooterCoveragesCollectionReusableView"
    
    var interactor: PolicyDetailBusinessLogic?
    
    var dictionaryCoverages = [String : [Coverage]]()
    
    var titlesWaitingPeriods: [String]? {
        didSet {
            self.collectionViewCoverages.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.color = UIColor.gray
        setupCollectionView()
        interactor?.loadCoveragesData()
    }
    
    @IBAction func webAddressButtonPressed(_ sender: Any) {
        self.interactor?.loadWebPage()
    }
    
    func reloadCollectionView(with coverages: [Coverage]) {
        
        self.activityIndicator.stopAnimating()
        let coveragesIndividual = coverages.filter { (coverage) -> Bool in
            return coverage.waitingPeriod != nil
        }
        
        /**
         Si todas las coberturas tienen el valor de waitingPeriod diferente de nil significa que son de una póliza individual y se agrupan por este campo.
         Sino son de una póliza colectiva y sólo esta una agrupación
         */
        if coveragesIndividual.count > 0 {
            dictionaryCoverages = Dictionary.init(grouping: coverages, by: { $0.waitingPeriod! })
        } else {
            dictionaryCoverages[" "] = coverages
        }
        
        titlesWaitingPeriods = Array(dictionaryCoverages.keys).sorted(by: <)
    }
    
    private func setupCollectionView() {
        let flowLayout = TopAlignedCollectionViewFlowLayout.init()
        flowLayout.estimatedItemSize = CGSize(width: 105, height: 160)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 0.0
        self.collectionViewCoverages.collectionViewLayout = flowLayout
        self.collectionViewCoverages.semanticContentAttribute = .forceLeftToRight
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.collectionViewCoverages.delegate = self
        self.collectionViewCoverages.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        self.collectionViewCoverages.collectionViewLayout.invalidateLayout()
    }
    
    func displayError(type: IAErrorAlertType, message: String) {
        if self.errorView.lottieLogo == nil {
            self.errorScrollView.contentOffset.y = -self.view.frame.size.height * 0.1
            errorView.frame = self.view.frame
            errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            errorView.layoutIfNeeded()
        }
        
        self.collectionViewCoverages.isHidden = true
        self.activityIndicator.stopAnimating()
      
        switch type {
        case .noInternet:
            self.errorView?.show(type: type, message: message, actionMessage: "Reintentar") {
                self.interactor?.loadCoveragesData()
            }
        default:
            self.errorView?.show(type: type, message: message)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UICollectionView delegate
extension PolicyDetailCoveragesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.titlesWaitingPeriods?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let titles = self.titlesWaitingPeriods {
            return self.dictionaryCoverages[titles[section]]!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PolicysCoverageCollectionViewCell
        
        cell.configureCell(coverage: self.dictionaryCoverages[self.titlesWaitingPeriods![indexPath.section]]![indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
          return CGSize(width:collectionView.frame.size.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == collectionView.numberOfSections - 1 {
            return CGSize(width:collectionView.frame.size.width, height: 160.0)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionCellIdentifier, for: indexPath) as! SectionHeaderCoveragesCollectionReusableView
            
            sectionHeader.titleSection.text = self.titlesWaitingPeriods?[indexPath.section] ?? ""
            
            return sectionHeader
        
        case UICollectionElementKindSectionFooter:
            
            let footerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerSectionCellIdentifier, for: indexPath)
            
            return footerSection
            
        default:
            debugPrint("Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let space = ( collectionViewCoverages.frame.width - 315 ) / 6
        return UIEdgeInsets(top: 1, left: space, bottom: 1, right: space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let titles = self.titlesWaitingPeriods {
            if self.dictionaryCoverages[titles[indexPath.section]]!.count > 1 {
                return CGSize.init(width: collectionView.cellForItem(at: indexPath)?.frame.size.width ?? 105.0, height: collectionView.cellForItem(at: indexPath)?.frame.size.height ?? 160.0)
            } else {
                return CGSize.init(width: collectionView.cellForItem(at: indexPath)?.frame.size.width ?? 105.0, height: collectionView.cellForItem(at: indexPath)?.frame.size.height ?? 140.0)
            }
        } else {
             return CGSize(width: 105, height: 160)
        }
        
        
    }
    
}

