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
    var username: String
    var uid: String
    var email: String
    init(username: String, uid: String, email: String) {
        self.username = username
        self.uid = uid
        self.email = email
    }
    
    func toDictionary()-> [String: Any] {
        return [
            "uid" : uid,
            "username" : username,
            "email" : email
        ]
    }
    
    func save() {
        let ref = GetDatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
    }
}

