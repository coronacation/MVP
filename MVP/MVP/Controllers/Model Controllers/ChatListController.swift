//
//  ChatListController.swift
//  MVP
//
//  Created by Theo Vora on 5/8/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChatListController {
    
    // MARK: - Constants
    
    private let chatsCollection = Firestore.firestore().collection("Chats")
    
    
    // MARK: - Shared Instance
    
    static let shared = ChatListController()
    
    
    // MARK: - Properties
    
    var currentUser: CurrentUser? {
        didSet {
            guard let currentUser = currentUser else { return }
            let userUID = currentUser.userUID
            self.fetchChatsOfCurrentUser(userUID)
            usersDictionary[userUID] = currentUser.firstName
        }
    }
    var chats: [ChatListItem] = []
    
    /// usersDictionary enables fast lookup of a user's firstName. key = UID. value = firstName.
    var usersDictionary: [String:String] = [:]
    
    
    // MARK: - CRUD
    
    func fetchChatsOfCurrentUser(_ currentUserUID: String) {
        let query = chatsCollection
            .whereField("userUids", arrayContains: currentUserUID)
        
        query.getDocuments { (convoQuerySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                guard let snapshot = convoQuerySnapshot,
                    !snapshot.isEmpty
                    else { return }
                
                
                for doc in snapshot.documents {
                    guard let chat = Chat(dictionary: doc.data()) else { return }
                    
                    ChatListItem.createWith(chat: chat, chatRef: doc.reference) { (chatListItem) in
                        self.chats.append(chatListItem)
                        print("#ChatListController 5. appended ChatListItem")
                        
                    }
                } //end for
            } // end else
        }
    } // end fetchChatsOfCurrentUser
    
    func addUser(_ user: User) {
        usersDictionary[user.uid] = user.firstName
    }
}
