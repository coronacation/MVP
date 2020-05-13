//
//  MapViewController.swift
//  MVP
//
//  Created by Anthroman on 5/4/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import UIKit
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
            centerViewOnUserLocation()
        @unknown default:
            print("Default case for CLLocationManager.authorizationStatus()")
        }
    }//end of checkLocationAuthorization func

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: tenMiles, longitudinalMeters: tenMiles)
            mapView.setRegion(region, animated: true)
        }
    }//end of centerViewOnUserLocation func
}//end of MapViewController

extension MapViewController {
    func addRandomLocation(_ sender: UIBarButtonItem) {
        let radius = 1200
        let randomCenter = CurrentUserController.shared.generateRandomLocationForUser().coordinate
        let circle = MKCircle(center: randomCenter, radius: CLLocationDistance(radius))
        mapView.addOverlay(circle)
    }

     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}//end of randomLocation extension

// must ask permission to use location-finder
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
        
        let userLocation :CLLocation = locations[0] as CLLocation

        CurrentUserController.shared.setCurrentUserLocation(location: userLocation)

    }
}//end of extension

extension MapViewController {
    
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
