//
//  FirebaseReference.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 13.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import Foundation
import Firebase

enum GetDatabaseReference {
    case root
    case users(uid: String)
    
    func reference() -> DatabaseReference {
        switch self {
        case .root :  return rootRef
        default: return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private var path: String {
        switch  self {
        case .root : return ""
        case .users(let uid) : return "users/\(uid)"
        }
    }
}
