//
//  MapViewController.swift
//  MVP
//
//  Created by Anthroman on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceCollectionView: UICollectionView!
    
    //MARK: - Properties
    
    let locationManager = CLLocationManager()
    
    let metersPerMile: Double = 1609.344
    let oneMile: Double = 1609.344
    let threeMiles: Double = 4828.032
    let fiveMiles: Double = 8046.72
    let tenMiles: Double = 16093.44
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            presentDeniedAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            presentRestrictedAlert()
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("Default case for CLLocationManager.authorizationStatus()")
        }
    }//end of checkLocationAuthorization func
}

// must ask permission to use location-finder
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
    }
}

extension MapViewController {
    func presentDeniedAlert() {
        let alert = UIAlertController(title: "Access Denied", message: "Check your permission settings and try again.", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }
    
    func presentRestrictedAlert() {
        let alert = UIAlertController(title: "Access Restricted", message: "Permissions (i.e. Parental Controls) have been disabled for this user.", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(dismissButton)
        self.present(alert, animated: true)
    }
}
