//
//  AppCoordinator.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

final class AppCoordinator {
    private weak var splitViewController: UISplitViewController?
    var citiesListCoordinator: CitiesListCoordinator?

    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }

    func start() {
        guard let splitViewController = splitViewController else {
            return
        }
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self
        citiesListCoordinator = CitiesListCoordinator(splitViewController: splitViewController)
        citiesListCoordinator?.start()
    }
}

// MARK: - UISplitViewControllerDelegate

extension AppCoordinator: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
