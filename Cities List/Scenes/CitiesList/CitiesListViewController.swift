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
    private var viewModel: CitiesListViewModel?

    override func viewDidLoad() {
        if viewModel?.isLoading == false {
            viewModel?.loadCities()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
    }

    func bind(to viewModel: CitiesListViewModel) {
        self.viewModel = viewModel
        viewModel.subscribe(with: self)
        if isViewLoaded {
            viewModel.loadCities()
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = viewModel.cities[indexPath.row]
        cell.textLabel?.text = city.displayName
        cell.detailTextLabel?.text = city.displayCoordinates
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.displayCity(for: indexPath)
    }
}

// MARK: - UISearchBarDelegate

extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filter(term: searchText)
    }
}

// MARK: - Observer

extension CitiesListViewController: Observer {
    func didUpdate<T>(_ viewModel: T) where T : Observable {
        if let viewModel = viewModel as? CitiesListViewModelImpl {
            updateFromViewModel(viewModel: viewModel)
        }
    }

    func didError(_ error: Error) {
        print("Error observing view model: \(error)")
    }
}

// MARK: - Private Methods

private extension CitiesListViewController {
    private func updateFromViewModel(viewModel: CitiesListViewModel) {
        viewModel.isLoading == true ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        searchBar.isUserInteractionEnabled = viewModel.cities.isEmpty == false
        tableView.reloadData()
    }
}
