//
//  AppCoordinator.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 31.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

/*
 My original intent was to use coordinators completely without storyboards functionality (using them as regular XIB files for each View Controller). But going with this pure approach required more `UISplitViewController` setup and code became very buggy. I decided to keep Main.storyboard with segues to make `UISplitViewController` setup siple.
 */
final class AppCoordinator {
    private weak var splitViewController: UISplitViewController?
    private var citiesListCoordinator: CitiesListCoordinator?

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
