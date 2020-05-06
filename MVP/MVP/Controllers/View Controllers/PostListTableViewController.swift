//
//  PostListTableViewController.swift
//  MVP
//
//  Created by Anthroman on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

class PostListTableViewController: UITableViewController {
    
    var posts = [DummyPost]()
    var db: Firestore!
    
    @IBOutlet weak var postSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        db.collection("postsV2").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
                
            else {
                self.posts = []
                for document in querySnapshot!.documents {
                    
        let dummyPost = DummyPost(postTitle: document.data()["postTitle"] as! String,                  postDescription: document.data()["postDescription"] as! String,
                                  userUID: document.data()["postUserUID"] as! String, postUserFirstName: document.data()["postUserFirstName"] as! String, postDocumentID: "\(document.documentID)",
                    postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String)
                    
                    self.posts.append(dummyPost)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.postTitle
        cell.detailTextLabel?.text = post.postDescription
        
        return cell
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetailVC" {
            if let destinationVC = segue.destination as? PostDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let post = posts[indexPath.row]
                destinationVC.post = post
            }
        }
     }
     
    
}

