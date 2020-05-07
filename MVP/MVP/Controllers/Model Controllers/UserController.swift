//
//  UserController.swift
//  MVP
//
//  Created by Theo Vora on 5/7/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore



class UserController {
    // MARK: - Shared Instance
    
    static let shared = UserController()
    
    
    // MARK: - Constants
    
    static let kUserCollection = "usersV2"
    
    
    // MARK: - Properties
    
    private let dbRef = Firestore.firestore().collection(kUserCollection)
    var userToReturn: User? = nil
    
    
    // MARK: - CRUD
    
    func fetchUser(fromUid: String) {
        guard !fromUid.isEmpty else { return }
        
        let query = dbRef.whereField("uid", isEqualTo: fromUid)
        
        print("=== fetchUser ===")
        print("1. Entering getDocument closure")
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("2. Error in fetchUser.")
                print(error)
            } else {
                if let snapshot = snapshot,
                    !snapshot.isEmpty,
                    let doc = snapshot.documents.first,
                    let user = User(dictionary: doc.data()) {
                    
                    self.userToReturn = user
                    print("2. Fetched user: \(user.firstName)")
                    
                }
            }
        }
    }
}
