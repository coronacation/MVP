//
//  File.swift
//  MVP
//
//  Created by David on 4/27/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import CoreLocation

struct CurrentUser {
    var firstName: String
    var lastName: String
    var email: String
    let userUID: String
    var location: CLLocation? = nil
    
    var fullName: String {
        get {
            return firstName + " " + lastName
        }
    }
    
    //will be adding profile photo
    var photoURL: URL = URL(string: "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/batman_hero_avatar_comics-512.png")!
}

class User {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
  //  var profileImageData = Data?
   // var profileImage = UIImage?

// not clear on how best to save this? let FB generate the ID?
    var savedPosts = [Post]()
 //   var DMs = [Conversation]()
    var flaggedCount: Int = 0
    var blockedUsers = [User]()
//    var zipCode: Int?
//    var streetAddress: String?
    var location: CLLocation?
    
    var fullName: String {
        get {
            return firstName + " " + lastName
        }
    }
    
    init(uid: String, firstName: String, lastName: String, email: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
