//
//  AppDelegate.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import GoogleMaps
import AVFoundation
import MediaPlayer
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    public var locationlist : [CLLocation] = []

    
    
    // https://maps.googleapis.com/maps/api/directions/json?origin=55.950,-3.1840&destination=55.9444,-3.1870&mode=walking&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc")
        GMSPlacesClient.provideAPIKey("AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc")
        
        
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
           // Request when-in-use authorization initially
         self.locationManager.requestWhenInUseAuthorization() // requesting user location permission
            LocationPersmissonsGranted() // sets up the map after location granted
            break

        case .restricted, .denied:
           // Disable location features
           break

        case .authorizedWhenInUse, .authorizedAlways:
           // Enable location features
            LocationPersmissonsGranted()
           break
        @unknown default:
            print("fatal error")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        catch let error as NSError {
            print("Error: Could not set audio category: \(error), \(error.userInfo)")
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print("Error: Could not setActive to true: \(error), \(error.userInfo)")
        }
        
        
        
        return true
    }
    
    func LocationPersmissonsGranted() {
        self.locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        
    }
    
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationlist.append(locations.last!)
    }
    
    
    
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in

            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })

    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

