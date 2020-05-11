//
//  ProfileViewController.swift
//  MVP
//
//  Created by David on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

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
        presentDeleteAccountAlert()
            }
    
    func presentDeleteAccountAlert() {
        
        let title = "Are you sure you want to delete your account?"
        let message = "This action cannot be undone. You will lose all data from your account."
        let cancelActionTitle = "Cancel"
         let deleteActionTitle = "Delete Account"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: nil))
     alert.addAction(UIAlertAction(title: deleteActionTitle, style: .cancel, handler: { (_) in
    
         let user = Auth.auth().currentUser

         user?.delete { error in
           if let error = error {
             print("error deleting account")
             print(error.localizedDescription)
           } else {
             print("account deleted")
           }
         }
         
     }))
        self.present(alert, animated: true, completion: nil)
    }

    
}
