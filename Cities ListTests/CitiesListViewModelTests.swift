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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        // WHEN
        viewModel.loadCities()
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities()
        // WHEN
        viewModel.searchTerm = "a"
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities()
        // WHEN
        viewModel.searchTerm = "Al"
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities()
        // WHEN
        viewModel.searchTerm = "Alb"
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities()
        // WHEN
        viewModel.searchTerm = "Sydm"
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities()
        // WHEN
        viewModel.searchTerm = "Sydm"
        viewModel.searchTerm = ""
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
            ].map(City.init)
        let citiesLoader = MockCitiesLoader(cities: cities)
        let viewModel = CitiesListViewModel(citiesLoader: citiesLoader)
        viewModel.loadCities(async: false)
        // WHEN
        viewModel.searchTerm = "Sydney, AU"
        // THEN
        XCTAssertEqual(viewModel.cities.count, 1)
        XCTAssertEqual(viewModel.cities[0].displayName, "Sydney, AU")
    }
}

private extension City {
    convenience init(testName: String) {
        self.init(displayName: testName, coordinates: Coordinates(lat: 0, lon: 0))
    }
}
