//
//  PlaceAnnotation.swift
//  AroundYou
//
//  Created by Ashish Ranjan on 09/06/23.
//

import Foundation
import MapKit

class PlaceAnnotation: MKPointAnnotation {
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var phoneNumber: String {
        mapItem.phoneNumber ?? ""
    }
    
    var location: CLLocation {
        mapItem.placemark.location ?? CLLocation.default
    }
    
    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "")\(mapItem.placemark.thoroughfare ?? "")\(mapItem.placemark.locality ?? "")\(mapItem.placemark.countryCode ?? "")"
    }
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        
        self.coordinate = mapItem.placemark.coordinate
    }
}
