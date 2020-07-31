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
    private let viewModel = CitiesListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadCities()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         Default Master-Detail implementatino uses force-unwraps for accessing `CityDetailViewController`. I changed it to multiple optionals. This is my general approach in development - I'm trying not to crash the app when it isn't necessary.

         This is somewhat ideological discussion: should we terminate app to avoid any inconsistent states or should we keep it running.

         Also, one more argument for terminating app in this particular case is that force-unwrap will fail only when developer will make a mistake. And we will be able to catch this error as early as possible.

         For me personally, this kind of human error (not providing propper classes, changing segue identifier without updating code), isn't bad enough to crash the app. Hence, optionals are used.
         */
        guard segue.identifier == "showDetail",
            let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? CityDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        controller.city = CityDetails(cityInList: viewModel.cities[indexPath.row])
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: - Table View

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



extension UIViewController {
    class func initAsInitialFromStoryboard<T: UIViewController>(with type: T.Type, storyboard name: String = "\(T.self)") -> T {
        //swiftlint:disable:next force_cast
        let controller = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as! T
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}




// MARK: - UISearchBarDelegate

extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(term: searchText)
    }
}

// MARK: - CitiesListViewModelDelegate

extension CitiesListViewController: CitiesListViewModelDelegate {
    func didUpdate(loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func didUpdate(cities: [CityInList]) {
        searchBar.isUserInteractionEnabled = true
        tableView.reloadData()
    }
}

private extension CityInList {
    var displayCoordinates: String {
        return "\(coordinates.lat); \(coordinates.lon)"
    }
}
