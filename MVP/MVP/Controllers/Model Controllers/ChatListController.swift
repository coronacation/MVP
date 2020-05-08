//
//  ChatListController.swift
//  MVP
//
//  Created by Theo Vora on 5/8/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

class ChatListController {
    
    // MARK: - Shared Instance
    
    static let shared = ChatListController()
    
    
    // MARK: - Properties
    
    var chats: [ChatListItem] = []
    
    
    // MARK: - CRUD
    
//    func loadChats() {
//        print("Starting loadChats()")
//        
//        let group = DispatchGroup()
//        
//        for chatRef in chatRefs {
//            group.enter()
//            Chat.getBy(docRef: chatRef, completion: { (chat) in
//                self.chats.append(chat)
//                print("Chat List appended: \(String(describing: chat.otherUserUid))")
//                group.leave()
//            })
//        }
//                
//        group.notify(queue: .main) {
//            print("~~Reloading Chat List tableview~~")
//            self.tableView.reloadData()
//        }
//    }
}
