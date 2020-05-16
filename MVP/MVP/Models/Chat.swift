//
//  Chat.swift
//  MVP
//
//  Created by Theo Vora on 5/1/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Chat {
    
    // MARK: - Properties shared with Firestore
    var blocked: Bool = false
    var lastMsg: String
    var lastMsgTimestamp: Timestamp
    var askerUID: String
    var postID: String
    var postOwnerUID: String
    var threadID: String
    
    
    // MARK: - Swift-only properties
    var post: Post?
    var postOwner: User?
    
    
    
    /// Default Initializer
    /// - Parameters:
    ///   - offer: Post Title
    ///   - offerOwner: Name of the user who made the Post
    ///   - blocked: true or false
    ///   - blockedByUid: UID of the user who initiated the block
    ///   - askerUID: UID of the user who is interested in the Post
    init( blocked: Bool,
          lastMsg: String,
          lastMsgTimestamp: Timestamp,
          askerUID: String,
          postID: String,
          postOwnerUID: String,
          threadID: String ) {
        
        self.blocked = blocked
        self.lastMsg = lastMsg
        self.lastMsgTimestamp = lastMsgTimestamp
        self.askerUID = askerUID
        self.postID = postID
        self.postOwnerUID = postOwnerUID
        self.threadID = threadID
    }
}

extension Chat {
    
    /// Initializer for Chat objects coming from Firestore
    /// - Parameter dictionary: key/value pairs of a chat object. With Firestore, you can simply pass in DocumentRef.data().
    convenience init?(dictionary: [String:Any]) {
        
        guard let blocked = dictionary["blocked"] as? Bool,
            let lastMsg = dictionary["lastMsg"] as? String,
            let lastMsgTimestamp = dictionary["lastMsgTimestamp"] as? Timestamp,
            let askerUID = dictionary["askerUID"] as? String,
            let postID = dictionary["postID"] as? String,
            let postOwnerUID = dictionary["postOwnerUID"] as? String,
            let threadID = dictionary["threadID"] as? String
            else { return nil }
                
        self.init(blocked: blocked,
                  lastMsg: lastMsg,
                  lastMsgTimestamp: lastMsgTimestamp,
                  askerUID: askerUID,
                  postID: postID,
                  postOwnerUID: postOwnerUID,
                  threadID: threadID )
    }
}
