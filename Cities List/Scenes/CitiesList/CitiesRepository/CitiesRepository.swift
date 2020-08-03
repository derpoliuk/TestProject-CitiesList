//
//  CitiesRepository.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

protocol CitiesRepository {
    func loadCities() throws -> [CityInList]
}

enum CitiesRepositoryError: Error {
    case fileError
}

struct CitiesJSONRepository: CitiesRepository {
    func loadCities() throws -> [CityInList] {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            assertionFailure("No cities.json")
            throw CitiesRepositoryError.fileError
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let rawCities = try decoder.decode([City].self, from: data)
        return rawCities.map(CityInList.init)
    }
}
