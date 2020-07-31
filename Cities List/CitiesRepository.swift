//
//  CitiesRepository.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

protocol CitiesRepository {
    func loadCities() -> [City]
}

struct CitiesJSONRepository: CitiesRepository {
    func loadCities() -> [City] {
        guard let url = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            fatalError("No cities.json")
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let rawCities = try decoder.decode([RawCity].self, from: data)
            return rawCities.map(City.init)
        } catch {
            fatalError("Failed to read JSON data: \(error)")
        }
    }
}
