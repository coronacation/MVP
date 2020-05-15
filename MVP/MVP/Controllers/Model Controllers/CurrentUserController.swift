//
//  CurrentUserController.swift
//  MVP
//
//  Created by David on 5/5/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class CurrentUserController {
    
    static let shared = CurrentUserController()
    
    var currentUser: CurrentUser? {
        didSet {
            ChatListController.shared.currentUser = self.currentUser
        }
    }
    
//    func isWithinDistance(of distance: Double, from user: User) -> Bool {
//        return (self.userLocation.distance(from: user.userLocation)) < distance
//    }
    
    //this function sets the current user once they create a new account
    func setCurrentUserFromSignUp(firstName: String, lastName: String, email: String, userUID: String) {
        self.currentUser = CurrentUser(firstName: firstName, lastName: lastName, email: email, userUID: userUID)
    }
    
    //this function will be run if a current user logs in on a new device
    func setCurrentUserFromLogin(firstName: String, lastName: String, email: String, userUID: String) {
        self.currentUser = CurrentUser(firstName: firstName, lastName: lastName, email: email, userUID: userUID)
    }
    
    func setCurrentUserLocation(location: CLLocation) {
              self.currentUser?.location = location
    }
    
         // Generate a random location between 0.5 and 1.5 km of user
        func generateRandomLocationForUser() -> MKPointAnnotation {
            let annotation = MKPointAnnotation()
    
      //      annotation.coordinate = generateRandomCoordinatesForUser()

              annotation.title = "Username"
             annotation.subtitle = "Goods Being Offered"
            
            return annotation
            // Note: Caller must add the annotation to the map using mapView.addAnnotation(//annotation's variable//)
        }
    
        func generateRandomCoordinatesForUser() -> CLLocationCoordinate2D? {
            // Get the user's longitude and latitude coordinates
            
            guard let currentUser = currentUser, let location = currentUser.location else {return nil}
            
            let currentLong = location.coordinate.longitude
            let currentLat = location.coordinate.latitude

            // 1 kilometer = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
            let meterCord = 0.00900900900901 / 1000

            // Generate random meters between the maximum and minimum meters
            let randomMeters = UInt(arc4random_uniform(1000) + 500)

            // Generate random numbers for different directions from center
            let randomPM = arc4random_uniform(6)

            // Convert the distance in meters to coordinates by multiplying the number of meters with 1 meter coordinate
            let metersCordN = meterCord * Double(randomMeters)

            // Generate the random coordinates
            switch randomPM {
            case 0:
                return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
            case 1:
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
            case 2:
                return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
            case 3:
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
            case 4:
                return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
            default:
                return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
            }
        }
}

