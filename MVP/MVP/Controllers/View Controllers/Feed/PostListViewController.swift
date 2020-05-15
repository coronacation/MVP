//
//  PostListTableViewController.swift
//  MVP
//
//  Created by Anthroman on 4/28/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class PostListViewController: UIViewController {
    
    var myPosts = [DummyPost]()
    var db: Firestore!
    
    @IBOutlet weak var postSearchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        checkLocationServices()
        table.delegate = self
        table.dataSource = self
        
        if let location = locationManager.location {
            CurrentUserController.shared.setCurrentUserLocation(location: location)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CurrentUserController.shared.currentUser != nil {
            loadData()
        }
    }
    
    func loadData() {
     //   print(CurrentUserController.shared.currentUser?.location! as Any)
        db.collection("postsV3.1").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
                
            else {
                self.myPosts = []
                for document in querySnapshot!.documents {
                    
                    let dummyPost = DummyPost(postTitle: document.data()["postTitle"] as! String,                  postDescription: document.data()["postDescription"] as! String,
                                              userUID: document.data()["postUserUID"] as! String, postUserFirstName: document.data()["postUserFirstName"] as! String, postDocumentID: "\(document.documentID)",
                        postCreatedTimestamp: document.data()["postCreatedTimestamp"] as! String, category: document.data()["category"] as! String, postImageURL: document.data()["postImageURL"] as! String, postFlaggedCount: document.data()["flaggedCount"] as! Int, postLongitude: document.data()["postUserLongitude"] as! Double, postLatitude: document.data()["postUserLatitude"] as! Double)
                    
                    //                    PostController.fetchPostImage(stringURL: dummyPost.postImageURL) { (result) in
                    //                                 DispatchQueue.main.async {
                    //                                     switch result {
                    //                                     case .success(let image):
                    //                                         dummyPost.postUIImage = image
                    //                                        print("success pulling image/n")
                    //                                     case .failure(let error):
                    //                                         print(error.errorDescription!)
                    //                                         dummyPost.postUIImage = #imageLiteral(resourceName: "noImageAvailable")
                    //                                     }
                    //                                 }
                    //                             }
                    
                    self.myPosts.append(dummyPost)
                }
                self.table.reloadData()
                
                print("\n\nCOUNT OF POSTS: \(self.myPosts.count)\n\n")
                
            }
        }
    }
    
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return myPosts.count
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         162
     }
     
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
         
         let post = myPosts[indexPath.row]
         cell.post = post
         
         return cell
     }
     
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toPostDetailVC" {
             if let destinationVC = segue.destination as? PostDetailViewController, let indexPath = table.indexPathForSelectedRow {
                 let post = myPosts[indexPath.row]
                 destinationVC.post = post
             }
         }
     }
}

extension PostListViewController {
    
     func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                locationServicesDisabledAlert()
            }
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                centerViewOnUserLocation()
            case .denied:
                presentDeniedAlert()
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                presentRestrictedAlert()
                break
            case .authorizedAlways:
                centerViewOnUserLocation()
            @unknown default:
                print("Default case for CLLocationManager.authorizationStatus()")
            }
        }//end of checkLocationAuthorization func

        func centerViewOnUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 40000, longitudinalMeters: 40000)
            }
        }//end of centerViewOnUserLocation func
    }//end of MapViewController

extension PostListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
        
        let userLocation :CLLocation = locations[0] as CLLocation

        CurrentUserController.shared.setCurrentUserLocation(location: userLocation)
    }
}//end of extension

extension PostListViewController {
    
     func locationServicesDisabledAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Check your location service settings and try again.", preferredStyle: .alert)

         let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)

         alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }//end of locationServicesDisabledAlert func
    
    func presentDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Check your permission settings and try again.", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }//end of presentDenied Alert func
    
    func presentRestrictedAlert() {
        let alert = UIAlertController(title: "Access Restricted", message: "Permissions (i.e. Parental Controls) have been disabled for this user.", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }//end of presentRestrictedAlert func
}//end of extension
