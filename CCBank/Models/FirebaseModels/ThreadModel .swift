//
//  ThreadModel+Reference .swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/7/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import Firebase

class ThreadModel: Codable {
    let title: String!
    var usersAmount: Int! = 0
    let timestamp: Int!
    var users: [String: String]?
    let uid = Auth.auth().currentUser?.uid ?? "UNKNOWN"
    var username: String?
    
    init(title: String, usersAmount: Int, timestamp: Int) {
        self.title = title
        self.usersAmount = usersAmount
        self.timestamp = timestamp
        
    }
    
    var toDictionary: [String: Any]
    {
        return [
            "title" : title,
            "usersAmount" : usersAmount,
            "timestamp" : timestamp,
            "users" : users ?? [:]
        ]
    }
    
    func addThread() {
        FirebaseReferences.currentUser(uid: self.uid).reference().observeSingleEvent(of: .value, with: {
            (dataSnapshot) in
            if let data = dataSnapshot.value as? [ String : String ] {
                print(data)
                self.username = data["username"]!
                    self.users = [self.uid : self.username!]
            }
        })
        let ref = FirebaseReferences.threads.reference()
        ref.childByAutoId().setValue(self.toDictionary)
    }
}
