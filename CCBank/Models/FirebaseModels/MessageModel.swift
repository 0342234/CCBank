//
//  MessageModel+Reference.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/7/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import Foundation

struct Message: Codable {
    var payload: String!
    var timestamp: Int!
    var userID: String!
    
    var dictionaryInterpritation: [String: Any] {
        return [
            "payload" : payload,
            "timestamp" : timestamp,
            "userID" : userID
        ]
    }
    
    
}
