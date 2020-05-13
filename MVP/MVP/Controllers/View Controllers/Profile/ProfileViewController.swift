//
//  ProfileViewController.swift
//  MVP
//
//  Created by David on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    var myPosts = [DummyPost]()
    var db: Firestore!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        setUpViews()
    }
    
    
    //MARK: - Actions
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        presentSettingsActionSheet()
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
    }//end of segmentedControlButtonTapped func
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        presentDeleteAccountAlert()
    }
    
    //MARK: - Helpers
    func setUpViews() {
        print("setup views triggered")
        guard let currentUser = CurrentUserController.shared.currentUser else {return}
        
        //profilePicture.image = currentUser.profilePicture
        fullNameLabel.text = currentUser.fullName
        //ageLabel.text = "\(currentUser.age)"
        //locationLabel.text = currentUser.cityLocation
        //workLabel.text = currentUser.work
        //bioLabel = currentUser.bio
        print("labels assigned")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.delegate = self
        containerView.isHidden = true
        tableView.isScrollEnabled = false
        
        if tableView.visibleCells.count == 0 {
            tableView.backgroundView = UIImageView(image: UIImage(named: "tableViewBackground"))
            tableView.separatorStyle = .none
        }//end of setTVCBackground stuff
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
                        postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String, category: document.data()["category"] as! String, postImageURL: document.data()["postImageURL"] as! String, postFlaggedCount: document.data()["flaggedCount"] as! Int)
                    
                    
                    self.myPosts.append(dummyPost)
                    
                }
                self.tableView.reloadData()
                
                print("\n\nCOUNT OF POSTS: \(self.myPosts.count)\n\n")
                
            }
        }//end of db.collection.getDocuments func
    }//end of loadData func
    
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
    }//end of presentDeleteAccountAlert func
    
    //MARK: - TODO
    //This is supposed to tell the tableview when to scroll and when not to. Currently, it doesn't seem to work.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.tableView {
            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
        }
    }//end of scrollViewDidScroll func
}//end of ProfileViewController

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
    }//end of prepare(for segue)
}//end of TableView extension

extension ProfileViewController {
func presentSettingsActionSheet() {
        
        let actionSheet = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) in
               
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Delete account", style: .destructive, handler: { [weak self] (_) in
                self?.presentDeleteAccountAlert()
            }))
    
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
}//End of extension
