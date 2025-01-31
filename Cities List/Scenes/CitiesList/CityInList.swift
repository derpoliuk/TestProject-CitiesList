//
//  CityInList.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 12.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

final class CityInList {
    let displayName: String
    let coordinates: Coordinates

    init(displayName: String, coordinates: Coordinates) {
        self.displayName = displayName
        self.coordinates = coordinates
    }

    init(city: City) {
        displayName = "\(city.name), \(city.country)"
        coordinates = city.coord
    }
}

extension CityInList {
    var displayCoordinates: String {
        return "\(coordinates.lat); \(coordinates.lon)"
    }
}
