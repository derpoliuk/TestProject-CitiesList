//
//  CitiesListViewModel.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

final class CitiesListViewModel: ObservableType {
    var cities: [CityInList] = []{
        didSet {
            postUpdateToObservers()
        }
    }
    var isLoading = false {
        didSet {
            postUpdateToObservers()
        }
    }

    private let citiesRepository: CitiesRepository
    /// Original list of cities, read from JSON and sorted by name
    private var originalCities: [CityInList] = []
    /// Cities stored by their displayed name
    private var citiesByName: [String: CityInList] = [:]
    /**
     Trie that stores display names of cities

     I used trie structure to improve time efficiency of filtering cities.
     */
    private let trie = Trie()
    private var searchDispatchWorkItem: DispatchWorkItem?

    init(citiesRepository: CitiesRepository = CitiesJSONRepository()) {
        self.citiesRepository = citiesRepository
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

    func filter(term: String, async: Bool = true) {
        guard !term.isEmpty else {
            resetCities()
            return
        }
        isLoading = true
        guard async else {
            cities = filterCities(term: term)
            isLoading = false
            return
        }
        if let workItem = searchDispatchWorkItem {
            workItem.cancel()
        }
        let workItem = DispatchWorkItem { [weak self] in
            guard let cities = self?.filterCities(term: term) else {
                return
            }
            DispatchQueue.main.async {
                self?.cities = cities
                self?.isLoading = false
            }
        }
        searchDispatchWorkItem = workItem
        DispatchQueue.global().async(execute: workItem)
    }
}

private extension CitiesListViewModel {
    private func loadAndSortCities() -> [CityInList] {
        return citiesRepository.loadCities().sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
    }

    private func updateCitiesAfterIntialLoad(_ cities: [CityInList]) {
        for city in cities {
            trie.insert(word: city.displayName.lowercased())
            citiesByName[city.displayName.lowercased()] = city
        }
        originalCities = cities
        self.cities = cities
        isLoading = false
    }

    private func resetCities() {
        isLoading = true
        cities = originalCities
        isLoading = false
    }

    private func filterCities(term: String) -> [CityInList] {
        let words = trie.findWordsWithPrefix(prefix: term)
        var cities: [CityInList] = []
        for word in words {
            if let city = citiesByName[word] {
                cities.append(city)
            }
        }
        return cities
    }
}
