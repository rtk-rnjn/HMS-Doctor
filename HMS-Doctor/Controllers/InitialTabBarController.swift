//
//  InitialTabBarController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class InitialTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Set up Dashboard as the first tab
        if let viewControllers, !viewControllers.isEmpty {
            let dashboardStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
            if let dashboardController = dashboardStoryboard.instantiateInitialViewController() {
                var controllers = viewControllers
                // Replace the first tab (usually Home) with Dashboard
                controllers[0] = dashboardController
                setViewControllers(controllers, animated: false)
                selectedIndex = 0
            }
        }

        Task {
            _ = DataController.shared.staff
        }
    }
}
