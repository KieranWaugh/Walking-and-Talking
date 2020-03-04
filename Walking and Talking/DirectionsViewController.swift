//
//  DirectionsViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 28/01/2020.
//  Copyright © 2020 Kieran Waugh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import AVFoundation
import GoogleMaps
import CoreMotion

class DirectionsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let motionActivityManager = CMMotionActivityManager()
    var synth = AVSpeechSynthesizer()
    var route : [Direction] = []
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var endButton: UIButton!
    var currentDirection = 0
    var timer : Timer? = nil
    var link: String = ""
    @IBOutlet weak var directionImageView: UIImageView!
    var location: Place? = nil
    var locString: String = ""
    var inInstruction = false
    var isMoving = true
    var polyline : GMSPolyline? = nil
    var numberOfInstructions = 0
    var updateDistance = 0.0
    var lastDistance : CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        label.accessibilityElementsHidden = true
        label.text = ""
        self.lastDistance = (self.delegate.locationlist.last)!
        updateInstructions()
        synth.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(DirectionsViewController.startNavigation), userInfo: nil, repeats: true)
        
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
            if (activity?.running)! {
                print("User is running")
                self.isMoving = true
            }
            if (activity?.walking)! {
                print("User is walking")
                self.isMoving = true
            }
            if (activity?.stationary)! {
                print("User is standing")
                self.isMoving = false
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
   
    
    
   
    func updateInstructions(){
        self.showSpinner(onView: self.view)
        let items = route.count
        var count = 0
        
        for r in route {
            
            let currentText = r.instruction
            var newText = ""
            
            if (delegate.locationlist.last != nil){
                let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\((r.startLat)!),\((r.startLng)!)&type=point_of_interest&radius=100&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc"
                savedData.shared.getBuilding(downloadURL: url){(originPlacemark) in
                        if ((originPlacemark) != nil) {
                            newText = currentText! + ", near \(originPlacemark)"
                            r.instruction = newText
                            r.setInstruction(new: newText)
                            count = count + 1
                            if (count == items){
                                
                                print("last \(self.lastDistance)")
                                self.removeSpinner()
                                self.numberOfInstructions = self.route.count
                                
                                self.startNavigation()
                                
                            }
                        }else{
                            
                        }
                }
            }
        }
    }
    var comparison = 0
    
    func updateUser(distance: Double, inst: String, routeDisance: Double){
        var numberOftimes = 0
        
        let legDistance = routeDisance
        
        if(legDistance >= 100){
            numberOftimes = 4
        }else if(legDistance < 100 && legDistance > 50){
            numberOftimes = 2
        }else if(legDistance >= 50 && legDistance < 25){
            numberOftimes = 1
        }else{
            numberOftimes = 1
        }
        
        let distToUpdate = (legDistance - 3)/Double(numberOftimes)
        
        print("updateUser \(legDistance), \(distToUpdate), \(updateDistance), \(numberOftimes), \(comparison), \(route[currentDirection].instruction!)")
        
        if (updateDistance >= Double(distToUpdate)){
            comparison += 1
            updateDistance = 0
            
            if (currentDirection + 1 == numberOfInstructions){
                speak(txt: "arrive in aproximately \(Int(round(distance))) meters")
            }else{
                if(comparison < numberOftimes){
                    speak(txt: "continue for aproximately \(Int(round(distance))) meters")
                }else{
                    speak(txt: "continue for aproximately \(Int(round(distance))) meters then \(inst)")
                    
                }
            }
        }
        
    }
    
    var counter = 1
    var currentLoc : CLLocation? = nil
    var endloc: CLLocation? = nil
    
    @objc func startNavigation(){

        if (currentDirection == 0){
            currentLoc = delegate.locationlist.last!
        }
        
        
        
        
        if (self.currentDirection != route.count){
            
            let endlat = Double(self.route[self.currentDirection].endLat!)
            let endlng = Double(self.route[self.currentDirection].endLng!)
            endloc = CLLocation(latitude: endlat!, longitude: endlng!)
            
        }
        
        
        
            if (self.currentDirection == route.count){
                self.endButtonPressed(self)
                self.speak(txt: "Arrived at destination")
                self.inInstruction = false

            }else{
                print("man \(inInstruction) \(currentDirection)")
                if (!inInstruction){
                    self.inInstruction = true
                    
                    if (currentDirection + 1 == numberOfInstructions){
                        self.label.text = self.route[self.currentDirection].instruction!
                        self.speak(txt: self.route[self.currentDirection].instruction!)
                        
                    }else{
                        self.label.text = self.route[self.currentDirection].instruction! + " then continue for approximately " + self.route[self.currentDirection].time!
                            self.speak(txt: self.route[self.currentDirection].instruction! + " then continue for approximately " + self.route[self.currentDirection].time!)
                            self.DisplayDirectionAsset(manouver: (self.route[self.currentDirection].maneuver)!)
                            print("man before - \((self.route[self.currentDirection].maneuver)!)")
                            //self.inInstruction = true
                            self.counter = 1
                        }
                }
                    
                let lat = Double(self.route[self.currentDirection].startLat!)
                let lng = Double(self.route[self.currentDirection].startLng!)
                let userLoc = self.delegate.locationlist.last!
                let loc = CLLocation(latitude: lat!, longitude: lng!)
                let MinDistance = 3.0
                let distance = loc.distance(from: userLoc)
                print(distance)
                
                var convString = ""
                if (self.currentDirection + 1 != numberOfInstructions){
                    convString = (self.route[self.currentDirection + 1].maneuver?.replacingOccurrences(of: "-", with: " "))!
                }
                
                
                if (inInstruction){
                    if (Double(self.route[self.currentDirection].distance!) > 25.0){
                        updateUser(distance: distance, inst: convString, routeDisance: (endloc?.distance(from: currentLoc!))!)
                    }
                    
                }
                
                updateDistance = updateDistance + (userLoc.distance(from: lastDistance!))
                lastDistance = userLoc
                //print("update \(updateDistance) - \(updateDist) - \(lastDistance!)")
                
                if distance <= MinDistance {
                    inInstruction = false
                    print("direction: moving up")
                    self.currentDirection = self.currentDirection + 1
                    comparison = 0
                    currentLoc = delegate.locationlist.last!
                    self.startNavigation()
                }
                
                
            }
    }
    
    func DisplayDirectionAsset(manouver: String){
        print("man: " + manouver)
        switch manouver{
        case "turn-slight-left":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.left")
        case "turn-sharp-left":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.left")
        case "turn-left":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.left")
            print("man in here")
        case "turn-slight-right":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.right")
        case "turn-sharp-right":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.right")
        case "turn-right":
            directionImageView.image = UIImage(systemName: "arrow.turn.up.right")
            print("man in here")
        case "straight":
            directionImageView.image = UIImage(systemName: "arrow.up")
        default:
            directionImageView.image = UIImage(systemName: "arrow.up")
            
        }
    }
    
    @IBAction func endButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
            self.dismiss(animated: true, completion: {})
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func speak(txt: String){
        savedData.shared.isSpeaking = true
        print("in speaking")
        let utterance = AVSpeechUtterance(string: txt)
        utterance.voice = AVSpeechSynthesisVoice(language: "\(savedData.shared.getSettings()[4])")
        utterance.rate = (Float(savedData.shared.getSettings()[2]))!/Float(10)
        self.synth.speak(utterance)
        savedData.shared.isSpeaking = false
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        savedData.shared.isSpeaking = false
    }
    
    

}
var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
