//
//  CityDetailViewController.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit
import MapKit

final class CityDetailViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    var city: CityInList? {
        didSet {
            if let previousCity = oldValue {
                mapView.removeAnnotation(previousCity)
            }
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        guard let city = city, let mapView = mapView else {
            return
        }
        mapView.addAnnotation(city)
        mapView.setCenter(city.coordinate, animated: true)
    }
}

// I declared this extension here because no other files in the app are using it
extension CityInList: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
    }

    var title: String? {
        return displayName
    }
}
