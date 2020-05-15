//
//  ChatListItem.swift
//  MVP
//
//  Created by Theo Vora on 5/8/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import FirebaseFirestore

/// ChatListItem contains all the information required by a tableview cell in ChatListTableViewController
struct ChatListItem {
    var chatRef: DocumentReference
    var otherUser: User
    var chat: Chat
    var lastMsg: String
    var lastTime: String
}

extension ChatListItem {
    
//    static func createWith( chat: Chat,
//                            chatRef: DocumentReference,
//                            completion: @escaping (ChatListItem) -> Void ) {
//
//        if let otherUserUID = chat.otherUserUID {
//            print("#ChatListItem 1. getting user")
//            User.getBy(uid: otherUserUID) { (user) in
//                print("#ChatListItem 2. appending \(user.firstName) to User Dictionary ")
//
//                ChatListController.shared.addUser(user)
//
//                print("#ChatListItem 3. creating ChatListItem")
//                let chatListItem = ChatListItem(
//                    chatRef: chatRef,
//                    otherUser: user,
//                    chat: chat,
//                    lastMsg: chat.lastMsg ?? "",
//                    lastTime: chat.lastTime?.description ?? "")
//                print("#ChatListItem 4. ChatListItem created!")
//                completion(chatListItem)
//            }
//        } else {
//            print("ERROR: #ChatListItem failed to get otherUser.")
//        }
//    }
}
