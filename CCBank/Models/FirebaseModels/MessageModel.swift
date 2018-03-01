//
//  MessageModel+Reference.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/7/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import Firebase

class MessageModel {
    var payload: String!
    var timestamp: Int!
    var userID: String!
    var username: String?
    
    init(message: String) {
        timestamp = Date().currentTimestamp()
        userID = Auth.auth().currentUser?.uid ?? "EMPTY"
        payload = message
    }
    
    var dictionaryInterpritation: [String: Any] {
        return [
            "payload" : payload,
            "timestamp" : timestamp,
            "userID" : userID,
            "username" : username ?? "KLEI"
        ]
    }
    
    func addMeessage(chatid: String) {
        FirebaseReferences.users.reference().child(userID).observeSingleEvent(of: .value) { (dataSnapshot) in
            if let data = dataSnapshot.value as? [ String : Any ] {
                self.username = data["username"] as? String
                FirebaseReferences.threads.reference().child(chatid).child("messages").childByAutoId().setValue(self.dictionaryInterpritation)
            }
        }
    }
    
    
}

