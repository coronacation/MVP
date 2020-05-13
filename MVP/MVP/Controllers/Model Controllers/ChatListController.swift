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
    
    //    private let chatsCollection = Firestore.firestore().collection("Chats")
    private let chatsCollection = Firestore.firestore().collection("ChatsV2")
    
    
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
    
    func createNewChat( postOwnerUid: String,
                        postText: String,
                        completion: @escaping (DocumentReference) -> Void ) {
        
        // 1. get currentUser's UID
        
        guard let currentUserUid = currentUser?.userUID else { return }
        
        // 2. Build the structure for this ChatListItem Object
        
        let data: [String: Any] = [
            "offer": postText,
            "offerOwner": postOwnerUid,
            "blocked": false,
        ]
        
        // 3. Add chat document for currentUser in the db under Chats
        // 3.1 Do not send postOwner a message yet until currentUser actually sends a message
        // 3.2 Name the document after the currentUser's UID
        
        let chatDocRef: DocumentReference = chatsCollection.document(currentUserUid)
            .collection("conversations")
            .addDocument(data: data) { (error) in
                if let error = error {
                    print("#ChatListController: Unable to create chat! \(error)")
                    return
                }
        }
        
        completion(chatDocRef)
    }
    
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
    
    func updateLastMsg(chatListItem: ChatListItem, lastMsgDocRef: DocumentReference, messageText: String, messageTime: Timestamp) {
        
        // update local ChatListItem
        var tempItem = chatListItem
        tempItem.lastMsg = messageText
        tempItem.lastTime = messageTime.description
        
        
        // update Firestore
        
        let chatRef = chatListItem.chatRef
        let data: [String : Any] = [ "lastMsgDocRef" : lastMsgDocRef,
                                     "lastMsg" : messageText,
                                     "lastTime" : messageTime ]
        
        chatRef.updateData(data) { (error) in
            if let error = error {
                print("#ChatListItem: Error in updateLastMsg: \(error)")
            }
        }
    }
}
