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
        print("message user tapped")
    }
    
    @IBAction func reportPostButtonTapped(_ sender: Any) {
        print("report tapped")
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