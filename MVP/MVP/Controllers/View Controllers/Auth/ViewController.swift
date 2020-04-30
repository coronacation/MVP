//
//  ViewController.swift
//  MVP
//
//  Created by David on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
}
