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
    
    private let threadsCollection = Firestore.firestore().collection("Threads")
    
    
    // MARK: - Shared Instance
    
    static let shared = ChatThreadController()
    
    
    // MARK: - CRUD
    
    func createThread( senderUID: String,
                       text: String,
                       completion: @escaping (String) -> Void ) {
        
        
        
        let threadDocID = threadsCollection.addDocument(data: [:])
        print("#createThread docID: " + threadDocID.documentID)
        completion(threadDocID.documentID)
        
        
        
//        createMessage(threadID: threadDocID.documentID, senderUID: senderUID, text: text) {
//        }
    }
    
    func createMessage( threadID: String,
                        senderUID: String,
                        text: String,
                        completion: @escaping () -> Void ) {
        let timestamp = Timestamp()
    }
    
    // func fetchThread( threadID: String )
    
}
