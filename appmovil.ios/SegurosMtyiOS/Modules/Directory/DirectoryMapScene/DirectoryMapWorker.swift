//
//  DirectoryMapWorker.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/21/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import GoogleMaps

class DirectoryMapWorker {
    func getMapRegion(locations:[Location]) -> GMSCoordinateBounds? {
        let coordinates = locations.map({ $0.coordinates! })
        
        if let userLocation = LocationManager.shared.location {
            let orderedCoordinates = coordinates.sorted(by: { (ll, lr) in
                let dl = CLLocation(latitude: ll.latitude, longitude: ll.longitude).distance(from: userLocation)
                let dr = CLLocation(latitude: lr.latitude, longitude: lr.longitude).distance(from: userLocation)
                return dl > dr
            }).prefix(10)
            return self.getBounds(coordinates: Array(orderedCoordinates))

        } else {
            return self.getBounds(coordinates: Array(coordinates))
        }
    }
    
    private func getBounds(coordinates:[CLLocationCoordinate2D]) -> GMSCoordinateBounds? {
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        guard let minLat = latitudes.min() else { return nil }
        guard let minLng = longitudes.min() else { return nil }
        
        guard let maxLat = latitudes.max() else { return nil }
        guard  let maxLng =  longitudes.max() else { return nil }
        
        let coordinateMin = CLLocationCoordinate2D(latitude: minLat, longitude: minLng)
        let coordinateMax = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLng)
        
        return GMSCoordinateBounds(coordinate: coordinateMin, coordinate: coordinateMax)
    }
}
