//
//  PostError.swift
//  MVP
//
//  Created by David on 5/10/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

enum PostError: LocalizedError {
    case invalidURL
    case thrown(Error)
    case noData
    case unableToDecode
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Internal error. Please update app or contact support."
        case .thrown(let error):
            return error.localizedDescription
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        case .notFound:
            return "There is no post with that documentID."
        }
    }
}
