//
//  ServicesCollectionViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

protocol ServicesCollectionViewControllerDelegate : class {
    func collectionChanged(_ collection:ServicesCollectionViewController, selectedItems: [ServiceType])
}

class ServicesCollectionViewController: UICollectionViewController {
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    private let cellIdentifier = "serviceCollectionViewCell"
    
    private var services:[ServiceType] = [.hospital, .pharmacy, .laboratory, .optics, .rehabilitation, .nursing, .other]
    var selectedServices: [ServiceType] = []
    weak var delegate: ServicesCollectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let alignedLayout = IACollectionAlignedLayout(alignmentType: .Center, delegate: self)
        collectionView?.collectionViewLayout = alignedLayout
        collectionView?.isScrollEnabled = false
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    func preloadCollectionView(with services:[ServiceType]) {
        selectedServices = services
        collectionView?.reloadData()
    }
}

// MARK: - UICollectionView delegate
/*
 Protocolo para definir el número de celdas en el collection
 */
extension ServicesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellDefault = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        guard let cell = cellDefault as? ServiceCollectionViewCell else { return cellDefault }
        
         let item = services[indexPath.row]
        cell.configureCell(service: item)
        if selectedServices.contains(item) {
            cell.select(animated: false)
        } else {
            cell.deselect(animated: false)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ServiceCollectionViewCell else { return }
        feedbackGenerator?.selectionChanged()
        feedbackGenerator?.prepare()
        
        let item = services[indexPath.row]
        
        if selectedServices.contains(item) {
            cell.deselect(animated: true)
            self.selectedServices = self.selectedServices.filter { $0 != item }
        } else  {
            cell.select(animated: true)
            self.selectedServices.append(item)
        }
        self.delegate?.collectionChanged(self, selectedItems: self.selectedServices)
    }
}

// MARK: - Aligned Layout Delegate
extension ServicesCollectionViewController: IACollectionAlignedLayoutDelegate {

    func alignedItemWidth(layout: IACollectionAlignedLayout, atIndex index: Int) -> CGFloat {
        return 110.0
    }

    func alignedItemFixedHeight(layout: IACollectionAlignedLayout) -> CGFloat {
        return 130.0
    }
}
