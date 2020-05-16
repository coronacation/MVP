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
        alreadyMessaged(postID: postID, fromUserUID: currentUserUid, completion: { (alreadySentMsg) in
            if alreadySentMsg {
                // print("#firstMessage: you can't message again")
                completion(false)
            } else {
                
                // create Thread
                ChatThreadController.shared.createThread(senderUID: currentUserUid, text: firstMessage) { (threadDocID, timestamp) in
                    print("#alreadyMessaged received threadDocID: " + threadDocID)
                    
                    // create Chat for currentUser
                    self.createNewChat(chatOwnerUID: currentUserUid, otherUserUID: postOwnerUID, postOwnerUID: postOwnerUID, postID: postID, threadID: threadDocID, lastMsg: firstMessage, lastMsgTimestamp: timestamp) { (chatDocID) in
                        print("created \(chatDocID)")
                    }
                    
                    //create Chat for post Owner
                    self.createNewChat(chatOwnerUID: postOwnerUID, otherUserUID: currentUserUid, postOwnerUID: postOwnerUID, postID: postID, threadID: threadDocID, lastMsg: firstMessage, lastMsgTimestamp: timestamp) { (chatDocID) in
                        print("created \(chatDocID)")
                    }
                    
                    completion(true)
                }
                
                
            }
        })
        
        
        
        // TO-DO: updateLastMsg
        
    }
    
    private func createNewChat( chatOwnerUID: String,
                        otherUserUID: String,
                        postOwnerUID: String,
                        postID: String,
                        threadID: String,
                        lastMsg: String,
                        lastMsgTimestamp: Timestamp,
                        completion: @escaping (String) -> Void) {
        
        
        
        // 2. Build the structure for this ChatListItem Object
        
        let data: [String: Any] = [
            "postID": postID,
            "postOwnerUID": postOwnerUID,
            "blocked": false,
            "otherUserUID": otherUserUID,
            "threadID": threadID,
            "lastMsg": lastMsg,
            "lastMsgTimestamp": lastMsgTimestamp
        ]
        
        // 3. Add chat document named after the User in the db under root-level collection "Chats"
        // 3.1 Add subcollection under User document called "chats"
        // 3.2 Under "chats" add document with the threadID.
        
        let chatDocRef = chatsCollection.document(chatOwnerUID)
            .collection("chats").document(threadID)
        
        chatDocRef.setData(data, merge: false, completion: { (error) in
            if let error = error {
                print("#ChatListController: Unable to create chat! \(error)")
                return
            }
        })
        
        completion(chatDocRef.documentID)
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
    
    func alreadyMessaged( postID: String,
                          fromUserUID: String,
                          completion: @escaping (Bool) -> Void ) {
        
        chatsCollection.document(fromUserUID).collection("chats")
            .whereField("postID", isEqualTo: postID)
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("#alreadyMessaged error: \(error)")
            } else {
                querySnapshot!.isEmpty ? completion(false) : completion (true)
            }
        }
    }
}
