//
//  Chat.swift
//  MVP
//
//  Created by Theo Vora on 5/1/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Chat {
    var offer: String
    var offerOwner: String
    var blocked: Bool
    //    var lastMsg: String?
    //    var lastMsgDate: Date
}

extension Chat {
    
    /// Initializer for Chat objects coming from Firestore
    /// - Parameter dictionary: key/value pairs of a chat object. With Firestore, you can simply pass in DocumentRef.data().
    init?(dictionary: [String:Any]) {
        
        guard let offer = dictionary["offer"] as? String,
            let offerOwner = dictionary["offerOwner"] as? String,
            let blocked = dictionary["blocked"] as? Bool
            else { return nil }
        
        self.init(offer: offer,
                  offerOwner: offerOwner,
                  blocked: blocked)
    }
    
}

