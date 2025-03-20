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

        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }
}
