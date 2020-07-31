//
//  AppDelegate.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 11.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            appCoordinator = AppCoordinator(splitViewController: splitViewController)
            appCoordinator?.start()
        }
        return true
    }
}
