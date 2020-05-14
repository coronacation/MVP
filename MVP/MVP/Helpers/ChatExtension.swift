//
//  ChatExtension.swift
//  MVP
//
//  Created by Theo Vora on 5/8/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Chat {
    
    static func getBy(docRef: DocumentReference, completion: @escaping (Chat) -> Void) {
        
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot,
                docSnapshot.exists,
                let data = docSnapshot.data(),
                let chat = Chat(dictionary: data) else {
                    print("Could not get chat: \(error.debugDescription)")
                    return
            }
            completion(chat)
        }
    }
    
}
