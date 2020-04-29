//
//  Post.swift
//  MVP
//
//  Created by David on 4/27/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

public struct DummyPost: Codable {
    let postTitle: String
    let postDescription: String
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
