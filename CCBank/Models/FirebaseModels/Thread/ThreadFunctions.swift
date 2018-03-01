//
//  ThreadFunctions.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/26/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation
import Firebase

struct ThreadFunctions {
    
    static func leaveChat( chatid: String ) {
        let uid = Auth.auth().currentUser?.uid
        let ref = FirebaseReferences.root.reference()
        ref.child("threads").child(chatid).child("users").child(uid!).removeValue()
        ref.child("users").child(uid!).child("threads").child(chatid).removeValue()
    }

    static func enterChat ( chatid: String, userid: String ) {
        let ref = FirebaseReferences.root.reference()
        var userNickname: String?
        let queue = OperationQueue()
        
        let addUserToThread = BlockOperation {
            ref.child("threads").child(chatid).runTransactionBlock { (mutableData) -> TransactionResult in
                if var data = mutableData.value as? [String: AnyObject] {
                    var users: Dictionary<String, String>?
                    users = data["users"] as? [ String: String] ?? [:]
                    users![userid] = userNickname
                    data["users"] = users as AnyObject?
                    mutableData.value = data
                }
                return TransactionResult.success(withValue: mutableData)
            }
        }
   
        let addThreadToUser = BlockOperation {
            let currentTimestamp = Date().currentTimestamp()
            ref.child("users").child(userid).child("threads").child(chatid).setValue("\(currentTimestamp)")
        }
        
        let getNickname = BlockOperation {
            ref.child("users").child(userid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                if dataSnapshot.exists() {
                    if let data = dataSnapshot.value as? [String : Any]  {
                        userNickname = data["username"] as? String
                    }
                }
            })
        }
        
        let removeObservers = BlockOperation {
            ref.removeAllObservers()
        }
    
        
        let userCheck =  BlockOperation {
            ref.child("users").child(userid).child("threads").observeSingleEvent(of: .value, with: { (datasnapshot) in
                guard datasnapshot.exists() else {
                    queue.addOperation(getNickname)
                    queue.addOperation(addThreadToUser)
                    queue.addOperation(addUserToThread)
                    removeObservers.start()
                    return
                }
                if let datasnapshot = datasnapshot.value as? [String : String] {
                    if datasnapshot[chatid] == nil {
                        queue.addOperation(getNickname)
                        queue.addOperation(addThreadToUser)
                        queue.addOperation(addUserToThread)
                        removeObservers.start()
                    } else {
                        queue.cancelAllOperations()
                        removeObservers.start()
                    }
                }
            })
        }
        queue.addOperation(userCheck)
    }
}
