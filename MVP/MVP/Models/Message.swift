//
//  Message.swift
//  MVP
//
//  Created by Theo Vora on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MessageKit

struct Message {
    
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    
    var dictionary: [String: Any] {
        
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID]
    }
    
    var createdDate: Date {
        get {
            return created.dateValue() // TO-DO: Put Timestamp extension in DateHelper
        }
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String
            else {return nil}
        
        self.init(id: id, content: content, created: created, senderID: senderID)
        
    }
}

extension Message: MessageType {
    var sender: SenderType {
        let firstName = ChatListController.shared.usersDictionary[senderID] ?? "unknown name"
        return Sender(senderId: senderID, displayName: firstName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
