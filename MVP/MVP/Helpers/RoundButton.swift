//
//  RoundButton.swift
//  MVP
//
//  Created by Anthroman on 5/14/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
    }

}
