//
//  LocationManager.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/11/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

enum LocationManagerError : Error {
    case noPermission
    case locationFailed
}

class LocationManager : NSObject {
    private var manager : CLLocationManager
    private var didUpdateLocation:Bool
    static var shared = LocationManager()
    let geocoder = CLGeocoder()
    
    private var reverseGeocodeLocationHandler:((State, Error?) -> ())?
    
    var location:CLLocation? {
        didSet {
            guard let location = self.location else { return }
            UserDefaultsManager.shared.userLocatinLatitude = "\(location.coordinate.latitude)"
            UserDefaultsManager.shared.userLocatinLongitude = "\(location.coordinate.longitude)"
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let stateInitials = placemarks?.first?.administrativeArea {
                    if let stateCode = StateCode(rawValue: stateInitials.replacingOccurrences(of: ".", with: "").lowercased()) {
                        let state = State(state: stateCode)
                        debugPrint("State found: \(state)")
                        self.reverseGeocodeLocationHandler?(state, nil)
                    } else {
                        let state = State(state: .cdmx)
                        self.reverseGeocodeLocationHandler?(state, LocationManagerError.locationFailed)
                    }
                } else {
                    let state = State(state: .cdmx)
                    self.reverseGeocodeLocationHandler?(state, LocationManagerError.locationFailed)
                }
            })
        }
    }
    
    override init() {
        self.manager = CLLocationManager()
        self.didUpdateLocation = false
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if let latitude = Double(UserDefaultsManager.shared.userLocatinLatitude),
            let longitude = Double(UserDefaultsManager.shared.userLocatinLongitude) {
            self.location = CLLocation(latitude: latitude, longitude: longitude)
            
        }
    }
    
    func updateLocation() {
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        if locationServicesEnabled() {
            self.didUpdateLocation = false
            self.manager.startUpdatingLocation()
        } else {
            let state = State(state: .cdmx)
            self.reverseGeocodeLocationHandler?(state, LocationManagerError.noPermission)
        }
    }
    
    
    private func locationServicesEnabled() -> Bool  {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
    
    func getState() -> Observable<State> {
        return Observable.create({ (observable) in
            self.getState({ (state, error) in
                if let error = error {
                    observable.onError(error)
                } else {
                    observable.onNext(state)
                }
            })
            return Disposables.create()
        })
    }
    
    private func getState(_ completion:@escaping (State, Error?) -> ()) {
        self.reverseGeocodeLocationHandler = completion
        updateLocation()
    }
    
    
    func getLocation(for address: String) -> Observable<CLLocation> {
        return Observable.create({ (observable) in
            debugPrint("getting Location for address: \(address.capitalized)")
            self.geocoder.geocodeAddressString(address.capitalized, completionHandler: { (placeMark, error) in
                if let error = error {
                    debugPrint("❌ getting Location for address error: \(error.localizedDescription)")
                    observable.onError(error)
                } else if let location = placeMark?.first?.location {
                    observable.onNext(location)
                } else {
                    observable.onError(LocationManagerError.locationFailed)
                }
            })
            return Disposables.create()
        })
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.didUpdateLocation { return }
        self.didUpdateLocation = true
        
        self.location = locations.first
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let state = State(state: .cdmx)
        self.reverseGeocodeLocationHandler?(state, LocationManagerError.locationFailed)
        self.manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.updateLocation()
    }
}

