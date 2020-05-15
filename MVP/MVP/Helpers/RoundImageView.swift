//
//  RoundImageView.swift
//  MVP
//
//  Created by Anthroman on 5/15/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.height/2
    }

}
