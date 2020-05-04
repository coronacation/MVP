//
//  PostTableViewCell.swift
//  MVP
//
//  Created by Anthroman on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    //MARK: - Properties
    var user: User?
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Helper Functions
    func updateViews() {
//        profilePictureImageView.image = user?.profilePicture
        usernameLabel.text = "\(String(describing: user?.firstName)) \(String(describing: user?.lastName))"
        descriptionTextView.text = post?.description
    }
    
}
