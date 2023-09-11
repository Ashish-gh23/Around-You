//
//  PlacesTableViewController.swift
//  AroundYou
//
//  Created by Ashish Ranjan on 09/06/23.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    var places: [PlaceAnnotation]
    let location: CLLocation
    
    private var indexForSelectedRow: Int? {
        self.places.firstIndex(where: { $0.isSelected == true })
    }
    
    init(places: [PlaceAnnotation], location: CLLocation) {
        self.places = places
        self.location = location
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance{
        from.distance(from: to)
        
    }
    
    private func distanceFormatter(distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        return meters.converted(to: UnitLength.kilometers).formatted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailVC = PlaceDetailViewController(place: place)
        present(placeDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = place.name
        let distance = calculateDistance(from: location, to: place.location)
        content.secondaryText = distanceFormatter(distance: distance)
//        content.imageToTextPadding = 4
//        content.image = .add
        cell.contentConfiguration = content
        cell.backgroundColor = place.isSelected ? UIColor.lightGray : UIColor.clear
        return cell
    }
}
