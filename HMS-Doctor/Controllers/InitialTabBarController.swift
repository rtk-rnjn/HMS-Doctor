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

        Task {
            _ = DataController.shared.staff
        }
    }
}
