//
//  LoadingCitiesRepositoryMock.swift
//  Cities ListTests
//
//  Created by Stanislav Derpoliuk on 01.08.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation
@testable import Cities_List

final class LoadingCitiesRepositoryMock: CitiesRepository {
    var numberOfLoadCitiesCalls = 0
    let shouldDelayExecution: Bool

    init(shouldDelayExecution: Bool = false) {
        self.shouldDelayExecution = shouldDelayExecution
    }

    func loadCities() throws -> [CityInList] {
        numberOfLoadCitiesCalls += 1
        if shouldDelayExecution {
            usleep(5000)
        }
        return []
    }
}
