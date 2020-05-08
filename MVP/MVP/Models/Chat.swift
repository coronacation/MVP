//
//  Chat.swift
//  MVP
//
//  Created by Theo Vora on 5/1/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

struct Chat {
    var userUids: [String]
    
    var dictionary: [String: Any] {
        
        return [
            "userUids": userUids
        ]
        
    }
    
    var otherUserUid: String? {
        guard let currentUserUid = CurrentUserController.shared.currentUser?.userUID,
            userUids.contains(currentUserUid)
            else { return nil }
        
        let otherUserUid = userUids[0] == currentUserUid ? userUids[1] : userUids[0]
        return otherUserUid
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let userUids = dictionary["userUids"] as? [String] else {return nil}
        
        self.init(userUids: userUids)
    }
    
    //    func fetchOtherUserUid() -> String? {
    //        let currentUserUid = Auth.auth().currentUser!.uid // TO-DO: replace with call to CurrentUserController
    //        guard userUids.contains(currentUserUid) else { return nil }
    //
    //        let otherUserUid = userUids[0] == currentUserUid ? userUids[1] : userUids[0]
    //        return otherUserUid
    //    }
    
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

