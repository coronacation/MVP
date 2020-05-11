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
        titleTextField.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let postDescription = descriptionTextView.text, !postDescription.isEmpty, let postTitle = titleTextField.text, !postTitle.isEmpty
            else { return }
        
        // function call to get download URL
        
        //      var imageURL = "no image"
        
        let postCreatedTimestamp = timestamp()
        
        let currentUser = Auth.auth().currentUser
        
        guard let currentUserFirstName = CurrentUserController.shared.currentUser?.firstName, let postUserUID = currentUser?.uid else {return}
        
        if selectedImage == nil {
            
            //presentAddPhotoNudgeBeforeSave()
            
            savePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: currentUserFirstName, postCreatedTimestamp: postCreatedTimestamp)
        } else {
            grabImageURLAndSavePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: currentUserFirstName, postCreatedTimestamp: postCreatedTimestamp)
        }
    }
    
    func grabImageURLAndSavePost(postTitle: String, postDescription: String, postUserUID: String, postUserFirstName: String, postCreatedTimestamp: String) {
        
        guard let imageData = selectedImage!.jpegData(compressionQuality: 0.6) else {return}
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        guard let postUserUID = currentUser?.uid else {return}
        let postImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-postImage.jpg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        postImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
                postImageRef.downloadURL { (url, error) in
                    if let metaImageURL = url?.absoluteString {
                        let imageURL = metaImageURL
                        self.savePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: postUserFirstName, postCreatedTimestamp: postCreatedTimestamp, imageURL: imageURL)
                    }
                }
            }
        }
    }
    
    func presentAddPhotoNudgeBeforeSave() {
    }
    
    func timestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/Y"
        let formattedDate = dateFormatter.string(from: Date())
        
        return formattedDate
    }
    
    //move to PostController file
    func savePost(postTitle: String, postDescription: String, postUserUID: String, postUserFirstName: String, postCreatedTimestamp: String, imageURL: String = "http://sjd.law.wfu.edu/files/2020/01/No-Photo-Available.jpg") {
        
        let currentUser = Auth.auth().currentUser
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/Y"
        let formattedDate = dateFormatter.string(from: Date())
        
        guard let currentUserFirstName = CurrentUserController.shared.currentUser?.firstName else {return}
        
        var ref: DocumentReference? = nil
        
        let data: [String: Any] = [
            "postTitle": "\(postTitle)",
            "postDescription": "\(postDescription)",
            "postUserUID": "\(currentUser!.uid)",
            "postUserFirstName": "\(currentUserFirstName)",
            "postCreatedTimestamp": "\(formattedDate)",
            "postImageURL" : "\(imageURL)",
            "category": "none",
            "flaggedCount": 0
        ]
        
        print("ImageURL after if statment: \(imageURL)")
        
        ref = db.collection("postsV3.1").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.presentErrorSavingPostAlert()
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.presentSavedAlert()
                self.clearFieldsAfterPostSaved()
            }
        }
    }
    
    func clearFieldsAfterPostSaved() {
        
        //Add clear for image and category and location
        
        //maybe use protocol and delegate to reset photo to default
        
        self.titleTextField.text = ""
        self.descriptionTextView.text = ""
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



//this dismisses the keyboard when enter is pressed on an iphone
extension AddPostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
}


//trying to get the same thing for the textview but haven't figured it our yet
//extension AddPostViewController: UITextViewDelegate {
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        <#code#>
//    }
//}



