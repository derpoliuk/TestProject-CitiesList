//
//  CitiesListViewModel.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

protocol CitiesListViewModel: Observable {
    var cities: [CityInList] { get }
    var isLoading: Bool { get }
    var errorHandler: ((Error) -> Void)? { get set }
    var eventHandler: ((CitiesListSceneResult) -> Void)? { get }
    func loadCities()
    func filter(term: String)
    func displayCity(for indexPath: IndexPath)
}

final class CitiesListViewModelImpl: ObservableType, CitiesListViewModel {
    var errorHandler: ((Error) -> Void)?
    var eventHandler: ((CitiesListSceneResult) -> Void)?
    private(set) var cities: [CityInList] = []{
        didSet {
            postUpdateToObservers()
        }
    }
    private(set) var isLoading = false {
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

    func loadCities() {
        loadCities(async: true)
    }

    func filter(term: String) {
        filter(term: term, async: true)
    }

    func displayCity(for indexPath: IndexPath) {
        let city = cities[indexPath.row]
        eventHandler?(.displayCityDetails(city: city))
    }
}

extension CitiesListViewModelImpl {
    func loadCities(async: Bool) {
        isLoading = true
        guard async else {
            do {
                let cities = try loadAndSortCities()
                updateCitiesAfterIntialLoad(cities)
            } catch {
                self.isLoading = false
                errorHandler?(error)
            }
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            let cities: [CityInList]
            do {
                cities = try self.loadAndSortCities()
            } catch {
                self.errorHandler?(error)
                self.isLoading = false
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateCitiesAfterIntialLoad(cities)
            }
        }
    }

    func filter(term: String, async: Bool) {
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

private extension CitiesListViewModelImpl {
    private func loadAndSortCities() throws -> [CityInList] {
        return try citiesRepository.loadCities().sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
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
