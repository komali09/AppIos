//
//  DirectoryMapPresenter.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/14/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import GoogleMaps

protocol DirectoryMapPresentationLogic {
    func presentUpdatedLocations(response: DirectoryMap.Locations.Response)
    func presentErrorMessage(ofType: IAErrorAlertType)
    func presentMapBounds(_ bounds: GMSCoordinateBounds)
}

class DirectoryMapPresenter: DirectoryMapPresentationLogic {
    weak var viewController: (DirectoryMapDisplayLogic & DirectoryErrorDisplayLogic)?
    
    // MARK: Do something
    
    func presentUpdatedLocations(response: DirectoryMap.Locations.Response) {
        
        var markers:[GMSMarker] = []
        for item in response.locations {
            guard let coordinates = item.coordinates else { continue }
            
            let marker = GMSMarker(position: coordinates)
            marker.userData = item
            marker.appearAnimation = .pop
            
            let iconColorName = response.isPlanIncluded ? "AzulPin" : "BlancoPin"
            var iconName = ""
            
            switch item.type {
            case .nursing:
                iconName = "enfermeria\(iconColorName)"
            case .pharmacy:
                iconName = "farmacia\(iconColorName)"
            case .hospital:
                iconName = "hospital\(iconColorName)"
            case .laboratory:
                iconName = "laboratorio\(iconColorName)"
            case .medic:
                iconName = "doctor\(iconColorName)"
            case .optics:
                iconName = "optica\(iconColorName)"
            case .rehabilitation:
                iconName = "rehabilitacion\(iconColorName)"
            default:
                iconName = "otros\(iconColorName)"
            }
            marker.icon = UIImage(named: iconName)
            markers.append(marker)
        }
        let viewModel = DirectoryMap.Locations.ViewModel(markers: markers)
        self.viewController?.displayUpdatedLocations(viewModel: viewModel)
        
    }
    
    func presentErrorMessage(ofType: IAErrorAlertType) {
        self.viewController?.displayError(ofType: ofType)
    }
    
    func presentMapBounds(_ bounds: GMSCoordinateBounds) {
        self.viewController?.displayMapLocation(bounds)
    }
}
