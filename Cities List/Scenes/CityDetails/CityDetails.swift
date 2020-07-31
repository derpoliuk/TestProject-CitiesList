//
//  CityDetails.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation
import MapKit

final class CityDetails: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?

    init(cityInList: CityInList) {
        coordinate = CLLocationCoordinate2D(latitude: cityInList.coordinates.lat, longitude: cityInList.coordinates.lon)
        title = cityInList.displayName
    }
}
