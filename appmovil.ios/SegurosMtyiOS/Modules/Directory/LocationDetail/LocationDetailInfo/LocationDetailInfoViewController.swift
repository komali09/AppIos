//
//  LocationDetailInfoViewController.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 1/4/18.
//  Copyright © 2018 IA Interactive. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class LocationDetailInfoViewController: UIViewController {
    var interactor: LocationDetailBusinessLogic?
    weak var delegate : LocationDetailBenefitsViewControllerDelegate?
    private var height: CGFloat = 0.0
    
    @IBOutlet weak var infoContainer: UIView!
    @IBOutlet weak var phoneView: UIView?
    @IBOutlet weak var locationPhone: UILabel?
    @IBOutlet weak var addressView: UIView?
    @IBOutlet weak var locationAddress: UILabel?
    @IBOutlet weak var websiteView: UIView?
    @IBOutlet weak var locationWebsite: UILabel?
    @IBOutlet weak var policyView: UIView?
    @IBOutlet weak var policyList: UILabel?
    @IBOutlet weak var policyMessage: UILabel?
    @IBOutlet weak var mapSuperView: UIView?
    @IBOutlet weak var mapView: GMSMapView?
    @IBOutlet weak var errorView: IAErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView?.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let size = CGSize(width: view.frame.width, height: self.height)
        self.delegate?.didUpdateContentSize(viewController: self, contentSize: size)
    }
    
    func displayBasicLocationData(viewModel: LocationDetail.LoadDetail.ViewModel) {
        policyView?.isHidden = false
        mapSuperView?.isHidden = false
        
        if let phone = viewModel.phone {
            self.locationPhone?.text = phone
        } else {
            self.phoneView?.removeFromSuperview()
        }
        if let website = viewModel.website {
            self.locationWebsite?.text = website
        } else {
            self.websiteView?.removeFromSuperview()
        }
        if let address = viewModel.address {
            self.locationAddress?.text = address
        } else {
            self.addressView?.removeFromSuperview()
        }
        
        if viewModel.isPolicyHidden {
            policyView?.removeFromSuperview()
        } else {
            self.policyList?.text = viewModel.policyList
            self.policyMessage?.text = viewModel.policyMessage
        }
        
        if let marker = viewModel.marker {
            marker.map = self.mapView
            self.setupMapLocation(marker.position)
        } else {
            mapSuperView?.removeFromSuperview()
        }
        updateHeight()
    }
    
    func displayLocationData(viewModel: LocationDetail.LoadDetail.ViewModel) {
        displayBasicLocationData(viewModel: viewModel)
        self.errorView?.removeFromSuperview()
        
        updateHeight()
    }
    
    func setupMapLocation(_ location:CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: 15)
        
        self.mapView?.camera = camera
    }
    
    func updateHeight() {
        view.layoutSubviews()
        guard let container = self.infoContainer else { return }
        self.height = container.frame.maxY
        let size = CGSize(width: container.frame.width, height: self.height)
        self.delegate?.didUpdateContentSize(viewController: self, contentSize: size)
    }
    
    func displayOnscreenError(type: IAErrorAlertType) {
        policyView?.isHidden = true
        mapSuperView?.isHidden = true
        
        switch type {
        case .noInternet:
            errorView?.show(type: .noInternet, message: LocalizableKeys.General.noInternet, actionMessage: "Reintentar") {
                IALoader.shared.show(LocalizableKeys.Loader.getLocations)
                self.interactor?.loadLocationData()
            }
        default:
            errorView?.show(type: .noSearchResults, message: LocalizableKeys.General.serviceError)
        }
        
    }
    
    @IBAction func instructionsPressed(_ sender: Any) {
        self.interactor?.openInstructions()
    }
}
