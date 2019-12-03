//
//  LocationTableViewCell.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 04/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import AVFoundation

class LocationTableViewCell: UITableViewCell {

    static let shared = LocationTableViewCell()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.locationLabel.text = "Locating You..."
        self.locationLabel.adjustsFontSizeToFitWidth = true
        if (delegate.locationlist.last != nil){
                    delegate.getPlacemark(forLocation: delegate.locationlist.last!) {
                    (originPlacemark, error) in
                        if let err = error {
                            print(err)
                        } else if let placemark = originPlacemark {
                            // Do something with the placemark
                            if ((placemark.name) != nil) {
                                self.locationLabel.text = (placemark.name)!
                                let utterance = AVSpeechUtterance(string: (placemark.name)!)
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                                print("speech \(savedData.shared.getSettings()[2])")
                                utterance.rate = (Float(savedData.shared.getSettings()[2]))!/Float(10)

                                let synthesizer = AVSpeechSynthesizer()
                                synthesizer.speak(utterance)
                                
                            }else{
                                self.locationLabel.text = "Locating You..."
                            }
                        }
                    }
                }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLocaition(){
        if (delegate.locationlist.last != nil){
                    delegate.getPlacemark(forLocation: delegate.locationlist.last!) {
                    (originPlacemark, error) in
                        if let err = error {
                            print(err)
                        } else if let placemark = originPlacemark {
                            // Do something with the placemark
                            if ((placemark.name) != nil) {
                                self.locationLabel.text = (placemark.name)!
                                print("updated location \((placemark.name)!)")
//                                let utterance = AVSpeechUtterance(string: (placemark.name)!)
//                                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//                                utterance.rate = 0.5
//
//                                let synthesizer = AVSpeechSynthesizer()
//                                synthesizer.speak(utterance)
                                
                            }else{
                                self.locationLabel.text = "Locating You..."
                            }
                        }
                    }
                }
    }

}
