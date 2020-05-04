//
//  ExploreMapViewController.swift
//  MVP
//
//  Created by Anthroman on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExploreMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    //MARK: - Properties
    let categories: [Category] = [.food, .ppe, .basicNeeds, .housing, .employment, .education, .childCare, .other]
    
    let locationManager = CLLocationManager()
    let blackView = UIView()
    
    let metersPerMile: Double = 1609.344
    let fiveMiles: Double = 8046.72
    let tenMiles: Double = 16093.44
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.isHidden = true
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: tenMiles, longitudinalMeters: tenMiles)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting user know they must turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
        case .denied:
            //alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //alert letting them know access for the user is restricted
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("Default case for CLLocationManager.authorizationStatus()")
        }
    }//end of checkLocationAuthorization func
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// must ask permission to use location-finder
extension ExploreMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
    }
}

// horizontal collection view stuff
extension ExploreMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        
        let category = categories[indexPath.row]
         
        cell.category = category
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     postTableView.isHidden = false
     presentPostTableView()
     }
}

// postTableView Slide Up Display
extension ExploreMapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
/*
         // post and user stuff ?
         
         cell.post = post
         cell.user = user
*/
        return cell
    }
    
    func presentPostTableView() {
        postTableView.reloadData()
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTableView)))
            
            window.addSubview(blackView)
            window.addSubview(postTableView)
            
            let height: CGFloat = 500
            let y = window.frame.height - height
            
            postTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height * 0.6)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.postTableView.frame = CGRect(x: 0, y: y, width: self.postTableView.frame.width, height: self.postTableView.frame.height)
                
            }, completion: nil)
        }
    }
    
    @objc func dismissTableView() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                self.postTableView.frame = CGRect(x: 0, y: window.frame.height, width: self.postTableView.frame.width, height: self.postTableView.frame.height)
            }
        }
    }
}

