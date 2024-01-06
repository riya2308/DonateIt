//
//  LoginViewController.swift
//  DonateIt
//

//

import UIKit
import Parse

class LoginViewController: UIViewController {
    

    @IBOutlet weak var signUp_ConfirmPassword: UITextField!
    @IBOutlet weak var signUp_Password: UITextField!
    @IBOutlet weak var signUp_UserName: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    var isPasswordVisible = false
    let showPasswordButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setupEyeIcon(for: passwordField)
        // Set up the eye icon button for the confirm password field
        //setupEyeIcon(for: signUp_ConfirmPassword)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        
      }
    deinit {
        // Check if the view is not nil
        guard let view = view else {
            return
        }

        // Remove tap gesture recognizers to avoid memory leaks
        if let gestureRecognizers = view.gestureRecognizers {
            gestureRecognizers.forEach {
                view.removeGestureRecognizer($0)
            }
        }
    }

    func setupEyeIcon(for textField: UITextField) {
            let eyeButton = UIButton(type: .custom)
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            eyeButton.tintColor = .lightGray
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

            textField.rightView = eyeButton
            textField.rightViewMode = .always
            textField.isSecureTextEntry = true
        }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    @objc func togglePasswordVisibility(_ sender: UIButton) {
            isPasswordVisible.toggle()

            if let textField = sender.superview as? UITextField {
                textField.isSecureTextEntry = !isPasswordVisible
                let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
                sender.setImage(UIImage(systemName: imageName), for: .normal)
            }
        }
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                if let errorDescription = error?.localizedDescription {
                    print("Error: \(errorDescription)")

                    // Show an alert indicating the login failure
                    self.showAlert(title: "Login Failed", message: "Username or password is incorrect. Please try again.")
                } else {
                    print("Error logging in.")
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUp2(_ sender: Any) {
        guard let username = signUp_UserName.text, let password = signUp_Password.text, 
                let name=Name.text, 
                let email = email.text,
              let confirmPassword = signUp_ConfirmPassword.text else {
                // Handle the case where any of the text fields are nil
                return
            }

            // Check if passwords match
            if password == confirmPassword {
                let user = PFUser()
                user.username = username
                user.password = password
                user.name = name
                user.email = email
                user.signUpInBackground { (success, error) in
                    if success {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } else {
                        if let errorDescription = error?.localizedDescription {
                            print("Error: \(errorDescription)")

                            // Show an alert indicating the sign-up failure
                            self.showAlert2(title: "Sign Up Failed", message: errorDescription)
                        } else {
                            print("Error signing up.")
                        }
                    }
                }
            } else {
                // Passwords don't match, show an alert
                showAlert2(title: "Error", message: "Passwords do not match. Please try again.")
            }
        }

        func showAlert2(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
        }
    
    
    @IBAction func onSignUp(_ sender: Any) {
     
      }
}
