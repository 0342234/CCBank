//
//  SendMessageViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 1/30/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import Firebase

struct PostMessage {
    let text: String!
}

class SendMessageViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var messageTextField: UITextField!
        var chatID : String?
    
    let reference: DatabaseReference = {
        return Database.database().reference()
        }()
    
    let uid: String?  = { Auth.auth().currentUser?.uid }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        
    }
    
    @IBAction func messageSendAction(_ sender: UIButton) {
        let timestamp = Date().currentTimestamp()
        let message = messageTextField.text ?? ""
        let uid = self.uid ?? "undefined"
        let messageObject = Message(payload: message , timestamp: timestamp, userID: uid)
        
        reference.child("threads").child(chatID!).child("messages").childByAutoId().updateChildValues(messageObject.dictionaryInterpritation)
    }

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    



}
