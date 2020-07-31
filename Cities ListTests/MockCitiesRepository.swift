//
//  MockCitiesRepository.swift
//  Cities ListTests
//
//  Created by Stanislav Derpoliuk on 12.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation
@testable import Cities_List

struct MockCitiesRepository: CitiesRepository {
    let cities: [City]

    func loadCities() -> [City] {
        return cities
    }
}
