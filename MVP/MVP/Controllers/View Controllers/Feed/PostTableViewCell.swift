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
            
            PostController.fetchDrinkImage2(post: post) { (result) in
                switch result {
                    case .success(let image):
                        print("success")
                    DispatchQueue.main.async {
                        self.postImage.image = image
                        }
                    case .failure(let error):
                        print("failed")

                        print(error.errorDescription)
                }
            }
            
            
//            postImage.image = #imageLiteral(resourceName: "addPhotoIcon-white-background")
//            postImage.fetchPostImage2(ImageURL: post.postImageURL)
            
            //            PostController.fetchPostImage(stringURL: post.postImageURL) { (result) in
            //                DispatchQueue.main.async {
            //                    switch result {
            //                    case .success(let image):
            //                        self.postImage.image = image
            //                    case .failure(let error):
            //                        print(error.errorDescription!)
            //                        self.postImage.image = #imageLiteral(resourceName: "noImageAvailable")
            //                    }
            //                }
            //            }
        }
    }
    
}

extension UIImageView {
    func fetchPostImage2(ImageURL :String) {
       URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
          (data, response, error) -> Void in
          DispatchQueue.main.async {
             if let data = data {
                self.image = UIImage(data: data)
             }
          }
       }).resume()
    }
}







//
//static func fetchPostImage(stringURL: String, completion: @escaping (Result<UIImage, PostError>) -> Void) {
//
//    guard let url = URL(string: stringURL) else {return}
//
//    URLSession.shared.dataTask(with: url) { (data, _, error) in
//        if let error = error {
//            completion(.failure(.thrown(error)))
//        }
//        guard let data = data else {return completion(.failure(.noData))}
//        guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
//        completion(.success(image))
//    }.resume()
//}

//extension UIImageView {
//    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
//        guard let url = URL(string: link) else {return}
//        
//        URLSession.shared.dataTask(with: url) { (data, _, error) in
//            DispatchQueue.main.async {
//                self.contentMode =  contentMode
//                if let data = data { self.image = UIImage(data: data) }
//            }
//        }).resume()
//    }
//}
