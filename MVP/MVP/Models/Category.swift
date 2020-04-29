//
//  Category.swift
//  MVP
//
//  Created by Theo Vora on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

/// Category - Categories for Posts
enum Category: CaseIterable {
    case food
    case ppe
    case basicNeeds
    case housing
    case employment
    case education
    case childCare
    
    /// text returns a user-friendly string for a Category. Ex: food.text returns "food"
    var text: String {
        switch self {
        case .food:
            return "Food"
        case .ppe:
            return "PPE"
        case .basicNeeds:
            return "Basic Needs"
        case .housing:
            return "Housing"
        case .employment:
            return "Employment"
        case .education:
            return "Education"
        case .childCare:
            return "Child Care"
        }
    }
}

extension Category {
    static var allValuesAsStrings: [String] {
        return Category.allCases.map { $0.text }
    }
}
