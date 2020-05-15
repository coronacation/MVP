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
    var offer: String
    var offerOwner: String
    var blocked: Bool = false
    var blockedByUid: String?
    var otherUserUID: String {
        didSet {
            User.getBy(uid: otherUserUID) { (user) in
                self.otherUser = user
            }
        }
    }
    var otherUser: User?
    //    var lastMsg: String?
    //    var lastMsgDate: Date
    
    
    
    /// Default Initializer
    /// - Parameters:
    ///   - offer: Post Title
    ///   - offerOwner: Name of the user who made the Post
    ///   - blocked: true or false
    ///   - blockedByUid: UID of the user who initiated the block
    ///   - otherUserUID: UID of the user who is interested in the Post
    init(offer: String,
         offerOwner: String,
         blocked: Bool,
         blockedByUid: String? = nil,
         otherUserUID: String) {
        self.offer = offer
        self.offerOwner = offerOwner
        self.blocked = blocked
        self.blockedByUid = blockedByUid
        self.otherUserUID = otherUserUID
    }
}

extension Chat {
    
    /// Initializer for Chat objects coming from Firestore
    /// - Parameter dictionary: key/value pairs of a chat object. With Firestore, you can simply pass in DocumentRef.data().
    convenience init?(dictionary: [String:Any]) {
        
        guard let offer = dictionary["offer"] as? String,
            let offerOwner = dictionary["offerOwner"] as? String,
            let blocked = dictionary["blocked"] as? Bool,
            let otherUserUID = dictionary["otherUserUID"] as? String
            else { return nil }
        
        let blockedByUid = blocked ? dictionary["blockedByUid"] as? String : nil
        
        self.init(offer: offer,
                  offerOwner: offerOwner,
                  blocked: blocked,
                  blockedByUid: blockedByUid,
                  otherUserUID: otherUserUID)
    }
    
}

