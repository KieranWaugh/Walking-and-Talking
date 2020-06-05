//
//  CategoryViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 11/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var link: String = ""
    var polyLine: String = ""
    var location: Place?
    var stepsArray : [Direction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupFavButton()
        link = "https://maps.googleapis.com/maps/api/directions/json?origin=\((delegate.locationlist.last?.coordinate.latitude)!),\((delegate.locationlist.last?.coordinate.longitude)!)&destination=\((location?.latitude)!),\((location?.longtude)!)&mode=walking&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc"
        print(link)
        JSONParse()
        // Do any additional setup after loading the view.
    }
    
    func setupFavButton(){
        print("favs " , savedData.shared.Favoutites)
        if savedData.shared.Favoutites.contains((location?.uuid!)!){
            favButton.setTitle("Unfavourite", for: .normal)
            favButton.backgroundColor = .green
        }
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .green
        polyline.map = mapView // Your map view
        polyline.accessibilityLabel = "Map with route between your location and \((navigationController!.title)!)"
        DispatchQueue.main.async
        {
         if self.mapView != nil
         {
          let bounds = GMSCoordinateBounds(path: path!)
          self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
         }
        }
    }
    
    func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: (location?.latitude!)!, longitude: (location?.longtude!)!, zoom: 17.0)
        mapView.camera = camera
        let marker = GMSMarker()
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2D(latitude: (delegate.locationlist.last?.coordinate.latitude)!, longitude: (delegate.locationlist.last?.coordinate.longitude)!)
        startMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        startMarker.map = mapView
        marker.position = CLLocationCoordinate2D(latitude: (location?.latitude!)!, longitude: (location?.longtude!)!)
        marker.title = self.title
        marker.map = mapView
        mapView.accessibilityElementsHidden = false
        
    }
    
    @IBAction func favButton(_ sender: Any) {
        
        
        print("current title \(favButton.currentTitle!)")
        if (favButton.currentTitle! == "Favourite"){
            print ("adding fav")
            savedData.shared.addFavourite(location: location!)
            favButton.setTitle("Un-Favourite", for: .normal)
            favButton.backgroundColor = .green


        }else if (favButton.currentTitle! != "Favourite"){
            savedData.shared.removeFav(id: (location?.uuid)!)
            favButton.backgroundColor = .orange
            favButton.setTitle("Favourite", for: .normal)
        }
        
        
    }
    
    
    func JSONParse(){
        let url = link
        print(link)
        Alamofire.request(url).responseJSON
        { response in

        let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            let route = routes[0]
            let line = route["overview_polyline"]
            self.polyLine = line["points"].stringValue
            self.showPath(polyStr: self.polyLine)
            let legs = route["legs"].arrayValue
            let leg = legs[0]
            let distance = leg["distance"].arrayValue
            let durationArray = leg["duration"]
            print(durationArray)
            self.navigateButton.setTitle("Navigate - \(durationArray["text"].stringValue)", for: .normal)
            let steps = leg["steps"].arrayValue
            for step in steps {
                let start = step["start_location"]
                let end = step["end_location"]
                let stepDistance = step["distance"]
                let dist = stepDistance["value"]
                let instr = step["html_instructions"].stringValue
                let man = step["maneuver"].stringValue
                let time = step["duration"]
                self.stepsArray.append(Direction(startLat: start["lat"].stringValue, startLng: start["lng"].stringValue, endLat: end["lat"].stringValue, endLng: end["lng"].stringValue, instruction: self.stripHTML(fromString: instr), maneuver: man, time: time["text"].stringValue, distance: dist.int!))
            }
            
        }
        
    }
    
    private func stripHTML(fromString rawString: String) -> String {
        let scanner: Scanner = Scanner(string: rawString)
        var text: NSString? = ""
        var convertedString = rawString
        while !scanner.isAtEnd {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: &text)
            convertedString = convertedString.replacingOccurrences(of: "\(text!)>", with: "")
        }
        convertedString = convertedString.replacingOccurrences(of: "Take the stairs", with: " Take the stairs")
        convertedString = convertedString.replacingOccurrences(of: "Destination", with: " Destination")
        return convertedString
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("dir seg \(segue.identifier!)")
        if segue.identifier! == "DirectionsSegue" {
            let controller = (segue.destination as? UIViewController) as?  DirectionsViewController
            controller!.route = stepsArray
            controller?.location = location! 
            controller?.locString = polyLine
        }
    }
    
    @IBAction func navigateButtonTouch(_ sender: Any) {
        
        
    }
    

}
