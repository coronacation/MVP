//
//  File.swift
//  MVP
//
//  Created by David on 4/27/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import CoreLocation

class User {
  
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
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
}
