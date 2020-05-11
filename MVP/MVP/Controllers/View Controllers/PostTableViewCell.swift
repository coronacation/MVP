//
//  PostTableViewCell.swift
//  MVP
//
//  Created by David on 5/10/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    
    var post: DummyPost? {
        didSet{
            guard let post = post else {return}
            titleLabel.text = post.postTitle
            descriptionLabel?.text = post.postDescription
            categoryLabel.text = "Category: \(post.category)"
            datePostedLabel.text = post.postCreatedTimestamp
            
            PostController.fetchPostImage(stringURL: post.postImageURL) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.postImage.image = image
                    case .failure(let error):
                        print(error.errorDescription!)
                        self.postImage.image = #imageLiteral(resourceName: "noImageAvailable")
                    }
                }
            }
        }
    }
}

