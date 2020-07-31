//
//  CitiesListViewController.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

final class CitiesListViewController: UITableViewController {
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var searchBar: UISearchBar!
    private let viewModel: CitiesListViewModel = CitiesListViewModelImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.subscribe(with: self)
        viewModel.loadCities()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = viewModel.cities[indexPath.row]
        cell.textLabel?.text = city.displayName
        cell.detailTextLabel?.text = city.displayCoordinates
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitViewController = splitViewController else {
            return
        }
        let cityDetailViewController: CityDetailViewController
        if splitViewController.viewControllers.count > 1, let navigationController = splitViewController.viewControllers[1] as? UINavigationController, let viewController = navigationController.viewControllers[0] as? CityDetailViewController {
            cityDetailViewController = viewController
        } else {
            cityDetailViewController = CityDetailViewController.initAsInitialFromStoryboard(with: CityDetailViewController.self)
            splitViewController.showDetailViewController(cityDetailViewController, sender: self)
        }
        cityDetailViewController.city = CityDetails(cityInList: viewModel.cities[indexPath.row])
    }
}

// MARK: - UISearchBarDelegate

extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(term: searchText)
    }
}

// MARK: - Observer

extension CitiesListViewController: Observer {
    func didUpdate<T>(_ viewModel: T) where T : Observable {
        if viewModel is CitiesListViewModelImpl {
            updateFromViewModel()
        }
    }

    func didError(_ error: Error) {
        print("Error observing view model: \(error)")
    }
}

// MARK: - Private Methods

private extension CitiesListViewController {
    private func updateFromViewModel() {
        viewModel.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        searchBar.isUserInteractionEnabled = !viewModel.cities.isEmpty
        tableView.reloadData()
    }
}
