//
//  ChatThreadController.swift
//  MVP
//
//  Created by Theo Vora on 5/15/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChatThreadController {
    
    // MARK: - Constants
    
    private let threadsCollection = Firestore.firestore().collection(Constants.Thread.collectionL1)
    private let currentUser = CurrentUserController.shared.currentUser
    
    
    // MARK: - Shared Instance
    
    static let shared = ChatThreadController()
    
    
    // MARK: - Properties
    
    var messages: [Message] = []
    
    private var listener: ListenerRegistration? = nil
    
    
    // MARK: - CRUD
    
    func createThread( postID: String,
                       postOwnerUID: String,
                       askerUID: String,
                       text: String,
                       completion: @escaping (String, Timestamp) -> Void ) {
        
        let data: [String: Any] = Thread(postID: postID, postOwnerUID: postOwnerUID, askerUID: askerUID).dictionary
        
        let threadDocID = threadsCollection.addDocument(data: data)
    
        createMessage(threadID: threadDocID.documentID, askerUID: askerUID, text: text) { (timestamp) in
            
            
            
            
            completion(threadDocID.documentID, timestamp)
        }
    }
    
    func createMessage( threadID: String,
                        askerUID: String,
                        text: String,
                        completion: @escaping (Timestamp) -> Void ) {
        
        let timestamp = Timestamp()
        
        
        
        let data: [String: Any] = Message(id: "", content: text, created: timestamp, senderID: askerUID).dictionary
        
        threadsCollection.document(threadID).collection(Constants.Thread.collectionL2)
        .addDocument(data: data)
        
        completion(timestamp)
    }
    
    func startListener( threadID: String, completion: @escaping () -> Void ) {
        
        self.listener = threadsCollection.document(threadID)
            .collection(Constants.Thread.collectionL2).order(by: Constants.Message.created, descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("#ChatThreadController: Error fetching messages: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { (diff) in
                    switch diff.type {
                    case .added:
                        print("New message: \(diff.document.data())")
                        
                        if let message = Message(dictionary: diff.document.data()) {
                            self.messages.append(message)
                        }
                    case .modified:
                        print("Modified message: \(diff.document.data())")
                    case .removed:
                        print("Removed message: \(diff.document.data())")
                    }
                }
                completion()
        }
    }
    
    func stopListener() {
        guard let listener = listener else { return }
        listener.remove()
        self.messages = []
        print("#ChatThreadController stopListener")
    }
    
    
    // MARK: - Helpers
    
    
}
