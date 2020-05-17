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
    let chatOwnerUID: String
    var blocked: Bool = false
    var lastMsg: String
    var lastMsgTimestamp: Timestamp
    var askerUID: String
    var askerFirstName: String
    var askerLastName: String
    var askerPhotoURL: String
    var postID: String
    var postTitle: String
    var postOwnerUID: String
    var postOwnerFirstName: String
    var postOwnerLastName: String
    var postOwnerPhotoURL: String
    var threadID: String
    
    
    // MARK: - Swift-only properties
    var post: DummyPost?
    var postOwner: User?
    
    
    // MARK: - Computed Properties
    
    var otherUserFirstName: String {
        return chatOwnerUID == askerUID ? postOwnerFirstName : askerFirstName
    }
    var otherUserPhotoURL: String {
        return chatOwnerUID == askerUID ? postOwnerPhotoURL : askerPhotoURL
    }
    
    var dictionary: [String: Any] {
        get {
            return [
                Constants.Chat.chatOwnerUID: chatOwnerUID,
                Constants.Chat.blocked: blocked,
                Constants.Chat.lastMsg: lastMsg,
                Constants.Chat.lastMsgTimestamp: lastMsgTimestamp,
                Constants.Chat.askerUID: askerUID,
                Constants.Chat.askerFirstName: askerFirstName,
                Constants.Chat.askerLastName: askerLastName,
                Constants.Chat.askerPhotoURL: askerPhotoURL,
                Constants.Chat.postID: postID,
                Constants.Chat.postTitle: postTitle,
                Constants.Chat.postOwnerUID: postOwnerUID,
                Constants.Chat.postOwnerFirstName: postOwnerFirstName,
                Constants.Chat.postOwnerLastName: postOwnerLastName,
                Constants.Chat.postOwnerPhotoURL: postOwnerPhotoURL,
                Constants.Chat.threadID: threadID,
            ]
        }
    }
    
    
    /// Default Initializer. Chat in this app works much like Direct Messaging.
    /// Chat objects are created for each participant in the conversation.
    /// Each user is the chat is a chatOwner of their own Chat object.
    /// When currentUser views their ChatListTableViewController, their tableView
    /// data source is simply an array of the currentUser's Chat objects.
    ///
    /// - Parameters:
    ///   - chatOwnerUID: UID of the owner of this chat object. This could be either the asker or the postOwner.
    ///   - blocked: default value: **false**
    ///   - lastMsg: String of last message sent
    ///   - lastMsgTimestamp: Timestamp of last message sent
    ///   - askerUID: UID of asker user in Firestore
    ///   - askerFirstName: asker's first name
    ///   - askerLastName: asker's last name
    ///   - askerPhotoURL: string of the asker's photo URL
    ///   - postID: post documentID in Firestore
    ///   - postTitle: string of the post title
    ///   - postOwnerUID: UID of post creator user in Firestore
    ///   - postOwnerFirstName: first name of the post creator
    ///   - postOwnerLastName: last name of the post creator
    ///   - postOwnerPhotoURL: string of the post creator's photo URL
    ///   - threadID: documentID of chat thread in Firestore
    init( chatOwnerUID: String,
          blocked: Bool = false,
          lastMsg: String,
          lastMsgTimestamp: Timestamp,
          askerUID: String,
          askerFirstName: String,
          askerLastName: String,
          askerPhotoURL: String,
          postID: String,
          postTitle: String,
          postOwnerUID: String,
          postOwnerFirstName: String,
          postOwnerLastName: String,
          postOwnerPhotoURL: String,
          threadID: String ) {
        
        self.chatOwnerUID = chatOwnerUID
        self.blocked = blocked
        self.lastMsg = lastMsg
        self.lastMsgTimestamp = lastMsgTimestamp
        self.askerUID = askerUID
        self.askerFirstName = askerFirstName
        self.askerLastName = askerLastName
        self.askerPhotoURL = askerPhotoURL
        self.postID = postID
        self.postTitle = postTitle
        self.postOwnerUID = postOwnerUID
        self.postOwnerFirstName = postOwnerFirstName
        self.postOwnerLastName = postOwnerLastName
        self.postOwnerPhotoURL = postOwnerPhotoURL
        self.threadID = threadID
    }
}

extension Chat {
    
    /// Initializer for Chat objects coming from Firestore
    /// - Parameter dictionary: key/value pairs of a chat object. With Firestore, you can simply pass in DocumentRef.data().
    convenience init?(dictionary: [String:Any]) {
        
        guard let chatOwnerUID = dictionary[Constants.Chat.chatOwnerUID] as? String,
            let blocked = dictionary[Constants.Chat.blocked] as? Bool,
            let lastMsg = dictionary[Constants.Chat.lastMsg] as? String,
            let lastMsgTimestamp = dictionary[Constants.Chat.lastMsgTimestamp] as? Timestamp,
            let askerUID = dictionary[Constants.Chat.askerUID] as? String,
            let askerFirstName = dictionary[Constants.Chat.askerFirstName] as? String,
            let askerLastName = dictionary[Constants.Chat.askerLastName] as? String,
            let askerPhotoURL = dictionary[Constants.Chat.askerPhotoURL] as? String,
            let postID = dictionary[Constants.Chat.postID] as? String,
            let postTitle = dictionary[Constants.Chat.postTitle] as? String,
            let postOwnerUID = dictionary[Constants.Chat.postOwnerUID] as? String,
            let postOwnerFirstName = dictionary[Constants.Chat.postOwnerFirstName] as? String,
            let postOwnerLastName = dictionary[Constants.Chat.postOwnerLastName] as? String,
            let postOwnerPhotoURL = dictionary[Constants.Chat.postOwnerPhotoURL] as? String,
            let threadID = dictionary[Constants.Chat.threadID] as? String
            else { return nil }
                
        self.init( chatOwnerUID: chatOwnerUID,
                   blocked: blocked,
                   lastMsg: lastMsg,
                   lastMsgTimestamp: lastMsgTimestamp,
                   askerUID: askerUID,
                   askerFirstName: askerFirstName,
                   askerLastName: askerLastName,
                   askerPhotoURL: askerPhotoURL,
                   postID: postID,
                   postTitle: postTitle,
                   postOwnerUID: postOwnerUID,
                   postOwnerFirstName: postOwnerFirstName,
                   postOwnerLastName: postOwnerLastName,
                   postOwnerPhotoURL: postOwnerPhotoURL,
                   threadID: threadID )
        
//        self.fetchPost(postID: postID)
//        self.fetchPostOwner(postOwnerUID: postOwnerUID)
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
