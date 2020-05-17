//
//  MyPostsTableViewCell.swift
//  MVP
//
//  Created by David on 5/12/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var myPostTitleLabel: UILabel!
    @IBOutlet weak var myPostCategoryLabel: UILabel!
    @IBOutlet weak var myPostTimestampLabel: UILabel!
    @IBOutlet weak var myPostImageView: UIImageView!
    @IBOutlet weak var myPostDescriptionTextView: UITextView!
    
 var myPost: DummyPost? {
        didSet{
            guard let myPost = myPost else {return}
            myPostTitleLabel.text = myPost.postTitle
            myPostDescriptionTextView?.text = myPost.postDescription
            myPostCategoryLabel.text = "Category: \(myPost.category)"
            myPostTimestampLabel.text = myPost.postCreatedTimestamp
            
            PostController.shared.fetchDrinkImage2(post: myPost) { (result) in
                switch result {
                    case .success(let image):
                        print("success")
                    DispatchQueue.main.async {
                        self.myPostImageView.image = image
                        }
                    case .failure(let error):
                        print("failed")

                        print("\(String(describing: error.errorDescription))")
                }
            }
        }
    }
}
