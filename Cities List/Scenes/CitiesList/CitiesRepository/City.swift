//
//  City.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

struct City: Codable {
    let name: String
    let country: String
    let coord: Coordinates
}
