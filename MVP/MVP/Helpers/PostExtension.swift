//
//  PostExtension.swift
//  MVP
//
//  Created by Theo Vora on 5/16/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DummyPost {
    
    convenience init?(dictionary: [String:Any]) {
        guard let postTitle = dictionary["postTitle"] as? String,
            let postDescription = dictionary["postDescription"] as? String,
            let userUID = dictionary["postUserUID"] as? String,
            let postUserFirstName = dictionary["postUserFirstName"] as? String,
            let postDocumentID = dictionary["postDocumentID"] as? String,
            let postCreatedTimestamp = dictionary["postCreatedTimestamp"] as? String,
            let category = dictionary["category"] as? String,
            let postImageURL = dictionary["postImageURL"] as? String,
            let postFlaggedCount = dictionary["postFlaggedCount"] as? Int,
            let postLongitude = dictionary["postLongitude"] as? Double,
            let postLatitude = dictionary["postLatitude"] as? Double
            else {return nil}
        
        self.init( postTitle: postTitle,
                   postDescription: postDescription,
                   userUID: userUID,
                   postUserFirstName: postUserFirstName,
                   postDocumentID: postDocumentID,
                   postCreatedTimestamp: postCreatedTimestamp,
                   category: category,
                   postImageURL: postImageURL,
                   postFlaggedCount: postFlaggedCount,
                   postLongitude: postLongitude,
                   postLatitude: postLatitude )
    }
    
    static func getBy(docID: String, completion: @escaping (Result<DummyPost,PostError>) -> Void) {
        Firestore.firestore().collection("postsV3.1")
            .getDocuments { (querySnap, error) in
                if let error = error {
                    print("#Post.getBy could not retrieve post. Maybe deleted?")
                    print(error)
                    return completion(.failure(.notFound))
                }
                
                guard let snapshot = querySnap,
                    !snapshot.isEmpty,
                    let data = snapshot.documents.first?.data() else {
                        print("#Post.getBy said there was no error, but returned no data. I blame Firestore.")
                        return completion(.failure(.noData))
                }
                
                if let post = DummyPost(dictionary: data) {
                    return completion(.success(post))
                }
        }
    }
}
