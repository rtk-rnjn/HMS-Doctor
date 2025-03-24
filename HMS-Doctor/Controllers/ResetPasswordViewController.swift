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
    @IBOutlet weak var signInButton: UIButton!
    
    let eyeButton1 = UIButton(type: .custom)
    let eyeButton2 = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        admin = DataController.shared.admin
        eyeButton1.tintColor = .gray
        eyeButton2.tintColor = .gray
        eyeButton1.isEnabled = false
        eyeButton2.isEnabled = false
        eyeButton1.tag = 10
        configureEyeButton(for: passwordField,button: eyeButton1)
        configureEyeButton(for: confirmPasswordField,button: eyeButton2)
        passwordField.addTarget(self, action: #selector(passwordEntered), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(passwordEnteredForCnfrmPass), for: .editingChanged)
        
        
        
        passwordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
            confirmPasswordField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)

            signInButton.isEnabled = false
            signInButton.alpha = 0.5 //
        
        
        staff = DataController.shared.staff
    }
    
    
    @objc func textFieldsChanged() {
        let password = passwordField.text ?? ""
        let confirmPassword = confirmPasswordField.text ?? ""
        
        let isValid = password.count >= 8 && confirmPassword.count >= 8 && password == confirmPassword
        
        signInButton.isEnabled = isValid
        signInButton.alpha = isValid ? 1.0 : 0.7 // Adjusted opacity for better visibility
    }
    
    
    @objc func passwordEntered(sender:UITextField){
        if passwordField.text?.isEmpty ?? true || passwordField.text == "" {
            eyeButton1.isEnabled = false
            eyeButton1.tintColor = .gray
        }else{
            eyeButton1.isEnabled = true
            eyeButton1.tintColor = .tintColor
        }
    }
    
    @objc func passwordEnteredForCnfrmPass(sender:UITextField){
        if confirmPasswordField.text?.isEmpty ?? true || confirmPasswordField.text == "" {
            eyeButton2.isEnabled = false
            eyeButton2.tintColor = .gray
        }else{
            eyeButton2.isEnabled = true
            eyeButton2.tintColor = .tintColor
        }
    }
    
    private func configureEyeButton(for textField: UITextField,button:UIButton) {
        // Create the eye button
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        // Create a container view to add padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)

        // Adjust the button's position within the container view
        button.frame = CGRect(x: -8, y: 0, width: 30, height: 30) // Adds a 10-point margin on the right

        // Set the container view as the right view of the text field
        textField.rightView = containerView
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true // Ensure secure entry initially
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.tag == 10{
            passwordField.isSecureTextEntry.toggle()
        }
        else{
            confirmPasswordField.isSecureTextEntry.toggle()
        }
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
