//
//  ProfileViewController.swift
//  MVP
//
//  Created by David on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpViews()
    }
    
    func setUpViews() {
        print("setup views triggered")
        if let firstName = CurrentUserController.shared.currentUser?.firstName, let lastName = CurrentUserController.shared.currentUser?.lastName, let email = CurrentUserController.shared.currentUser?.email {
            
            nameLabel.text = "\(firstName) \(lastName)"
            emailLabel.text = "\(email)"
            print("labels assigned")
        }
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        //present alert controller with warning that this action cannot be undone
        
    }
}
