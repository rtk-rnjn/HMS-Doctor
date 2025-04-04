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
    @IBOutlet var signInButton: UIButton!

    let eyeButton: UIButton = .init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        eyeButton.tintColor = .gray
        eyeButton.isEnabled = false

        passwordTextField.configureEyeButton(with: eyeButton)
        passwordTextField.addTarget(self, action: #selector(passwordEntered), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
                passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)

                // Initially disable sign-in button
                signInButton.isEnabled = false
                signInButton.alpha = 1.0

        navigationItem.hidesBackButton = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowResetPasswordViewController", let resetPasswordViewController = segue.destination as? ResetPasswordViewController {
            resetPasswordViewController.staff = sender as? Staff
        }
    }

    @objc func textFieldsChanged() {
        let isValidEmail = (emailTextField.text ?? "").isValidEmail()
            let isPasswordFilled = !(passwordTextField.text?.isEmpty ?? true)

            signInButton.isEnabled = isValidEmail && isPasswordFilled
//        signInButton.alpha = signInButton.isEnabled ? 1.0 : 0.5
        }

    @objc func passwordEntered(sender: UITextField) {
            if passwordTextField.text?.isEmpty ?? true || passwordTextField.text == "" {
                eyeButton.isEnabled = false
                eyeButton.tintColor = .gray
            } else {
                eyeButton.isEnabled = true
                eyeButton.tintColor = .tintColor
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
                    if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                        self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)
                    }

                } else {
                    self.showAlert(message: "Invalid email or password")

                }
            }
        }
    }

    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowOTPResetPasswordViewController", sender: nil)
    }

    // MARK: Private

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }

}
