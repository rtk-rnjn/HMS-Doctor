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
            let loggedIn = await DataController.shared.autoLogin()
            if !loggedIn {
                let okAction = AlertActionHandler(title: "OK", style: .default) { _ in
                    self.performSegue(withIdentifier: "segueShowOnBoardingHostingController", sender: nil)
                }
                let alert = Utils.getAlert(title: "Error", message: "Authentication Failed. Please log in again", actions: [okAction])
                present(alert, animated: true)
            }
        }
    }
}
