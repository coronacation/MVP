//
//  Post.swift
//  MVP
//
//  Created by David on 4/27/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

public class DummyPost {
    let postTitle: String
    let postDescription: String
    let userUID: String
    let postUserFirstName: String
    let postDocumentID: String
    let postCreatedTimestamp: String
    let category: String
    let postImageURL: String
    let postFlaggedCount: Int
    var postUIImage: UIImage = #imageLiteral(resourceName: "loading")
    let postLongitude: Double
    let postLatitude: Double
    
    init(postTitle: String, postDescription: String, userUID: String, postUserFirstName: String, postDocumentID: String,
         postCreatedTimestamp: String, category: String, postImageURL: String, postFlaggedCount: Int, postLongitude: Double, postLatitude: Double) {
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.userUID = userUID
        self.postUserFirstName = postUserFirstName
        self.postDocumentID = postDocumentID
        self.postCreatedTimestamp = postCreatedTimestamp
        self.category = category
        self.postImageURL = postImageURL
        self.postFlaggedCount = postFlaggedCount
        self.postLongitude = postLongitude
        self.postLatitude = postLatitude
    }
}

class Post {
    var title: String
    var description: String
  //  var imageURL: URL?
 //   let user: User
    var viewCount: Int = 0
    var saveCount: Int = 0
    var flagCount: Int = 0
    let dateCreated = Date()
    
    init(title: String, description: String, user: User) {
        self.title = title
        self.description = description
     //   self.user = User
    }
    
    // maybe add in the firebase UID for the initializer
    
}
