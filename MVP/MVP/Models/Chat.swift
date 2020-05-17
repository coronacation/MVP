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
    var post: DummyPost?
    var postOwner: User?
    
    
    // MARK: - Computed Properties
    
    var dictionary: [String: Any] {
        get {
            return [
                Constants.Chat.postID: postID,
                Constants.Chat.postOwnerUID: postOwnerUID,
                Constants.Chat.blocked: blocked,
                Constants.Chat.askerUID: askerUID,
                Constants.Chat.threadID: threadID,
                Constants.Chat.lastMsg: lastMsg,
                Constants.Chat.lastMsgTimestamp: lastMsgTimestamp
            ]
        }
    }
    
    
    /// Default Initializer
    /// - Parameters:
    ///   - blocked: default value: false
    ///   - lastMsg: String of last message sent
    ///   - lastMsgTimestamp: Timestamp of last message sent
    ///   - askerUID: UID of asker user in Firestore
    ///   - postID: post documentID in Firestore
    ///   - postOwnerUID: UID of post creator user in Firestore
    ///   - threadID: documentID of chat thread in Firestore
    init( blocked: Bool = false,
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
        
        guard let blocked = dictionary[Constants.Chat.blocked] as? Bool,
            let lastMsg = dictionary[Constants.Chat.lastMsg] as? String,
            let lastMsgTimestamp = dictionary[Constants.Chat.lastMsgTimestamp] as? Timestamp,
            let askerUID = dictionary[Constants.Chat.askerUID] as? String,
            let postID = dictionary[Constants.Chat.postID] as? String,
            let postOwnerUID = dictionary[Constants.Chat.postOwnerUID] as? String,
            let threadID = dictionary[Constants.Chat.threadID] as? String
            else { return nil }
                
        self.init(blocked: blocked,
                  lastMsg: lastMsg,
                  lastMsgTimestamp: lastMsgTimestamp,
                  askerUID: askerUID,
                  postID: postID,
                  postOwnerUID: postOwnerUID,
                  threadID: threadID )
        
        self.fetchPost(postID: postID)
        self.fetchPostOwner(postOwnerUID: postOwnerUID)
    } // end convenience init
    
    func fetchPost(postID: String) {
        DummyPost.getBy(docID: postID) { (result) in
            switch result {
            case .success(let postObject):
                self.post = postObject
            case .failure(let error):
                print("#fetchPost failed. Post doesn't exist. Check PostExtension for details.")
                print(error.errorDescription!)
            }
        }
    }
    
    
    func fetchPostOwner(postOwnerUID: String) {
        User.getBy(uid: postOwnerUID) { (user) in
            self.postOwner = user
        }
    }
}
