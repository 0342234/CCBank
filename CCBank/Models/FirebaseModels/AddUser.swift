//
//  AddUser.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 13.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import Foundation
import Firebase

class AddUser {
    let username: String
    let uid: String
    let email: String
    
    
    init(username: String, uid: String, email: String) {
        self.username = username
        self.uid = uid
        self.email = email
    }
    
    var toDictionary: [String: Any]
    {
        return [
            "uid" : uid,
            "username" : username,
            "email" : email
        ]
    }
    
    func save() {
        let ref = FirebaseReferences.users.reference()
        ref.child(uid).setValue(toDictionary)
    }

   

}


