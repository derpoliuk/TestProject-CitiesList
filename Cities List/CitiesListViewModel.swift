//
//  CitiesListViewModel.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

/**
 Delegate isn't a good fit for MVVM, Observer will be much better. But in the scope of this test project delegate gets the job done.
 */
protocol CitiesListViewModelDelegate: class {
    func didUpdate(loading: Bool)
    func didUpdate(cities: [City])
}

final class CitiesListViewModel {
    weak var delegate: CitiesListViewModelDelegate?
    var cities: [City] = []{
        didSet {
            delegate?.didUpdate(cities: cities)
        }
    }
    var searchTerm = "" {
        didSet {
            if searchTerm.isEmpty {
                resetCities()
            } else {
                filterCities(searchTerm)
            }
        }
    }
    var isLoading = false {
        didSet {
            delegate?.didUpdate(loading: isLoading)
        }
    }

    private let citiesLoader: CitiesLoader
    /// Original list of cities, read from JSON and sorted by name
    private var originalCities: [City] = []
    /// Cities stored by their displayed name
    private var citiesByName: [String: City] = [:]
    /**
     Trie that stores display names of cities

     I used trie structure to improve time efficiency of filtering cities.
     */
    private let trie = Trie()

    init(citiesLoader: CitiesLoader = CitiesJSONLoader()) {
        self.citiesLoader = citiesLoader
    }

    func loadCities(async: Bool = true) {
        isLoading = true
        guard async else {
            let cities = loadAndSortCities()
            updateCitiesAfterIntialLoad(cities)
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            let cities = self.loadAndSortCities()
            DispatchQueue.main.async { [weak self] in
                self?.updateCitiesAfterIntialLoad(cities)
            }
        }
    }

    private func loadAndSortCities() -> [City] {
        return citiesLoader.loadCities().sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
    }

    private func updateCitiesAfterIntialLoad(_ cities: [City]) {
        for city in cities {
            trie.insert(word: city.displayName.lowercased())
            citiesByName[city.displayName.lowercased()] = city
        }
        originalCities = cities
        self.cities = cities
        isLoading = false
    }

    private func filterCities(_ term: String) {
        isLoading = true
        let words = trie.findWordsWithPrefix(prefix: term)
        var cities: [City] = []
        for word in words {
            if let city = citiesByName[word] {
                cities.append(city)
            }
        }
        self.cities = cities
        isLoading = false
    }

    private func resetCities() {
        isLoading = true
        cities = originalCities
        isLoading = false
    }
}
