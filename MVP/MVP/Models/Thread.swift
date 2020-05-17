//
//  Thread.swift
//  MVP
//
//  Created by Theo Vora on 5/16/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

struct Thread {
    
    // MARK: - Properties shared with Firestore
    
    var postID: String
    var postOwnerUID: String
    var askerUID: String
    
    
    // MARK: - Computed Properties
    
    var dictionary: [String: Any] {
        get {
            return [
                Constants.Thread.postID: postID,
                Constants.Thread.postOwnerUID: postOwnerUID,
                Constants.Thread.askerUID: askerUID,
            ]
        }
    }
}
