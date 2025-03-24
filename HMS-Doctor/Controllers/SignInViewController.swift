//
//  SignInViewController.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

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
            let loggedIn = await DataController.shared.login(emailAddress: email, password: password)

            DispatchQueue.main.async {
                if loggedIn {
                    self.performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)

                } else {
                    self.showAlert(message: "Invalid email or password")

                }
            }
        }
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
