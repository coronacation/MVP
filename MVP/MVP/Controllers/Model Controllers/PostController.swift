//
//  PostController.swift
//  MVP
//
//  Created by David on 5/10/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class PostController: Codable {
    
    static func fetchPostImage(stringURL: String, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        
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
    
    static func fetchDrinkImage2(post: DummyPost, completion: @escaping (Result<UIImage, PostError>) -> Void) {
        guard let drinkThumbnail = URL(string:post.postImageURL) else {return completion(.failure(.noData))}
        URLSession.shared.dataTask(with: drinkThumbnail) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrown(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(image))
        }.resume()
    }
    
    
}
