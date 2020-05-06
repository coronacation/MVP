//
//  PostDetailViewController.swift
//  MVP
//
//  Created by Anthroman on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postTimestampLabel: UILabel!
    
    var post: DummyPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        
        if let postUserFirstName = self.post?.postUserFirstName, let postTitle = self.post?.postTitle, let postCreatedTimestamp = self.post?.postCreatedTimestamp {
            
            postUserNameLabel.text = "Posted by: \(postUserFirstName)"
            postTitleLabel.text = "Title: \(postTitle)"
            postDescriptionLabel.text = self.post?.postDescription
            postTimestampLabel.text = "Posted on \(postCreatedTimestamp)"
        }
    }
    
    @IBAction func messageUserButtonTapped(_ sender: Any) {
        print("message user tapped")
    }
    
    @IBAction func reportPostButtonTapped(_ sender: Any) {
        print("report tapped")
    }
}
