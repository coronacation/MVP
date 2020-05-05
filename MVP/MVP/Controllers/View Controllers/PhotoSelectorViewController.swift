//
//  PhotoSelectorViewController.swift
//  TalkShow
//
//  Created by Anthroman on 4/14/20.
//  Copyright © 2020 JoshuaBaatz. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol PhotoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
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
    }//end of selectPhotoButtonTapped func
    
    func setupViews() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .black
        imagePicker.delegate = self
    }
}//end of PhotoSelectorViewController class

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = delegate
                else { return }
            delegate.photoSelectorViewControllerSelected(image: pickedImage)
            photoImageView.image = pickedImage
            selectPhotoButton.setTitle("", for: .normal)
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
}//end of PhotoSelectorViewController extension
