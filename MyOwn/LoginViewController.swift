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
    
    let loginToList = "LoginToList"

    @IBOutlet var loginTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var loginButton: Button!
    
    @IBOutlet var registerButton: Button!
    
    @IBAction func loginButtonTouch(_ sender: Any) {
        if (loginTextField.text?.isEmpty)! {
            loginTextField?.placeholder = "fill in username."
        } else if (passwordTextField?.text?.isEmpty)! {
            passwordTextField?.placeholder = "fill in password"
        } else {
            print("check1")
            let loginText = loginTextField.text
            let passwordText = passwordTextField.text
            Auth.auth().signIn(withEmail: loginText!, password: passwordText!) { user, error in
                if error == nil {
                    // 3
                    self.performSegue(withIdentifier: "loginToList", sender: nil)
                } else {
                    print("could not login: \(error!)")
                }
            }
        }
    }
    
    @IBAction func registerButtonTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            // 1
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            // 2
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    // 3
                    self.performSegue(withIdentifier: "loginToList", sender: nil)
                } else {
                    print("could not register: \(error!)")
                }
            }

        }
        

        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
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


