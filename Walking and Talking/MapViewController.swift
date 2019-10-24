//
//  SecondViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let camera = GMSCameraPosition.camera(withLatitude: (delegate.locationlist.last?.coordinate.latitude)!, longitude: (delegate.locationlist.last?.coordinate.longitude)!, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
    
        
    }


}

