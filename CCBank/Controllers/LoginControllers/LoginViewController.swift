//
//  LoginViewController.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 12.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
            if let error = error {
                print(error)
            } else {

                self.performSegue(withIdentifier: "FromLoginToTabBar", sender: nil)
            }
        })
        
    }
    @IBAction func sigInButton(_ sender: UIButton) {
    }
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
    }
}
