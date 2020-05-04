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
    
    
    @IBAction func dummySavePhotoButtonTapped(_ sender: Any) {
          
        guard let selectedImage = selectedImage else {return}
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.6) else {return}
        
               let storageReference = Storage.storage().reference()
               let currentUser = Auth.auth().currentUser
               let postImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
               
               let uploadMetaData = StorageMetadata()
               uploadMetaData.contentType = "image/jpeg"
               
               postImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
                   
                   if error != nil
                   {
                       print("Error took place \(String(describing: error?.localizedDescription))")
                       return
                   } else {
                       
                    //   self.userProfileImageView.image = UIImage(data: imageData)
                       
                       print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                   }
               }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let postDescription = descriptionTextView.text, !postDescription.isEmpty, let postTitle = titleTextField.text, !postTitle.isEmpty
            else { return }
        
        var ref: DocumentReference? = nil
        ref = db.collection("PostsNoPhoto").addDocument(data: [
            "postTitle": "\(postTitle)",
            "postDescription": "\(postDescription)"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.presentErrorSavingPostAlert()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.presentSavedAlert()
                self.titleTextField.text = ""
                self.descriptionTextView.text = ""
            }
        }
    }
    
    
    func presentSavedAlert() {
        let title = "Post saved"
        let message = "Thank you for your generosity"
        
        let savedAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        savedAlert.addAction(UIAlertAction(title: "You're welcome", style: .default, handler: nil))
        self.present(savedAlert, animated: true, completion: nil)
    }
    
    func presentErrorSavingPostAlert() {
           let title = "Post could not be saved"
           let message = "Check your connectiong and try again later"
           
           let savedAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           savedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
           self.present(savedAlert, animated: true, completion: nil)
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
