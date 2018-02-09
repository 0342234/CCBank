//
//  FirebaseReference.swift
//  LoginPageFirebase
//
//  Created by Yaroslav Bosenko on 13.12.2017.
//  Copyright © 2017 Yaroslav Bosenko. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseReferences {
    case root
    case currentUser(uid: String)
    case users
    case threads
    case currentThread(threadID: String)
    
    func reference() -> DatabaseReference {
        switch self {
            case .root :  return rootReference
            case .threads : return rootReference.child(path)
            case .currentThread : return rootReference.child(path)
            case .users : return rootReference.child(path)
            case .currentUser : return rootReference.child(path)
        }
    }
    
    private var rootReference: DatabaseReference {
        return Database.database().reference()
    }
    
 
    
    private var path: String {
        switch self {
            case .root : return ""
            case .users : return "users"
            case .currentUser(let uid) : return "users/\(uid)/"
            case .threads : return "threads/"
            case .currentThread(let threadID): return "threads/\(threadID)"
        }
    }
}
