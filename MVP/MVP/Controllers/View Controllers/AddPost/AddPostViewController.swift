//
//  AddPostViewController.swift
//  MVP
//
//  Created by David on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit.UIImage
import Firebase
import AVFoundation
import Photos

class AddPostViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    
    //MARK: - Properties
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    //landing pad for image grabbed in PhotoSelector, use this for saving to the cloud
    var selectedImage: UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        titleTextField.delegate = self
        setUpViews()
    }
    
    func setUpViews()  {
        currentUserNameLabel.text = CurrentUserController.shared.currentUser?.firstName
        if selectedImage != nil {
            postImageView?.image = selectedImage
            print("\npostImageView assigned")
        }
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
            
            print("\nsaving post with no selected image")
            
            savePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: currentUserFirstName, postCreatedTimestamp: postCreatedTimestamp)
        } else {
            print("saving post with selected image")

            grabImageURLAndSavePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: currentUserFirstName, postCreatedTimestamp: postCreatedTimestamp)
        }
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.checkCameraAuthorization()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.checkPhotoLibraryAuthorization()
        }
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        
        present(alert, animated: true, completion: nil)
    }//end of addPhotoButtonTapped func
    
    //MARK: - Helpers
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
                        print("\nImageURL: \(imageURL)")
                        self.savePost(postTitle: postTitle, postDescription: postDescription, postUserUID: postUserUID, postUserFirstName: postUserFirstName, postCreatedTimestamp: postCreatedTimestamp, imageURL: imageURL)
                    }
                }
            }
        }
    }//end of grabImageURLAndSavePost func
    
    func presentAddPhotoNudgeBeforeSave() {
    }
    
    //MARK: - TODO: Create a DateFormatterExtension file?
    func timestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/Y"
        let formattedDate = dateFormatter.string(from: Date())
        
        return formattedDate
    }
    
    //MARK: - TODO: move to PostController file
    func savePost(postTitle: String, postDescription: String, postUserUID: String, postUserFirstName: String, postCreatedTimestamp: String, imageURL: String = "none") {
        
        let currentUser = Auth.auth().currentUser
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/Y"
        let formattedDate = dateFormatter.string(from: Date())
        
        guard let currentUserFirstName = CurrentUserController.shared.currentUser?.firstName, let currentUserLatitude = CurrentUserController.shared.currentUser?.latitude, let currentUserLongitude = CurrentUserController.shared.currentUser?.longitude else {return}
        
        var ref: DocumentReference? = nil
        
        let data: [String: Any] = [
            "postTitle": "\(postTitle)",
            "postDescription": "\(postDescription)",
            "postUserUID": "\(currentUser!.uid)",
            "postUserFirstName": "\(currentUserFirstName)",
            "postUserLatitude": currentUserLatitude,
            "postUserLongitude": currentUserLongitude,
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
                self.clearAllFields()
            }
        }
    }//end of savePost func
    
    func clearAllFields() {
        self.postImageView.image = UIImage(named: "noPhotoSelected")
        selectedImage = nil
        self.titleTextField.text = ""
        self.descriptionTextView.text = ""
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        clearAllFields()
    }
    
    
    func presentSavedAlert() {
        let title = "Post saved"
        let message = "Thank you for your generosity"
        
        let savedAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        savedAlert.addAction(UIAlertAction(title: "You're welcome", style: .default, handler: nil))
        self.present(savedAlert, animated: true, completion: nil)
    }//end of presentSavedAlert func
    
    func presentErrorSavingPostAlert() {
        let title = "Post could not be saved"
        let message = "Check your connectiong and try again later"
        
        let savedAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        savedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(savedAlert, animated: true, completion: nil)
    }//end of presentErrorSavingPostAlert func
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelectorVC" {
            
            //MARK: - TODO: Setup segue to send post info
            
            let destinationVC = segue.destination // as? VCName
        }
    }//end of prepare(for segue:) func
}//end of AddPostVC

//MARK: - AddPostTVC extension
extension AddPostViewController: UIImagePickerControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "No Camera Access", message: "Please allow access to the camera to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }//end of openCamera func
    
    func openGallery() {
        print("opening gallery")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            DispatchQueue.main.async {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "No Photo Access", message: "Please allow access to photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }//end of openGallery func
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("\nImage picker controller func running")
        
        if let pickedImage = info[.originalImage] as? UIImage {
            print("pickedImage set")
            selectedImage = pickedImage
            postImageView.image = pickedImage
            setUpViews()
        }
        picker.dismiss(animated: true, completion: nil)
    }//end of imagePickerController func
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
            break
        case .restricted, .denied:
            presentDeniedAlert()
            break
        case .authorized:
            openCamera()
        @unknown default:
            print("Default case for AVCaptureDevice.authorizationStatus()")
        }
    }//end of checkCameraAuthorization func
    
    func checkPhotoLibraryAuthorization() {
        print("\nchecking photo lib auth")
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization( { status in
                if (status == PHAuthorizationStatus.authorized) {
                    self.openGallery()
                }
            })
            break
        case .restricted, .denied:
            presentDeniedAlert()
            break
        case .authorized:
            openGallery()
        @unknown default:
            print("Default case for AVCaptureDevice.authorizationStatus()")
        }
    }//end of checkPhotoLibraryAuthorization func
    
    func presentDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Check your permission or restriction settings and try again.", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }//end of presentDeniedAlert func
}//end of AddPostTVC photoSelector extension


extension AddPostViewController: UINavigationControllerDelegate {
    
}



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



