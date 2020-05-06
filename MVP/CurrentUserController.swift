//
//  CurrentUserController.swift
//  MVP
//
//  Created by David on 5/5/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

class CurrentUserController {
    
    static let shared = CurrentUserController()
    
    var currentUser: CurrentUser?
    
    //this function sets the current user once they create a new account
    func setCurrentUserFromSignUp(firstName: String, lastName: String, email: String, userUID: String) {
        self.currentUser = CurrentUser(firstName: firstName, lastName: lastName, email: email, userUID: userUID)
    }
    
    //this function will be run if a current user logs in on a new device
    func setCurrentUserFromLogin(firstName: String, lastName: String, email: String, userUID: String) {
        self.currentUser = CurrentUser(firstName: firstName, lastName: lastName, email: email, userUID: userUID)
    }
    
}
