//
//  OwnerProfileViewController.swift
//  WeShareStoryboards
//
//  Created by Anthroman on 5/7/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import UIKit
import Firebase

class OwnerProfileViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundDesign: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var myPosts = [DummyPost]()
       var db: Firestore!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            loadData()
        }
        
    
    func setupViews() {
        
        db = Firestore.firestore()

        if let firstName = CurrentUserController.shared.currentUser?.firstName, let lastName = CurrentUserController.shared.currentUser?.lastName {
            
            fullNameLabel.text = "\(firstName) \(lastName)"
            // emailLabel.text = "\(email)"
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.delegate = self
        containerView.isHidden = true
        tableView.isScrollEnabled = false
        
        if tableView.visibleCells.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "tableViewBackground"))
            tableView.separatorStyle = .none
        }
    }
    
    
    
    //MARK: - Actions
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func segmentedControlButtonTapped(_ sender: UISegmentedControl) {
        
        let getIndex = segmentedControl.selectedSegmentIndex
        
        if getIndex == 0 {
            containerView.isHidden = true
        } else {
            containerView.isHidden = false
        }
    }
    
    //MARK: - Helpers
    
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
                        postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String, category: document.data()["category"] as! String, postImageURL: document.data()["postImageURL"] as! String, postFlaggedCount: document.data()["flaggedCount"] as! Int)
    
                    
                    self.myPosts.append(dummyPost)
                    
                }
                self.tableView.reloadData()
                
                print("\n\nCOUNT OF POSTS: \(self.myPosts.count)\n\n")
                
            }
        }
    }


    
    //MARK: - TODO
    //This is supposed to tell the tableview when to scroll and when not to. Currently, it doesn't seem to work.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.tableView {
            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
        }
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        presentDeleteAccountAlert()
    }
    
    func presentDeleteAccountAlert() {
        
        let title = "Are you sure you want to delete your account?"
        let message = "This action cannot be undone. You will lose all data from your account."
        let cancelActionTitle = "Cancel"
        let deleteActionTitle = "Delete Account"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: deleteActionTitle, style: .cancel, handler: { (_) in
            
            let user = Auth.auth().currentUser
            
            user?.delete { error in
                if let error = error {
                    print("error deleting account")
                    print(error.localizedDescription)
                } else {
                    print("account deleted")
                }
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension OwnerProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myPosts.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPostCell", for: indexPath) as? MyPostsTableViewCell else {return UITableViewCell()}
        
        let myPost = myPosts[indexPath.row]
        cell.myPost = myPost
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMyPostDetail" {
            if let destinationVC = segue.destination as? MyPostDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
                let myPost = myPosts[indexPath.row]
                destinationVC.myPost = myPost
            }
        }
    }

    
}
