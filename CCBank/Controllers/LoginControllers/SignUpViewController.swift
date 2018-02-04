//
//  SignUpViewController.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 13.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
    let nickname = nickNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let repeatedPassworrd = repeatPasswordTextField.text!
        
        if password == repeatedPassworrd {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (fixrabaseUser, error) in
                if error == nil {
                    let newUser = AddUser(username: nickname, uid: (fixrabaseUser?.uid)!, email: email)
                newUser.save()
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
                        if let error = error {
                            print(error)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } else { print(error!.localizedDescription)}
            })
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
