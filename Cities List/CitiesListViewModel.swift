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

    private var originalCities: [City] = []
    private let citiesLoader: CitiesLoader

    init(citiesLoader: CitiesLoader = CitiesJSONLoader()) {
        self.citiesLoader = citiesLoader
    }

    func loadCities(async: Bool = true) {
        isLoading = true
        guard async else {
            originalCities = loadAndSortCities()
            cities = originalCities
            isLoading = false
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else {
                return
            }
            let cities = self.loadAndSortCities()
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.originalCities = cities
                self.cities = cities
                self.isLoading = false
            }
        }
    }

    private func loadAndSortCities() -> [City] {
        return citiesLoader.loadCities().sorted { $0.displayName.lowercased() < $1.displayName.lowercased() }
    }

    private func filterCities(_ term: String) {
        isLoading = true
        cities = originalCities.filter { $0.displayName.lowercased().starts(with: term.lowercased()) }
        isLoading = false
    }

    private func resetCities() {
        isLoading = true
        cities = originalCities
        isLoading = false
    }
}
