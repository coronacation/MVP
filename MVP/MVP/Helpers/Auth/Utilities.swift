//
//  Utilities.swift
//  MVP
//
//  Created by David on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class Utilities {
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[_;:@$#!%*?&<>])[A-Za-z\\d_;:@$#!%*?&<>]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

struct Constants {
    
    struct Chat {
        static let collectionL1 = "ChatsV2"
        static let collectionL2 = "chats"
        
        static let chatOwnerUID = "chatOwnerUID"
        static let blocked = "blocked"
        static let lastMsg = "lastMsg"
        static let lastMsgTimestamp = "lastMsgTimestamp"
        static let askerUID = "askerUID"
        static let askerFirstName = "askerFirstName"
        static let askerLastName = "askerLastName"
        static let askerPhotoURL = "askerPhotoURL"
        static let postID = "postID"
        static let postTitle = "postTitle"
        static let postOwnerUID = "postOwnerUID"
        static let postOwnerFirstName = "postOwnerFirstName"
        static let postOwnerLastName = "postOwnerLastName"
        static let postOwnerPhotoURL = "postOwnerPhotoURL"
        static let threadID = "threadID"
    }
    
    struct Message {
         static let content = "content"
         static let created = "created"
         static let senderID = "senderID"
    }
    
    struct Post {
        static let collection = "postsV3.1"
        
        static let title = "postTitle"
        static let description = "postDescription"
        static let userUID = "postUserUID"
        static let userFirstName = "postUserFirstName"
        static let userLatitude = "postUserLatitude"
        static let userLongitude = "postUserLongitude"
        static let createdTimestamp = "postCreatedTimestamp"
        static let imageURL = "postImageURL"
        static let category = "category"
        static let flaggedCount = "flaggedCount"
    }
    
    struct Storyboard {
        
        static let tabBarViewController = "TabBarVC"
        
    }
    
    struct Thread {
        static let collectionL1 = "Threads"
        static let collectionL2 = "messages"
        
        static let postID = "postID"
        static let postOwnerUID = "postOwnerUID"
        static let askerUID = "askerUID"
    }
}
