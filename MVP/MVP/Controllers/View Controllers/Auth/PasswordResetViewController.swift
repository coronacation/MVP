//
//  PasswordResetViewController.swift
//  MVP
//
//  Created by David on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var emailPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        
        guard let email = emailPasswordTextField.text, emailPasswordTextField.text != "" else {return}
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          if error != nil {
              
              // There was an error creating the user
              self.showError("Error sending email. Please check email address for typo.")
          } else {
            
            self.showError("Password reset email sent!")
            
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
     navigationController?.popViewController(animated: true)
    }
}