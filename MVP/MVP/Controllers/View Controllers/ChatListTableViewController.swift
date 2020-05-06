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
    
    // MARK: - Properties
    
    var currentUser = Auth.auth().currentUser!
    var userUids: [String] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadConversations()
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userUids.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        cell.textLabel?.text = userUids[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - Helper Functions
    
    func loadConversations() {
        let query = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: currentUser.uid)
        
        query.getDocuments { (convoQuerySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                guard let snapshot = convoQuerySnapshot,
                    !snapshot.isEmpty
                    else { return }
                
                
                for doc in snapshot.documents {
                    guard let chat = Chat(dictionary: doc.data()),
                    let otherUserUid = chat.fetchOtherUserUid()
                        else { return }
                    
                    print("appending " + otherUserUid)
                    self.userUids.append(otherUserUid)
                }
                self.tableView.reloadData()
            } // end else
        }
    } // end loadConversations
    
    
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
                let destinationVC = segue.destination as? ChatViewController
                else { return }
            
            let user2uid = userUids[indexPath.row]
            destinationVC.user2UID = user2uid
        }
    }
    
}
