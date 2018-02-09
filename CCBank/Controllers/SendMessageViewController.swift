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
    
    var chatID : String!
    var uid: String! = { return Auth.auth().currentUser?.uid }()
    var threadReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        threadReference =  FirebaseReferences.currentThread(threadID: chatID).reference()
        
    }
    
    @IBAction func messageSendAction(_ sender: UIButton) {
        let timestamp = Date().currentTimestamp()
        let message = messageTextField.text ?? ""
        let uid = self.uid
        let messageObject = Message(payload: message , timestamp: timestamp, userID: uid)
        threadReference.child("messages").childByAutoId().updateChildValues(messageObject.dictionaryInterpritation)
    }
}
