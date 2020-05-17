//
//  MyPostsTableViewController.swift
//  MVP
//
//  Created by David on 5/12/20.
//  Copyright © 2020 coronacation. All rights reserved.
//






//DO NOT USE THIS. THIS IS NOT HOOKED UP TO ANYTHING










import UIKit
import Firebase
import MapKit
import CoreLocation

class MyPostsListTableViewController: UITableViewController {
    
    var myPosts = [DummyPost]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        print("FUCK ME\n\n")
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
                self.myPosts = []
                for document in querySnapshot!.documents {
                    
                    let dummyPost = DummyPost(postTitle: document.data()["postTitle"] as! String,                  postDescription: document.data()["postDescription"] as! String,
                                              userUID: document.data()["postUserUID"] as! String, postUserFirstName: document.data()["postUserFirstName"] as! String, postDocumentID: "\(document.documentID)",
                        postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String, category: document.data()["category"] as! String, postImageURL: document.data()["postImageURL"] as! String, postFlaggedCount: document.data()["flaggedCount"] as! Int, postLongitude: document.data()["postUserLongitude"] as! Double, postLatitude: document.data()["postUserLatitude"] as! Double, postCLLocation: CLLocation(latitude: document.data()["postUserLatitude"] as! Double, longitude: document.data()["postUserLongitude"] as! Double))
                    
                    self.myPosts.append(dummyPost)
                    
                }
                self.tableView.reloadData()
                
                print("\n\nCOUNT OF POSTS: \(self.myPosts.count)\n\n")
                
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        162
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPostCell", for: indexPath) as? MyPostsTableViewCell else {return UITableViewCell()}
        
        let myPost = myPosts[indexPath.row]
        cell.myPost = myPost
        print("\n\nmyPost assigned to cell. title: \(myPost.postTitle)")
        return cell
    }
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\n\nSegue running")
           if segue.identifier == "toMyPostDetailVC" {
               if let destinationVC = segue.destination as? MyPostDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                   let myPost = myPosts[indexPath.row]
                print("myPost for segue title: \(myPost.postTitle)")
                   destinationVC.myPost = myPost
               }
           }
       }
}
