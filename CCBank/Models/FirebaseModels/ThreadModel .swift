//
//  ThreadModel+Reference .swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/7/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import Firebase

class ThreadModel {
    let title: String
    var usersAmount: Int = 1
    let timestamp: Int
    var users: Dictionary< String, String>?
    let uid: String
    var username: String?
    var creator: Dictionary< String, String>?
    var message: Dictionary< String, Dictionary< String, Any> >
    
    init(title: String) {
        self.title = title
        timestamp = Date().currentTimestamp()
        uid = Auth.auth().currentUser?.uid ?? "EMPTY"
        let message = Message(message: "Test")
        self.message = ["testKeyForMessage" : message.dictionaryInterpritation]
    }
    
    var toDictionary: [String: Any]
    {
        return [
            "title" : title,
            "usersAmount" : usersAmount,
            "timestamp" : timestamp,
            "users" : users!,
            "creator" : uid,
            "messages" : message
        ]
    }
    
    func addThread() {
        FirebaseReferences.users.reference().child(uid).observeSingleEvent(of: .value) { (dataSnapshot) in
            if let data = dataSnapshot.value as? [ String : String ] {
                self.username = data["username"]!
                self.users = [self.uid : self.username!]
                self.creator = self.users
                let ref = FirebaseReferences.threads.reference()
                ref.childByAutoId().setValue(self.toDictionary)
            }
        }
    }
    

}
