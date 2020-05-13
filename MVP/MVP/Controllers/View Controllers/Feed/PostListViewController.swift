//
//  PostListTableViewController.swift
//  MVP
//
//  Created by Anthroman on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

class PostListViewController: UIViewController {
    
    var posts = [DummyPost]()
    var db: Firestore!
    
    @IBOutlet weak var postSearchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        db.collection("postsV3.1").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
                
            else {
                self.posts = []
                for document in querySnapshot!.documents {
                    
                    let dummyPost = DummyPost(postTitle: document.data()["postTitle"] as! String,                  postDescription: document.data()["postDescription"] as! String,
                                              userUID: document.data()["postUserUID"] as! String, postUserFirstName: document.data()["postUserFirstName"] as! String, postDocumentID: "\(document.documentID)",
                        postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String, category: document.data()["category"] as! String, postImageURL: document.data()["postImageURL"] as! String, postFlaggedCount: document.data()["flaggedCount"] as! Int)
                    
                    //                    PostController.fetchPostImage(stringURL: dummyPost.postImageURL) { (result) in
                    //                                 DispatchQueue.main.async {
                    //                                     switch result {
                    //                                     case .success(let image):
                    //                                         dummyPost.postUIImage = image
                    //                                        print("success pulling image/n")
                    //                                     case .failure(let error):
                    //                                         print(error.errorDescription!)
                    //                                         dummyPost.postUIImage = #imageLiteral(resourceName: "noImageAvailable")
                    //                                     }
                    //                                 }
                    //                             }
                    
                    self.posts.append(dummyPost)
                    
                }
                self.table.reloadData()
                
                print("\n\nCOUNT OF POSTS: \(self.posts.count)\n\n")
                
            }
        }
    }
    
 
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return posts.count
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         162
     }
     
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
         
         let post = posts[indexPath.row]
         cell.post = post
         
         return cell
     }
     
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toPostDetailVC" {
             if let destinationVC = segue.destination as? PostDetailViewController, let indexPath = table.indexPathForSelectedRow {
                 let post = posts[indexPath.row]
                 destinationVC.post = post
             }
         }
     }
    
}