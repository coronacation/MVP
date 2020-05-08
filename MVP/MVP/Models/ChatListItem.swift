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
    let otherUser: User
    let chat: Chat
    let lastMsg: String
    let lastTime: String
    let lastTimestamp: Timestamp
    let chatRef: DocumentReference
}
