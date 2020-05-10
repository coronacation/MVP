//
//  UserExtension.swift
//  MVP
//
//  Created by Theo Vora on 5/7/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension User {
    
    convenience init?(dictionary: [String:Any]) {
        guard let uid = dictionary["uid"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let email = dictionary["email"] as? String
            else {return nil}
        self.init(uid: uid, firstName: firstName, lastName: lastName, email: email)
    }
    
    static func getBy(uid: String, completion: @escaping (User) -> Void) {
        let dbRef = Firestore.firestore().collection("usersV2")
        
        let query = dbRef.whereField("uid", isEqualTo: uid)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot,
                let data = snapshot.documents.first?.data(),
                let user = User(dictionary: data) else {
                print("Could not get user: \(error.debugDescription)")
                return
            }
            completion(user)
        }
    }
}
