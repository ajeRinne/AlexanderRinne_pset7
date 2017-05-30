//
//  LogInViewController.swift
//  MyOwn
//
//  Created by Alexander Rinne on 21-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: Button!
    @IBOutlet var registerButton: Button!
    
    // MARK: Actions
    @IBAction func loginButtonTouch(_ sender: Any) {
        
//        Check if textfields are filled in
        if (loginTextField.text?.isEmpty)! {
            loginTextField?.placeholder = "fill in username."
        } else if (passwordTextField?.text?.isEmpty)! {
            passwordTextField?.placeholder = "fill in password"
        } else {
            
//              Get input form textfields
            let loginText = loginTextField.text
            let passwordText = passwordTextField.text
            
//            Authenticate user and log in check for false login
            Auth.auth().signIn(withEmail: loginText!, password: passwordText!) { user, error in
                if error == nil {
                    
//                    Perform segue to next view
                    self.performSegue(withIdentifier: "loginToList", sender: nil)
                } else {
                    print("could not login: \(error!)")
                }
            }
        }
    }
    
    @IBAction func registerButtonTouch(_ sender: Any) {
        
//        Pop up alert for Register form
        let alert = UIAlertController(title: "Register", message: "Fill in your new username and password", preferredStyle: .alert)
        
//        Saves input data
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
//              Get values from textfields
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
//              Login with created user
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                
//                Check if input is valid
                if error == nil {
                    
//                      Perform segue to new screen
                    self.performSegue(withIdentifier: "loginToList", sender: nil)
                } else {
                    print("could not register: \(error!)")
                }
            }

        }
        
//        Cancel alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
//        Declare username field
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
//        Declare password field
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
//        Creat actions in alert
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // listen for change in login status
        Auth.auth().addStateDidChangeListener() { auth, user in
            // Check if user is loged in
            if user != nil {
                // Perform segue to next view
                self.performSegue(withIdentifier: "loginToList", sender: nil)
            }
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
}


