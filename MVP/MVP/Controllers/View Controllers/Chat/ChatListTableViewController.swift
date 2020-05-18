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
        ChatListController.shared.startListener {
            self.tableView.reloadData()            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ChatListController.shared.stopListener()
    }
    
    // MARK: - IBAction
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("add button tapped")
       
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
        
        cell.textLabel?.text = ChatListController.shared.chats[indexPath.row].otherUserFirstName
        
        cell.detailTextLabel?.text = ChatListController.shared.chats[indexPath.row].lastMsg + "\n" + ChatListController.shared.chats[indexPath.row].lastMsgTimeAgo
        
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
            
//            let user2 = ChatListController.shared.chats[indexPath.row].
            
//            let chatListItem = ChatListController.shared.chats[indexPath.row]
            
//            destinationVC.user2Object = user2
//            destinationVC.chatListItem = chatListItem
        }
    }
    
}
