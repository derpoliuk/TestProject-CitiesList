//
//  LoadingErrorCitiesRepositoryMock.swift
//  Cities ListTests
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation
@testable import Cities_List

struct LoadingErrorCitiesRepositoryMock: CitiesRepository {
    func loadCities() throws -> [CityInList] {
        throw CitiesRepositoryError.fileError
    }
}
