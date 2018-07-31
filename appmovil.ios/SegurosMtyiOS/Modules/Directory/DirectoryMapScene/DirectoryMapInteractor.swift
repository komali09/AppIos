//
//  DirectoryMapInteractor.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/14/17.
//  Copyright (c) 2017 IA Interactive. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

protocol DirectoryMapBusinessLogic {
    func displayError(ofType type: IAErrorAlertType)
}

class DirectoryMapInteractor: DirectoryMapBusinessLogic, DirectoryDataStore {
    var presenter: DirectoryMapPresentationLogic?
    
    // MARK: DataStore
    var locations: [Location] = [] {
        didSet {
            self.updateLocations()
        }
    }
    var isPlanIncludedOnly: Bool = true
    
    func updateLocations() {
        let filteredLocations:[Location] = self.locations.filter { $0.coordinates != nil }
        if filteredLocations.count == 0 {
            self.displayError(ofType: .noLocationsResults)
        } else {
            let response = DirectoryMap.Locations.Response(isPlanIncluded: isPlanIncludedOnly,locations: filteredLocations)
            self.presenter?.presentUpdatedLocations(response: response)
            self.setMapRegion(with:  filteredLocations)
        }
    }
    
    func setMapRegion(with locations:[Location]) {
        let mapWorker = DirectoryMapWorker()
        guard let bounds = mapWorker.getMapRegion(locations: locations) else { return }
        self.presenter?.presentMapBounds(bounds)
    }
    
    func displayError(ofType type: IAErrorAlertType) {
        self.presenter?.presentErrorMessage(ofType: type)
    }
}
