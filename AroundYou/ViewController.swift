//
//  ViewController.swift
//  AroundYou
//
//  Created by Ashish Ranjan on 09/06/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        return mapView
    }()
    
    lazy var searchLocationField: UITextField = {
        let searchLocationField = UITextField()
        searchLocationField.backgroundColor = .white
        searchLocationField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchLocationField.leftViewMode = .always
        searchLocationField.layer.cornerRadius = 10
        searchLocationField.clipsToBounds = true
        searchLocationField.placeholder = "Search"
        searchLocationField.delegate = self
        searchLocationField.returnKeyType = .go
        searchLocationField.translatesAutoresizingMaskIntoConstraints = false
        return searchLocationField
    }()
    
    private var locationManager: CLLocationManager?
    private var places: [PlaceAnnotation] = []
    private var previouslySelectedPlaceAnnotation: PlaceAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setConstraints()
    }
    
    private func setUpUI() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestLocation()
        view.addSubview(mapView)
        view.addSubview(searchLocationField)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            searchLocationField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            searchLocationField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            searchLocationField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchLocationField.heightAnchor.constraint(equalToConstant: 44),
            
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        mapView.topAnchor.constraint(equalTo: view.topAnchor),
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func checkLocationAuthorizationStatus() {
        guard let locationManager = locationManager,
                let location = locationManager.location else { return }
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
            mapView.setRegion(region, animated: true)
        case .denied, .notDetermined, .restricted:
            print("Location access Denied or Restricted")
        default:
            print("There was trouble fetching the location!!")
        }
        
    }
    
    private func findNearbyPlaces(from query: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else { return }
            self?.places = response.mapItems.map(PlaceAnnotation.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            if let places = self?.places {
                self?.presentPlacesList(places: places)
            }
            
        }
    }
    
    private func presentPlacesList(places: [PlaceAnnotation]) {
        guard let locationManager = locationManager,
        let location = locationManager.location else { return }
        
        let placesTableVC = PlacesTableViewController(places: places, location: location)
        placesTableVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTableVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTableVC, animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    private func ClearAllSelections() {
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let placeAnnotation = annotation as? PlaceAnnotation else { return }
        let selectedPlaceAnnotation = places.first(where: { $0.id == placeAnnotation.id })
        selectedPlaceAnnotation?.isSelected = true
        
        // Another way to clear
        //ClearAllSelections()
        previouslySelectedPlaceAnnotation?.isSelected = false
        previouslySelectedPlaceAnnotation = selectedPlaceAnnotation
        
        presentPlacesList(places: self.places)
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let query = textField.text ?? ""
        if !query.isEmpty {
            textField.resignFirstResponder()
            findNearbyPlaces(from: query)
        }
        return true
    }
}
