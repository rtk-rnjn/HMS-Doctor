//
//  ResetPasswordViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    var staff: Staff?

    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        staff = DataController.shared.staff
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let password = passwordField.text, !password.isEmpty else {
            return
        }

        guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            return
        }

        guard password == confirmPassword else {
            return
        }

        Task {
            guard let staff else { return }
            let success = await DataController.shared.changePassword(oldPassword: staff.password, newPassword: password)
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
            }
        }
    }
}
