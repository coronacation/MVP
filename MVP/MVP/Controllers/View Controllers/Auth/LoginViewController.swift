//
//  LoginViewController.swift
//  MVP
//
//  Created by David on 4/29/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    //MARK: - Actions
    @IBAction func loginTapped(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                print("error signing in")
            }
            else {
                //set CurrentUserController.shared.currentUser to whichever user just logged in
                let db = Firestore.firestore()
                let usersRef = db.collection("usersV2")
                if let userUID = Auth.auth().currentUser?.uid {
                    
                    usersRef.whereField("uid", isEqualTo: userUID).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error assign current user: \(error)")
                        }      else {
                            
                            for document in querySnapshot!.documents {
                                
                                let currentUser = CurrentUser(firstName: document.data()["firstName"] as! String, lastName: document.data()["lastName"] as! String, email: document.data()["email"] as! String, userUID: document.data()["uid"] as! String)
                                
                                CurrentUserController.shared.currentUser = currentUser
                                print("CurrentUser set. API call complete. UserUID: \(userUID)")
                                self.transitionToHome()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func alreadyAUserButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func transitionToHome() {
        let tabBarViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarViewController) as? TabBarViewController
        
        self.view.window?.rootViewController = tabBarViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
