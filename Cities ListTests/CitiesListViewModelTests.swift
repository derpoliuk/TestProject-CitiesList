//
//  CitiesListViewModelTests.swift
//  Cities ListTests
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import XCTest
@testable import Cities_List

final class CitiesListViewModelTests: XCTestCase {
    func testAlpabeticOrder() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        // WHEN
        viewModel.loadCities(async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 5)
        XCTAssertEqual(viewModel.cities[0].displayName, "Alabama, US")
        XCTAssertEqual(viewModel.cities[1].displayName, "Albuquerque, US")
        XCTAssertEqual(viewModel.cities[2].displayName, "Anaheim, US")
        XCTAssertEqual(viewModel.cities[3].displayName, "Arizona, US")
        XCTAssertEqual(viewModel.cities[4].displayName, "Sydney, AU")
    }

    func testCaseInsensitiveSearch() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "a", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 4)
        XCTAssertEqual(viewModel.cities[0].displayName, "Alabama, US")
        XCTAssertEqual(viewModel.cities[1].displayName, "Albuquerque, US")
        XCTAssertEqual(viewModel.cities[2].displayName, "Anaheim, US")
        XCTAssertEqual(viewModel.cities[3].displayName, "Arizona, US")
    }

    func testSearch1() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "Al", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 2)
        XCTAssertEqual(viewModel.cities[0].displayName, "Alabama, US")
        XCTAssertEqual(viewModel.cities[1].displayName, "Albuquerque, US")
    }

    func testSearch2() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "Alb", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities[0].displayName, "Albuquerque, US")
    }

    func testInvalidSearchTerm() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "Sydm", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 0)
    }

    func testResetingSearch() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "Sydm", async: false)
        viewModel.filter(term: "", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 5)
        XCTAssertEqual(viewModel.cities[0].displayName, "Alabama, US")
        XCTAssertEqual(viewModel.cities[1].displayName, "Albuquerque, US")
        XCTAssertEqual(viewModel.cities[2].displayName, "Anaheim, US")
        XCTAssertEqual(viewModel.cities[3].displayName, "Arizona, US")
        XCTAssertEqual(viewModel.cities[4].displayName, "Sydney, AU")
    }

    func testSearchingNameWithCountry() {
        // GIVEN
        let cities = [
            "Albuquerque, US",
            "Alabama, US",
            "Arizona, US",
            "Anaheim, US",
            "Sydney, AU"
            ].map(CityInList.init)
        let citiesRepository = MockCitiesRepository(cities: cities)
        let viewModel = CitiesListViewModel(citiesRepository: citiesRepository)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.filter(term: "Sydney, AU", async: false)
        // THEN
        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities[0].displayName, "Sydney, AU")
    }
}

private extension CityInList {
    convenience init(testName: String) {
        self.init(displayName: testName, coordinates: Coordinates(lat: 0, lon: 0))
    }
}
