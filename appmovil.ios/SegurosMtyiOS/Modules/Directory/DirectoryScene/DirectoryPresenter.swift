//
//  DirectoryPresenter.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 05/12/17.
//  Copyright (c) 2017 Erwin Jonnatan Perez Téllez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol ErrorPresentationLogic {
    func presentError(_ error:Error)
}

protocol ExpiredSessionPresentationLogic {
    func presentExpiredSession()
}

protocol DirectoryPresentationLogic {
    func presentLocations()
    func presentSearchSuggestion(_ suggestions: [String])
}

class DirectoryPresenter: DirectoryPresentationLogic {
    weak var viewController: (DirectoryDisplayLogic & DirectoryErrorDisplayLogic & ExpiredSessionDisplayLogic)?
    
    // MARK: Do something
    
    func presentLocations() {
        viewController?.displayLocations()
    }
    
    func presentSearchSuggestion(_ suggestions: [String]) {
        viewController?.displaySearchSuggestion(suggestions)
    }
}

extension DirectoryPresenter : ErrorPresentationLogic {
    func presentError(_ error:Error) {
        switch error {
        case NetworkingError.noInternet:
            self.viewController?.displayError(ofType: .noInternet)
        case LocationError.noResults:
            self.viewController?.displayError(ofType: .noLocationsResults)
        case LocationError.noSearchResults:
            self.viewController?.displayError(ofType: .noSearchResults)
        case LocationError.noFavoriteResults:
            self.viewController?.displayError(ofType: .noFavoritesResults)
        case NetworkingError.noSuccessStatusCode(let code, _):
            switch code {
            case 1:
                self.viewController?.displayError(ofType: .noLocationsResults)
            default:
                self.viewController?.displayError(ofType: .none)
            }
        case LocationManagerError.noPermission:
            self.viewController?.displayLocationPermissionMessage()
        case LocationManagerError.locationFailed:
            if ReachabilityManager.shared.isOnline {
                self.viewController?.displayStateList()
            } else {
                self.viewController?.displayError(ofType: .noInternet)
            }
        default:
            self.viewController?.displayError(ofType: .none)
        }
    }
}

extension DirectoryPresenter : ExpiredSessionPresentationLogic {
    func presentExpiredSession() {
        self.viewController?.displayExpiredSession()
    }
}
