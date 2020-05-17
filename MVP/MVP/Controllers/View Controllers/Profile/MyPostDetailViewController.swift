//
//  MyPostDetailViewController.swift
//  MVP
//
//  Created by David on 5/12/20.
//  Copyright © 2020 coronacation. All rights reserved.

import UIKit
import Firebase

class MyPostDetailViewController: UIViewController {
    
    @IBOutlet weak var myPostImageView: UIImageView!
    @IBOutlet weak var myPostTitleTextField: UITextField!
    @IBOutlet weak var myPostDescriptionTextView: UITextView!
    @IBOutlet weak var myPostTimestampLabel: UILabel!
    @IBOutlet weak var myPostUserNameLabel: UILabel!
    
    var myPost: DummyPost?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        myPostTitleTextField.delegate = self
    }
    
    func setUpViews() {
        if let myPostTitle = self.myPost?.postTitle, let myPostCreatedTimestamp = self.myPost?.postCreatedTimestamp, let urlString = self.myPost?.postImageURL, let myPostUserName = self.myPost?.postUserFirstName {
            
            loadImage(url: URL(string: urlString)!)
            
            myPostTitleTextField.text = " \(myPostTitle)"
            myPostDescriptionTextView.text = self.myPost?.postDescription
            myPostTimestampLabel.text = "Posted on \(myPostCreatedTimestamp)"
            myPostUserNameLabel.text = myPostUserName
        }
    }
    
    @IBAction func deleteMyPostButtonTapped(_ sender: Any) {
        
        guard let _ = myPost else {return}
        presentDeleteAlert()
    }
    
    func presentDeleteAlert() {
        
        let title = "Are you sure you want to delete this post?"
        let message = "This action cannot be undone"
        let deleteActionTitle = "Delete it"
        let cancelActionTitle = "Cancel"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: deleteActionTitle, style: .cancel, handler: { (_) in
            self.deletePost()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deletePost() {
        
        guard let myPost = myPost else {return}
        
        db.collection("postsV3.1").document(myPost.postDocumentID).delete() { err in
            if let err = err {
                
                print(err.localizedDescription)
                
                let alert = UIAlertController(title: "Error deleting post", message: "Please check your connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                print("Document successfully removed!")
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    //error handle that if firebase doesn't save, launch alert
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let myPostTitle = myPostTitleTextField.text, myPostTitle != "", let myPostDescription = myPostDescriptionTextView.text, myPostDescription != "", let myPostID = myPost?.postDocumentID else {return}
        
        let myPostRef = db.collection("postsV3.1").document(myPostID)
        
        myPostRef.updateData([
            "postTitle": "\(myPostTitle)",
            "postDescription": "\(myPostDescription)"
        ]) { err in
            if let err = err {
                self.presentErrorUpdatingAlert()
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.presentSuccessUpdatingAlert()
            }
        }
    }
    
    func presentErrorUpdatingAlert() {
        
        let title = "Your post could not be updated"
        let message = "Check your connection and please try again"
        let actionTitle = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
     
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentSuccessUpdatingAlert() {
        
        let title = "Your post has been updated!"
        let message = ""
        let actionTitle = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
        self.dismiss(animated: true)
     }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.myPostImageView.image = image
                        print("\nmyPostImage Set! ")
                    }
                }
            }
        }
    }
} //end of MyPostDetailVC

extension MyPostDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
