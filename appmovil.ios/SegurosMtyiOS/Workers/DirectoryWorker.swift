//
//  DirectoryWorker.swift
//  SegurosMtyiOS
//
//  Created by Erwin Perez Tellez on 05/12/17.
//  Copyright (c) 2017 Erwin Jonnatan Perez Téllez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RxSwift
import MapKit


enum LocationError : Error {
    case noResults
    case noFavoriteResults
    case noSearchResults
}

enum NavigationApps: String {
    
    case Maps = "Mapas"
    case GoogleMaps = "Google Maps"
    case Waze = "Waze"
    
}

class DirectoryWorker {
    /**
     Realiza la peticion al servicio para obtener las locaciones cercanas al usuario
     */
    func getLocations(isPlanIncluded: Bool, serviceTypes: [ServiceType], state:Int, doctorTypes: [Specialty], searchTerms:String?)-> Observable<[Location]> {
        var search: String?
        if let searchTerms = searchTerms, searchTerms.count > 0 {
            search = searchTerms
        }
        
        return Observable.create { observable in
            let disposable = ServiceManager.getLocations(isPlanIncluded: isPlanIncluded, serviceTypes: serviceTypes, state:state, doctorTypes: doctorTypes, searchTerms: search).subscribe { event in
                switch event {
                case .next(let result):
                    if result.count == 0 {
                        if search == nil {
                            observable.onError(LocationError.noResults)
                        } else {
                            observable.onError(LocationError.noSearchResults)
                        }
                    } else {
                        observable.onNext(result.sorted(by: ({ $0.name < $1.name })))
                    }
                case .error(let error):
                    switch error {
                    case NetworkingError.noSuccessStatusCode(let code, _):
                        if search != nil && code == 1 {
                            observable.onError(LocationError.noSearchResults)
                        } else {
                            observable.onError(error)
                        }
                    default:
                        observable.onError(error)
                    }
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la peticion al servicio para obtener las locaciones cercanas al usuario
     */
    func getFavoriteLocations(state:Int)-> Observable<[Location]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getFavoriteLocations(state:state).subscribe { event in
                switch event {
                case .next(let result):
                    if result.count == 0 {
                        observable.onError(LocationError.noFavoriteResults)
                    } else {
                        observable.onNext(result.sorted(by: ({ $0.name < $1.name })))
                    }
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la peticion al servicio para obtener las locaciones cercanas al usuario
     */
    func getLocationSearchSuggestions(searchTerms:String, state: Int)-> Observable<[String]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getLocationSearchSuggestions(searchTerms: searchTerms, state: state).subscribe { event in
                switch event {
                case .next(let result):
                    if result.count == 0 {
                        observable.onError(LocationError.noResults)
                    } else {
                        observable.onNext(result)
                    }
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    /**
     Realiza la peticion al servicio para obtener la información de un location especifico
     */
    func getLocationDetail(businessId: Int, providerId: String)-> Observable<Location> {
        return Observable.create { observable in
            let disposable = ServiceManager.getLocationDetail(businessId:businessId, providerId: providerId).flatMap(self.getLocationCoordinates).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
                    
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func getLocationCoordinates(location:Location) -> Observable<Location> {
        if location.coordinates != nil {
            return Observable.just(location)
        }
        guard let address = location.address else { return Observable.just(location)  }
        
        return Observable.create { observable in
            let disposable = LocationManager.shared.getLocation(for: address).take(1).subscribe { event in
                switch event {
                case .next(let result):
                    var newLocation = location
                    newLocation.setLocation(location: result)
                    observable.onNext(newLocation)
                case .error(_):
                    observable.onNext(location)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    
    func toogleLocationFavorite(location: Location?) -> Observable<Location> {
        guard var mutatingLocation = location else { return Observable.error(WorkerError.invalidInput) }
        
        return Observable.create { observable in
            var request: Observable<Bool>!
            if mutatingLocation.isFavorite ?? false {
                request = ServiceManager.removeLocationFromFavorites(businessId: mutatingLocation.businessId, providerId: mutatingLocation.providerId)
            } else {
                request = ServiceManager.addLocationToFavorites(businessId: mutatingLocation.businessId, providerId: mutatingLocation.providerId)
            }
            let disposable = request.subscribe { event in
                switch event {
                case .next(let result):
                    mutatingLocation.setFavorite(value: result)
                    observable.onNext(mutatingLocation)
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func getBenefits(providerId: String)-> Observable<[BenefitService]> {
        return Observable.create { observable in
            let disposable = ServiceManager.getBenefitsHospital(providerId: providerId).subscribe { event in
                switch event {
                case .next(let result):
                    observable.onNext(result)
                case .error(let error):
                    observable.onError(error)
                case .completed:
                    break
                }
            }
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    func getAllPossibleNavigationApps(_ placeName: String, coordinates: CLLocationCoordinate2D) -> LocationDetail.ShowNavigationApps.ViewModel {
        let alertController: UIAlertController = UIAlertController.init(title: "Cómo llegar", message: nil, preferredStyle: .actionSheet)
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            let googleMapsAction = UIAlertAction.init(title: NavigationApps.GoogleMaps.rawValue, style: .default, handler: { (alert) in
                let appUrl = "comgooglemaps://?saddr=&daddr=\(Double(coordinates.latitude)),\(Double(coordinates.longitude))&directionsmode=driving"
                UIApplication.shared.open(URL(string: appUrl)!, options: [:], completionHandler: nil)
            })
            alertController.addAction(googleMapsAction)
        }
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            let wazeAction = UIAlertAction.init(title: NavigationApps.Waze.rawValue, style: .default, handler: { (alert) in
                let appUrl = "waze://?ll=\(Double(coordinates.latitude)),\(Double(coordinates.longitude))&navigate=yes"
                UIApplication.shared.open(URL(string: appUrl)!, options: [:], completionHandler: nil)
            })
            alertController.addAction(wazeAction)
        }
        
        if alertController.actions.count > 0 {
            let mapsAction = UIAlertAction.init(title: NavigationApps.Maps.rawValue, style: .default) { (alert) in
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
                mapItem.name = placeName
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            }
            let cancelAction = UIAlertAction.init(title: LocalizableKeys.General.AlertOptions.cancel, style: .cancel, handler: nil)
            alertController.addAction(mapsAction)
            alertController.addAction(cancelAction)
            return LocationDetail.ShowNavigationApps.ViewModel(alertController: alertController, maps: nil)
        } else {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
            mapItem.name = placeName
            return LocationDetail.ShowNavigationApps.ViewModel(alertController: nil, maps: mapItem)
        }
    }
    
}
