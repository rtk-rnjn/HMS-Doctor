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

        staff?.password = password
        Task {
            guard let staff else { return }
            let success = await DataController.shared.updateStaff(staff)
            if success {
                performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            }
        }
    }
}
