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
    @IBAction func loginButtonTapped(_ sender: Any) {
            guard let username = emailTextField.text, !username.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Please enter both username and password")
                return
            }
            
            // Check credentials (replace this with your actual authentication logic)
            if username == "admin" && password == "password" {
                // Successful login
                performSegue(withIdentifier: "loginToHome", sender: nil)
            } else {
                // Failed login
                showAlert(message: "Incorrect username or password")
            }
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Alert",
                                        message: message,
                                        preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
    }
