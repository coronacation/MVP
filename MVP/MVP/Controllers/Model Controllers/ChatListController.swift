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
    
    private let chatsCollection = Firestore.firestore().collection(Constants.Chat.collectionL1)
    
    
    // MARK: - Shared Instance
    
    static let shared = ChatListController()
    
    
    // MARK: - Properties
    
    var chats: [Chat] = []
    var currentUser: CurrentUser? {
        didSet {
            guard let currentUser = currentUser else { return }
            let userUID = currentUser.userUID
            //            self.fetchChatsOfCurrentUser(userUID)
            usersDictionary[userUID] = currentUser.firstName
        }
    }
    
    private var listener: ListenerRegistration? = nil
    
    /// usersDictionary enables fast lookup of a user's firstName. key = UID. value = firstName.
    var usersDictionary: [String:String] = [:]
    
    
    // MARK: - CRUD
    
    func initializeChat( regarding post: DummyPost,
                         firstMessage: String,
                         completion: @escaping (Bool) -> Void ){
        
        // get currentUser
        guard let currentUser = currentUser else {
            print("#initializeChat could not retrieve curentUser")
            return
        }
        
        
        
        
        let postOwnerUID = post.userUID
        
        User.getBy(uid: postOwnerUID) { (user) in
            // grab postOwner properties
            let postOwnerFirstName = user.firstName,
            postOwnerPhotoURL = "https://cdn0.iconfinder.com/data/icons/famous-character-vol-1-colored/48/JD-15-512.png" // Deadpool
            
            // grab currentUser's properties
            let askerFirstName = currentUser.firstName,
            askerLastName = currentUser.lastName,
            askerPhotoURL = currentUser.photoURL.absoluteString, // Batman
            currentUserUid = currentUser.userUID
            
            // grab post properties
            let postID = post.postDocumentID,
            postTitle = post.postTitle
            
            // check for existing message to prevent spam
            self.alreadyMessaged(postID: postID, fromUserUID: currentUserUid, completion: { (alreadySentMsg) in
                if alreadySentMsg {
                    completion(false) // user already sent a message
                } else {
                    
                    // create Thread
                    ChatThreadController.shared.createThread(postID: postID, postOwnerUID: postOwnerUID, askerUID: currentUserUid, text: firstMessage) { (threadDocID, timestamp) in
                        print("#alreadyMessaged received threadDocID: " + threadDocID)
                        
                        // create Chat for currentUser
                        self.createNewChat( chatOwnerUID: currentUserUid,
                                            askerUID: currentUserUid,
                                            askerFirstName: askerFirstName,
                                            askerLastName: askerLastName,
                                            askerPhotoURL: askerPhotoURL,
                                            postID: postID,
                                            postTitle: postTitle,
                                            postOwnerUID: postOwnerUID,
                                            postOwnerFirstName: postOwnerFirstName,
                                            postOwnerLastName: "",
                                            postOwnerPhotoURL: postOwnerPhotoURL,
                                            threadID: threadDocID,
                                            lastMsg: firstMessage,
                                            lastMsgTimestamp: timestamp )
                        
                        //create Chat for post Owner
                        self.createNewChat( chatOwnerUID: postOwnerUID,
                                            askerUID: currentUserUid,
                                            askerFirstName: askerFirstName,
                                            askerLastName: askerLastName,
                                            askerPhotoURL: askerPhotoURL,
                                            postID: postID,
                                            postTitle: postTitle,
                                            postOwnerUID: postOwnerUID,
                                            postOwnerFirstName: postOwnerFirstName,
                                            postOwnerLastName: "",
                                            postOwnerPhotoURL: postOwnerPhotoURL,
                                            threadID: threadDocID,
                                            lastMsg: firstMessage,
                                            lastMsgTimestamp: timestamp )
                        
                        completion(true)
                    }
                }
            })
        }
        
        
        // TO-DO: updateLastMsg
        
    }
    
    private func createNewChat( chatOwnerUID: String,
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
                                threadID: String,
                                lastMsg: String,
                                lastMsgTimestamp: Timestamp) {
        
        let data: [String: Any] = Chat( chatOwnerUID: chatOwnerUID,
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
                                        threadID: threadID ).dictionary
        
        // Add chat document named after the User in the db under root-level collection "Chats"
        // Add subcollection under User document called "chats"
        // Under "chats" add document with the threadID.
        
        let chatDocRef = chatsCollection.document(chatOwnerUID)
            .collection(Constants.Chat.collectionL2).document(threadID)
        
        chatDocRef.setData(data, merge: false, completion: { (error) in
            if let error = error {
                print("#ChatListController: Unable to create chat! \(error)")
                return
            }
        })
    }
    
    func startListener( completion: @escaping () -> Void ) {
        guard let currentUserUid = currentUser?.userUID else { return }
        
        self.listener = chatsCollection.document(currentUserUid)
            .collection(Constants.Chat.collectionL2).order(by: "lastMsgTimestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("#ChatListController: Error fetching conversations: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { (diff) in
                    switch diff.type {
                    case .added:
                        print("New chat: \(diff.document.data())")
                        
                        
                        // TO-DO this doesn't work. need to sequence it so Post and User get added in time before insert
                        
                        
                        
                        if let chat = Chat(dictionary: diff.document.data()) {
                            self.chats.append(chat)
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
    
    func addUser(_ user: User) {
        usersDictionary[user.uid] = user.firstName
    }
    
    func updateLastMsg( threadID: String,
                        askerUID: String,
                        postOwnerUID: String,
                        lastMsg: String,
                        lastMsgTimestamp: Timestamp ) {
        
        let lastMsgData: [String: Any] = [
            Constants.Chat.lastMsg: lastMsg,
            Constants.Chat.lastMsgTimestamp: lastMsgTimestamp
        ]
        
        // update asker
        chatsCollection.document(askerUID)
            .collection(Constants.Chat.collectionL2).document(threadID).updateData(lastMsgData)
        
        // update postOwner
        chatsCollection.document(postOwnerUID)
            .collection(Constants.Chat.collectionL2).document(threadID).updateData(lastMsgData)
    }
    
//    func updateLastMsg(chatListItem: ChatListItem, lastMsgDocRef: DocumentReference, messageText: String, messageTime: Timestamp) {
//
//        // update local ChatListItem
//        var tempItem = chatListItem
//        tempItem.lastMsg = messageText
//        tempItem.lastTime = messageTime.description
//
//
//        // update Firestore
//
//        let chatRef = chatListItem.chatRef
//        let data: [String : Any] = [ "lastMsgDocRef" : lastMsgDocRef,
//                                     "lastMsg" : messageText,
//                                     "lastTime" : messageTime ]
//
//        chatRef.updateData(data) { (error) in
//            if let error = error {
//                print("#ChatListItem: Error in updateLastMsg: \(error)")
//            }
//        }
//    }
    
    // MARK: - Helpers
    
    func alreadyMessaged( postID: String,
                          fromUserUID: String,
                          completion: @escaping (Bool) -> Void ) {
        
        chatsCollection.document(fromUserUID).collection(Constants.Chat.collectionL2)
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
