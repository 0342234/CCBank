//
//  SignUpViewController.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 13.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let nickname = nickNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let repeatedPassworrd = repeatPasswordTextField.text!
        var phrase: String {
            guard nickname.isEmpty == false else { return " Nickname field is empty " }
            print(nickname)
            guard email.isEmpty == false else { return " Email is empty " }
            guard password.isEmpty == false else { return " assword field is empty " }
            guard repeatedPassworrd.isEmpty == false else { return  " Please repeat password " }
            guard password == repeatedPassworrd  else { return " Passes do not match " }
            return ""
        }
        if phrase != "" {
            let alertView = AlertView(errorName: phrase, initFrame: self.view.frame)
            self.view.addSubview(alertView)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (firebaseUser, error) in
            if error == nil {
                let newUser = AddUser(username: nickname, uid: (firebaseUser?.uid)!, email: email)
                newUser.save()
                Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else { self.handleError(error!) }
        })
    }
    
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alertView = AlertView(errorName: errorCode.errorMessage, initFrame: self.view.frame)
            self.view.addSubview(alertView)
            print(errorCode.errorMessage)
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 201: view.viewWithTag(202)?.becomeFirstResponder()
        case 202: view.viewWithTag(203)?.becomeFirstResponder()
        case 203: view.viewWithTag(204)?.becomeFirstResponder()
        case 204: view.viewWithTag(204)?.resignFirstResponder()
        default: print("One of sign up textfields tag undefined")
        }
        return true
    }
}
