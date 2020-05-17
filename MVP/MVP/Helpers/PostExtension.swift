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
    
    convenience init?(dictionary: [String:Any], postID: String) {
        guard let postTitle = dictionary[Constants.Post.title] as? String,
            let postDescription = dictionary[Constants.Post.description] as? String,
            let userUID = dictionary[Constants.Post.userUID] as? String,
            let postUserFirstName = dictionary[Constants.Post.userFirstName
] as? String,
            let postCreatedTimestamp = dictionary[Constants.Post.createdTimestamp] as? String,
            let category = dictionary[Constants.Post.category] as? String,
            let postImageURL = dictionary[Constants.Post.imageURL] as? String,
            let postFlaggedCount = dictionary[Constants.Post.flaggedCount] as? Int,
            let postLongitude = dictionary[Constants.Post.userLongitude] as? Double,
            let postLatitude = dictionary[Constants.Post.userLatitude] as? Double
            else {return nil}
        
        self.init( postTitle: postTitle,
                   postDescription: postDescription,
                   userUID: userUID,
                   postUserFirstName: postUserFirstName,
                   postDocumentID: postID,
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
                
                if let post = DummyPost(dictionary: data, postID: docID) {
                    return completion(.success(post))
                }
        }
    }
}
