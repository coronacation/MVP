//
//  AddPostViewController.swift
//  MVP
//
//  Created by David on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase

class AddPostViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var postImageView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
          guard let postDescription = descriptionTextView.text, !postDescription.isEmpty
                    else { return }
                
                var ref: DocumentReference? = nil
                ref = db.collection("Hypes").addDocument(data: [
                    "postDescription": "\(postDescription)"
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
                print("confirmed")
    }
}
