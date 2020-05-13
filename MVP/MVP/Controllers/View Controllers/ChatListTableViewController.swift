//
//  ChatListTableViewController.swift
//  MVP
//
//  Created by Theo Vora on 5/2/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ChatListController.shared.startListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ChatListController.shared.stopListener()
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let postTitle = "Hairspray"
        let postOwnerUid = "MLzB7miXJFhUhm7dcpJNvaSDPJx2" // Theo
//        let postOwnerUid = "1hYi1aKFAGfzap7fUGxcA2GJIZF3") // Abigail
//        let postOwnerUid = "2husJkuElXUWZTHumtvyj4V6Dvy1") // Natasha
        
        ChatListController.shared.createNewChat(postOwnerUid: postOwnerUid, postText: postTitle) { (docRef) in
            // 1. create new ChatList Item
            
            print(docRef.documentID)
            
            // 2. append it to the local array
            
            
            
            // 3. Create a document in db under Threads
            //                ThreadController.shared.createThread(chatDocRef: chatDocRef)
            
            
            // 4. Segue to the ChatDetailVC and set the convo title
        }
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatListController.shared.chats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        cell.textLabel?.text = ChatListController.shared.chats[indexPath.row].otherUser.firstName
        
        cell.detailTextLabel?.text = ChatListController.shared.chats[indexPath.row].lastMsg
        
        return cell
    }
    
    
    // MARK: - Conversations data source
        
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
    
    // MARK: - Navigation
    
    // toChatVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        
        
        if segue.identifier == "toChatVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                //                let destinationVC = segue.destination as? ChatViewController
                let destinationVC = segue.destination as? ChatDetailViewController
                else { return }
            
            let user2 = ChatListController.shared.chats[indexPath.row].otherUser
            
            let chatListItem = ChatListController.shared.chats[indexPath.row]
            
            destinationVC.user2Object = user2
            destinationVC.chatListItem = chatListItem
        }
    }
    
}
