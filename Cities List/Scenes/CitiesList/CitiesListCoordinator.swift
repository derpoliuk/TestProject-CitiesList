//
//  CitiesListCoordinator.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

final class CitiesListCoordinator {
    private weak var splitViewController: UISplitViewController?

    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    func start() {
        let viewModel = CitiesListViewModelImpl()
        viewModel.eventHandler = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .displayCityDetails(let city): self.showCityDetails(for: city)
            }
        }
        citiesListViewController?.bind(to: viewModel)
        if let vc = currentCityDetailsViewController {
            updateCityDetailViewControllerNavigationItem(vc)
        }
    }
}

// MARK: - Show City Details

private extension CitiesListCoordinator {
    private func showCityDetails(for city: CityInList) {
        guard let splitViewController = splitViewController else {
            assertionFailure("No splitViewController")
            return
        }
        let cityDetailViewController: CityDetailViewController
        if let viewController = currentCityDetailsViewController {
            cityDetailViewController = viewController
        } else {
            cityDetailViewController = CityDetailViewController.initAsInitialFromStoryboard(with: CityDetailViewController.self)
            splitViewController.showDetailViewController(cityDetailViewController, sender: self)
        }
        updateCityDetailViewControllerNavigationItem(cityDetailViewController)
        cityDetailViewController.city = CityDetails(cityInList: city)
    }
}

private extension CitiesListCoordinator {
    private var citiesListViewController: CitiesListViewController? {
        guard let splitViewController = splitViewController else {
            assertionFailure("No splitViewController")
            return nil
        }
        guard let navigationController = splitViewController.viewControllers[0] as? UINavigationController, let viewController = navigationController.viewControllers[0] as? CitiesListViewController else {
            assertionFailure("No CitiesListViewController")
            return nil
        }
        return viewController
    }

    private var currentCityDetailsViewController: CityDetailViewController? {
        guard let splitViewController = splitViewController else {
            assertionFailure("No splitViewController")
            return nil
        }
        guard splitViewController.viewControllers.count > 1,
            let navigationController = splitViewController.viewControllers[1] as? UINavigationController,
            let viewController = navigationController.viewControllers[0] as? CityDetailViewController
            else {
                return nil
        }
        return viewController
    }

    private func updateCityDetailViewControllerNavigationItem(_ vc: CityDetailViewController) {
        vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        vc.navigationItem.leftItemsSupplementBackButton = true
    }
}
