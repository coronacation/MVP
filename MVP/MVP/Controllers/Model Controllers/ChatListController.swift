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
    
    var chats: [Chat] = []
    var listener: ListenerRegistration? = nil
    var currentUser: CurrentUser? {
        didSet {
            guard let currentUser = currentUser else { return }
            let userUID = currentUser.userUID
            //            self.fetchChatsOfCurrentUser(userUID)
            usersDictionary[userUID] = currentUser.firstName
        }
    }
    
    /// usersDictionary enables fast lookup of a user's firstName. key = UID. value = firstName.
    var usersDictionary: [String:String] = [:]
    
    
    // MARK: - CRUD
    
    func firstMessage( regarding post: DummyPost,
                       firstMessage: String,
                       completion: @escaping (Bool) -> Void ){
        
        // 1. get currentUser's UID
        guard let currentUserUid = currentUser?.userUID else { return }
        
        // grab post properties
        let postOwnerUID = post.userUID, postID = post.postDocumentID
        
        // check for existing message to prevent spam
        // if alreadyMessaged(regarding: post, fromUserUID: currentUserUid)
        alreadyMessaged(regarding: post, fromUserUID: currentUserUid, completion: { (alreadySentMsg) in
            if alreadySentMsg {
                print("#firstMessage: you can't message again")
                completion(false)
            } else {
                print("#firstMessage: no existing message. you can continue")
                
                // createChats for each user
                self.createNewChat(chatOwnerUID: currentUserUid, otherUserUID: postOwnerUID, postOwnerUID: postOwnerUID, postID: postID) {
                    print("#createNewChat for currentUser who is interested in post")
                }
                
                self.createNewChat(chatOwnerUID: postOwnerUID, otherUserUID: currentUserUid, postOwnerUID: postOwnerUID, postID: postID) {
                    print("#createNewChat for post Owner")
                }
                completion(true)
            }
        })
        
        
        
        // TO-DO: updateLastMsg
        
    }
    
    func createNewChat( chatOwnerUID: String,
                        otherUserUID: String,
                        postOwnerUID: String,
                        postID: String,
                        completion: @escaping () -> Void) {
        
        
        
        // 2. Build the structure for this ChatListItem Object
        
        let data: [String: Any] = [
            "postOwnerUID": postOwnerUID,
            "blocked": false,
            "otherUserUID": otherUserUID
        ]
        
        // 3. Add chat document for currentUser in the db under Chats
        // 3.1 Do not send postOwner a message yet until currentUser actually sends a message
        // 3.2 Name the document after the currentUser's UID
        
        chatsCollection.document(chatOwnerUID)
            .collection("posts").document(postID)
            .setData(data, merge: false, completion: { (error) in
                if let error = error {
                    print("#ChatListController: Unable to create chat! \(error)")
                    return
                }
                completion()
            })
    }
    
    func startListener( completion: @escaping () -> Void ) {
        guard let currentUserUid = currentUser?.userUID else { return }
        
        self.listener = chatsCollection.document(currentUserUid)
            .collection("conversations").order(by: "offer", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("#ChatListController: Error fetching conversations: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { (diff) in
                    switch diff.type {
                    case .added:
                        print("New chat: \(diff.document.data())")
                        if let chat = Chat(dictionary: diff.document.data()) {
                            self.chats.insert(chat, at: 0)
                        }
                    case .modified:
                        print("Modified chat: \(diff.document.data())")
                    case .removed:
                        print("Removed chat: \(diff.document.data())")
                    }
                }
                completion()
        }
    }
    
    func stopListener() {
        guard let listener = listener else { return }
        listener.remove()
        self.chats = []
        print("#ChatListController stopped listening")
    }
    
    func fetchChatsOfCurrentUser(_ currentUserUID: String) {
        guard let currentUserUid = currentUser?.userUID else { return }
        
        chatsCollection.document(currentUserUid)
            .collection("conversations")
            .getDocuments { (convoQuerySnapshot, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                } else {
                    
                    guard let snapshot = convoQuerySnapshot,
                        !snapshot.isEmpty
                        else {
                            print("#fetchChatsOfCurrentUser no chats found.")
                            return
                    }
                    
                    
                    for doc in snapshot.documents {
                        guard let chat = Chat(dictionary: doc.data()) else {
                            print("#fetchChatsOfCurrentUser failed to init Chat")
                            return
                        }
                        
                        self.chats.append(chat)
                    } //end for
                    print("#fetchChatsOfCurrentUser 1. Built chats")
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
    
    // MARK: - Helpers
    
    func alreadyMessaged( regarding post: DummyPost,
                          fromUserUID: String,
                          completion: @escaping (Bool) -> Void ) {
        
        let postID = post.postDocumentID
        
        chatsCollection.document(fromUserUID).collection("posts").document(postID).getDocument { (docSnapshot, error) in
            if let error = error {
                print("#alreadyMessaged error: \(error)")
            } else {
                completion(docSnapshot!.exists)
            }
        }
    }
}
