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

class CategoryViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var favButton: UIButton!
    
    
    var location: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupFavButton()

        // Do any additional setup after loading the view.
    }
    
    func setupFavButton(){
        print("favs " , savedData.shared.Favoutites)
        if savedData.shared.Favoutites.contains((location?.uuid!)!){
            favButton.setTitle("Un-Favourite", for: .normal)
            favButton.backgroundColor = .green
        }
    }
    
    func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: (location?.latitude!)!, longitude: (location?.longtude!)!, zoom: 18.0)
        mapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location?.latitude!)!, longitude: (location?.longtude!)!)
        marker.title = self.title
        marker.map = mapView
    }
    
    @IBAction func favButton(_ sender: Any) {
        //let loc = Place(uuid: UUID(), name: "Test", latitude: 55.944466, longitude: -3.1868697294240014, open: true)
        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
