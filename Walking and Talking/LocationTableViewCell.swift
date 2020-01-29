//
//  LocationTableViewCell.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 04/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import AVFoundation

class LocationTableViewCell: UITableViewCell, AVSpeechSynthesizerDelegate {

    static let shared = LocationTableViewCell()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var locationLabel: UILabel!
    var synth = AVSpeechSynthesizer()

    //var isSpeaking = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        synth.delegate = self
        self.locationLabel.text = "Locating You..."
        self.locationLabel.adjustsFontSizeToFitWidth = true
        if (delegate.locationlist.last != nil){
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\((delegate.locationlist.last?.coordinate.latitude)!),\((delegate.locationlist.last?.coordinate.longitude)!)&type=point_of_interest&radius=100&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc"
            print(url)
            savedData.shared.getBuilding(downloadURL: url){(originPlacemark) in
                    if ((originPlacemark) != nil) {
                        self.locationLabel.text = (originPlacemark)
                        if (savedData.shared.isSpeaking == false){
                            savedData.shared.isSpeaking = true
                            self.speak(place: originPlacemark)
                        }
                    
                    }else{
                        self.locationLabel.text = "Locating You..."
                    }

            }
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func speak(place: String){
        print("in speaking")
        let utterance = AVSpeechUtterance(string:" You are currently located near: \(place)")
        utterance.voice = AVSpeechSynthesisVoice(language: "\(savedData.shared.getSettings()[4])")
        utterance.rate = (Float(savedData.shared.getSettings()[2]))!/Float(10)
        self.synth.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // do something useful here ...
        savedData.shared.isSpeaking = false
    }
    
    

}


