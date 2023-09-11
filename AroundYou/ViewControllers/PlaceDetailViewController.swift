//
//  PlaceDetailViewController.swift
//  AroundYou
//
//  Created by Ashish Ranjan on 09/06/23.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        return nameLabel
    }()
    
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.textAlignment = .left
        addressLabel.font = UIFont.preferredFont(forTextStyle: .body)
        return addressLabel
    }()
    
    lazy var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    lazy var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20)))
        
        let contactStackView = UIStackView(arrangedSubviews: [directionsButton, callButton])
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(contactStackView)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            addressLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20)
        ])
    }
    
    @objc func directionsButtonTapped(_ sender: UIButton) {
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else { return } 
        UIApplication.shared.open(url)
    }
    
    @objc func callButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "tel://\(place.phoneNumber.formatPhoneForCall)") else { return }
        UIApplication.shared.open(url)
        
    }
}
