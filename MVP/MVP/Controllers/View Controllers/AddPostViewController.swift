//
//  AddPostViewController.swift
//  MVP
//
//  Created by David on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit.UIImage
import Firebase

class AddPostViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Properties
    let db = Firestore.firestore()
    
    //landing pad for image grabbed in PhotoSelector, use this for saving to the cloud
    var selectedImage: UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
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
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectorVC" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }//end of prepare(for segue:) func
}//end of AddPostVC

//MARK: - AddPostTVC extension
extension AddPostViewController: PhotoSelectorViewControllerDelegate {
    
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}//end of AddPostTVC photoSelector extension
