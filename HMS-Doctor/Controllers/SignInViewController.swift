//
//  SignInViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowResetPasswordViewController", let resetPasswordViewController = segue.destination as? ResetPasswordViewController {
            resetPasswordViewController.staff = sender as? Staff
        }
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            return
        }

        Task {
            guard let staff = await DataController.shared.fetchStaff(email: email, password: password) else { return }
            performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: staff)

        }
    }
}
