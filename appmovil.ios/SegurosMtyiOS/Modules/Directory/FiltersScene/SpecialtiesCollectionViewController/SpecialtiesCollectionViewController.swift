//
//  SpecialtiesCollectionViewController.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 19/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let collectionViewHeight = Notification.Name("CollectionViewHeight")
}

protocol SpecialtiesCollectionViewControllerDelegate : class {
    func setupCollection(_ selectedItems: [Specialty])
}

protocol SpecialtiesCollectionDisplayLogic: class {
    func displaySpecialties(viewModel: SpecialtiesCollection.GetSpecialties.ViewModel)
}

class SpecialtiesCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var interactor: SpecialtiesCollectionBusinessLogic?
    var router: (NSObjectProtocol & SpecialtiesCollectionRoutingLogic & SpecialtiesCollectionDataPassing)?

    private let cellIdentifier = "specialtyTagCell"
    private var specialtiesArray = [Specialty]()
    var items: [Specialty] {
        get {
            return specialtiesArray
        }
    }
    
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
        let interactor = SpecialtiesCollectionInteractor()
        let presenter = SpecialtiesCollectionPresenter()
        let router = SpecialtiesCollectionRouter()
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
        setupCollectionView()
    }
    
    func setupCollectionView(specialities: [Specialty]) {
        self.specialtiesArray = specialities
        updateCollectionView()
    }

    // MARK: - Actions
    @objc private func removeButtonPressed(sender: UIButton) {
        specialtiesArray.remove(at: sender.tag)
        updateCollectionView()
    }

    // MARK: - Private Methods
    private func setupCollectionView() {
        let nib = UINib(nibName: "SpecialtyTagCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.delegate = self
        collectionView?.isScrollEnabled = false
        let tagCellLayout = IACollectionAlignedLayout(alignmentType: .Left, delegate: self)
        collectionView?.collectionViewLayout = tagCellLayout
    }

    private func updateCollectionView() {
        collectionView?.isScrollEnabled = false
        collectionView?.reloadData()
        collectionView?.performBatchUpdates(nil, completion: { [weak self] finished in
            guard let strongSelf = self else { return }
            if finished {
                let specialitiesSelected:[String: [Specialty]] = ["specialities": (self?.specialtiesArray)!]
                
                NotificationCenter.default.post(name: .collectionViewHeight, object: strongSelf.specialtiesArray.count <= 0 ? CGFloat(0.00) : self?.collectionView!.contentSize.height, userInfo: specialitiesSelected)
            }
        })
    }
}

// MARK: - Display Logic Methods
extension SpecialtiesCollectionViewController: SpecialtiesCollectionDisplayLogic {
    func displaySpecialties(viewModel: SpecialtiesCollection.GetSpecialties.ViewModel) {
        specialtiesArray = viewModel.specialtiesArray
        updateCollectionView()
    }
}

// MARK: - UICollectionView delegate
extension SpecialtiesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialtiesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SpecialtyTagCell
        let item = specialtiesArray[indexPath.item]
        cell.nameLabel.text = item.name
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(removeButtonPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - SpecialtyTagLayout Delegate
extension SpecialtiesCollectionViewController: IACollectionAlignedLayoutDelegate {
    func alignedItemWidth(layout: IACollectionAlignedLayout, atIndex index: Int) -> CGFloat {
        let font = UIFont.AppFonts.Medium.ofSize(14.0)
        return specialtiesArray[index].name.widthOfString(usingFont: font) + 40.0
    }

    func alignedItemFixedHeight(layout: IACollectionAlignedLayout) -> CGFloat {
        return 40.0
    }
}
