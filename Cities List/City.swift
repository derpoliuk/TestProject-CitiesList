//
//  City.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 12.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

final class City: NSObject {
    let displayName: String
    let coordinates: Coordinates

    init(displayName: String, coordinates: Coordinates) {
        self.displayName = displayName
        self.coordinates = coordinates
    }

    init(rawCity: RawCity) {
        displayName = "\(rawCity.name), \(rawCity.country)"
        coordinates = rawCity.coord
    }
}
