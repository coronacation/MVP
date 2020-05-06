//
//  Chat.swift
//  MVP
//
//  Created by Theo Vora on 5/1/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Chat {
    var users: [String] // user1, user2
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
    func fetchOtherUserUid() -> String? {
        let currentUserUid = Auth.auth().currentUser!.uid
        guard users.contains(currentUserUid) else { return nil }
        
        let otherUserUid = users[0] == currentUserUid ? users[1] : users[0]
        return otherUserUid
    }
    
    //    func fetchOtherUser() -> User? {
    //        let currentUserUid = Auth.auth().currentUser!.uid
    //        guard users.contains(currentUserUid) else { return nil }
    //
    //        let otherUserUid = users[0] == currentUserUid ? users[1] : users[0]
    //
    //        var userToReturn: User? = nil
    //
    //        let group = DispatchGroup()
    //
    //        group.enter()
    //        User.fetchUser(fromUid: otherUserUid) { (result) in
    //            switch result {
    //
    //            case .success(let user):
    //                userToReturn = user
    //                print("Inside closure. Got this user: " + userToReturn!.firstName)
    //                group.leave()
    //            case .failure(let error):
    //                print(error.errorDescription!)
    //            }
    //        }
    //        //        print("Outside closure. Got this user: " + userToReturn.firstName)
    //
    //        group.notify(queue: .main) {
    //            return userToReturn
    //        }
    //    }
}

