//
//  LocationsTablePresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Jonnatan Perez Téllez on 15/12/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import CoreLocation

protocol LocationsTablePresentationLogic {
    func presentUpdatedLocations(response: LocationsTable.Locations.Response)
    func presentErrorMessage(ofType: IAErrorAlertType)
    func presentFavorite(response: IndexPath)
}

class LocationsTablePresenter: LocationsTablePresentationLogic {
    weak var viewController: (LocationsTableDisplayLogic & DirectoryErrorDisplayLogic & ErrorDisplayLogic & ExpiredSessionDisplayLogic)?
    
    // MARK: Do something
    
    func presentUpdatedLocations(response: LocationsTable.Locations.Response) {
        var viewModel:[LocationsTable.Locations.ViewModel] = []
        for item in response.locations {
            
            var distanceString = ""
            if let userLocation = LocationManager.shared.location, let coordinates = item.coordinates {
                let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                let distance = (userLocation.distance(from: location) / 10.0).rounded()
                distanceString = "a \(distance / 100.0) km"
            }
            let phone = item.phone.replacingOccurrences(of: "-", with: " ")
            let isFavorite:Bool = item.isFavorite ?? false
            var image = ""
            switch item.type {
            case .nursing:
                image = "enfermeriaSmall"
            case .pharmacy:
                image = "farmaciaSmall"
            case .hospital:
                image = "hospitalSmall"
            case .laboratory:
                image = "laboratorioSmall"
            case .medic:
                image = "medicoSmall"
            case .optics:
                image = "opticaSmall"
            case .rehabilitation:
                image = "rehabilitacionSmall"
            default:
                image = "otrosSmall"
            }
            let vmItem = LocationsTable.Locations.ViewModel(name: item.name.capitalized,
                                                            image: image,
                                                            address: item.address?.capitalized ?? LocalizableKeys.General.noInformation,
                                                            phone: phone,
                                                            isFavorite: isFavorite,
                                                            distanceString: distanceString)
            viewModel.append(vmItem)
        }
        self.viewController?.displayUpdatedLocations(viewModel: viewModel)
        
    }
    
    func presentErrorMessage(ofType: IAErrorAlertType) {
        self.viewController?.displayError(ofType: ofType)
    }
    
    func presentFavorite(response: IndexPath) {
        viewController?.displayFavorite(viewModel: response)
    }
}

extension LocationsTablePresenter : ErrorPresentationLogic {
    func presentError(_ error:Error) {
        var message = ""
        switch error {
        case NetworkingError.noInternet:
            message = LocalizableKeys.General.noInternet
        default:
            message = LocalizableKeys.General.serviceError
        }
        
        self.viewController?.displayError(with: message)
    }
}

extension LocationsTablePresenter : ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        self.viewController?.displayExpiredSession()
    }
}
