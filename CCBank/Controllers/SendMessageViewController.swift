//
//  SendMessageViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/30/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import Firebase

class SendMessageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    var chatID : String!
    var uid: String!
    var threadReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        messageTextField.delegate = self
        messageTextField.clearButtonMode = .always
        messageTextField.clearButtonMode = .whileEditing
        sendMessageButton.isEnabled = false
        threadReference =  FirebaseReferences.currentThread(threadID: chatID).reference()
    }
    
    @IBAction func messageSendAction(_ sender: UIButton) {
        let text = messageTextField.text
        guard let textUnwrapped = text else {
            print("textfield is empty")
         return
        }
        let message = MessageModel(message: textUnwrapped)
        message.addMeessage(chatid: chatID)
    }
    
    @IBAction func textField(_ sender: UITextField) {
        if messageTextField.text!.isEmpty || messageTextField!.text == "" {
            sendMessageButton.isEnabled = false
        } else {
            sendMessageButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}

