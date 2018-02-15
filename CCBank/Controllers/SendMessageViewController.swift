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
        sendMessageButton.isEnabled = false
        threadReference =  FirebaseReferences.currentThread(threadID: chatID).reference()
    }
    
    @IBAction func messageSendAction(_ sender: UIButton) {
        let text = messageTextField.text ?? ""
        let message = Message(message: text)
        message.addMeessaged(toChat: chatID)
        messageTextField.text = ""
    }
    
   
    @IBAction func textField(_ sender: UITextField) {
        if messageTextField.text!.isEmpty || messageTextField!.text == "" {
            sendMessageButton.isEnabled = false
        } else {
            
                sendMessageButton.isEnabled = true
            }
    }
    
  
    
    }

