//
//  PostController.swift
//  MVP
//
//  Created by David on 5/10/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostController {

    static let shared = PostController()
    
    var imageCache = NSCache<NSURL, UIImage>()
    
     func fetchPostImage(stringURL: String, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
        guard let url = URL(string: stringURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrown(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(image))
        }.resume()
    }
    
     func fetchDrinkImage2(post: DummyPost, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        guard let drinkThumbnail = URL(string:post.postImageURL) else {return completion(.failure(.noData))}
        guard let nsurlValue = NSURL(string: post.postImageURL) else {return completion(.failure(.invalidURL))}
        if let cachedImage = imageCache.object(forKey: nsurlValue) {
            return completion(.success(cachedImage))
        }
        URLSession.shared.dataTask(with: drinkThumbnail) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrown(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            self.imageCache.setObject(image, forKey: nsurlValue)
            
            completion(.success(image))
        }.resume()
    }
    
    
    
    
    
    static func updatePost(postID: String) {
        
    }
    
}
