//
//  CategoryCollectionViewCell.swift
//  MVP
//
//  Created by Anthroman on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
   
    //MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    //MARK: - Properties
    
    var category: Category? {
        didSet {
            self.updateViews()
        }
    }
    
    //MARK: - Helper Functions
    func updateViews() {
        if let category = category {
            categoryLabel.text = category.text
//            categoryIcon.image = category.
        }
        
        categoryIcon.layer.cornerRadius = 15
    }
}
