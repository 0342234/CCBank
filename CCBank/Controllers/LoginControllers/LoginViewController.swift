//
//  LoginViewController.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 12.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .join
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        loginToFir()
    }
    
    @IBAction func sigInButton(_ sender: UIButton) {
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 101 : view.viewWithTag(102)?.becomeFirstResponder()
        case 102 : view.endEditing(true); loginToFir()
        default : print("Login page tefiedl DOESNT WORK")
        }
        return true
    }
    
    func loginToFir () {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
            if error != nil {
                self.handleError(error!)
            }
            else {
                self.performSegue(withIdentifier: "FromLoginToTabBar", sender: nil)
            }
        })
        
    }
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alertView = AlertView(errorName: errorCode.errorMessage, initFrame: self.view.frame)
            self.view.addSubview(alertView)
            print(errorCode.errorMessage)
        }
    }
}

