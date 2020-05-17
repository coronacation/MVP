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
    
    
    // MARK: - Shared Instance
    
    static let shared = ChatThreadController()
    
    
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
    
    // func fetchThread( threadID: String )
    
    
    // MARK: - Helpers
    
    
}
