//
//  PostDetailViewController.swift
//  MVP
//
//  Created by Anthroman on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var postTimestampLabel: UILabel!
    
    //MARK: - Properties
    var post: DummyPost?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Actions
    @IBAction func messageUserButtonTapped(_ sender: Any) {
        
        print("#messageUserButtonTapped")
        
        // unwrap post
        guard let post = post else { return }
        
        
        // guard against a user messaging his own post
        let postOwnerUid = post.userUID
        
        guard let currentUserUID = CurrentUserController.shared.currentUser?.userUID,
            postOwnerUid != currentUserUID else {
                print("Nice try, troll. You can't message yourself.")
                return
        }
        
        // TODO: prevent user from spamming postOwner
        //      Counter-point: Maybe that's what the Block User function is for?
        
        // present AlertController
        presentNewMessageAlert(post: post)
    }
    
    @IBAction func reportPostButtonTapped(_ sender: Any) {
        presentReportPostAlert()
    }
    
    
    //MARK: - Helpers
    func setUpViews() {
        if let postUserFirstName = self.post?.postUserFirstName, let postTitle = self.post?.postTitle, let postCreatedTimestamp = self.post?.postCreatedTimestamp, let urlString = self.post?.postImageURL {
            
            loadImage(url: URL(string: urlString)!)
            
            postUserNameLabel.text = "Posted by: \(postUserFirstName)"
            postTitleLabel.text = "Title: \(postTitle)"
            postDescriptionTextView.text = self.post?.postDescription
            postTimestampLabel.text = "Posted on \(postCreatedTimestamp)"
        }
    }
    
    func presentReportPostAlert() {
        
        let title = "Report Post?"
        let message = "Please report any posts that are inappropriate"
        let cancelActionTitle = "Cancel"
        let reportActionTitle = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
     alert.addAction(UIAlertAction(title: reportActionTitle, style: .cancel, handler: { (_) in
        self.incrementPostReportCount()
     }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func incrementPostReportCount() {
        print("report count increment function not written")
    }
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.postImage.image = image
                    }
                }
            }
        }
    }
    
    func presentNewMessageAlert(post: DummyPost) {
        let alert = UIAlertController(title: "Send a message", message: "Press Send to let \(post.postUserFirstName) know that you're interested in this offer. If it's available, you'll receive a reply from them in the Messages tab.", preferredStyle: .alert)
        
        let sendButton = UIAlertAction(title: "Send", style: .default) { (_) in
            print("#presentNewMessageAlert will send \(post.postDocumentID)")
        }
        alert.addAction(sendButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
