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
    
}

extension PostDetailViewController: UITextFieldDelegate {
    
    func presentNewMessageAlert(post: DummyPost) {
        
        let alertMessage = "Press Send to ask \(post.postUserFirstName) if the offer is still available. If it is, you'll receive a reply from them in the Messages tab."
        
        let starterText = "Hi, is this still available? "
        
        let alert = UIAlertController(title: "Send a message", message: alertMessage, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            textField.text = starterText
        }
        
        let sendButton = UIAlertAction(title: "Send", style: .default) { (_) in
            
            guard let firstMessage = alert.textFields?.first?.text, !firstMessage.isEmpty else { return }
            
            ChatListController.shared.firstMessage(regarding: post, firstMessage: firstMessage) { (success) in
                self.showMessageResultAlert(success)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(sendButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    func showMessageResultAlert(_ result: Bool) {
        
        let alertTitle = result ? "Success" : "Wait"
        
        let alertMessage = result ? "Your message was sent." : "You've already sent a message. Please wait until the other person replies. You'll see their reply in the Message tab."
                
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
}
