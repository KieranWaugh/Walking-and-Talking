//
//  SettingsViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 03/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusSlider.setValue(Float(savedData.shared.getSettings()[1])!, animated: true)
        radiusLabel.text = savedData.shared.getSettings()[1]
        timerLabel.text = savedData.shared.getSettings()[2]

        // Do any additional setup after loading the view.
    }
    

    @IBAction func radiusChanged(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        radiusLabel.text = "\(currentValue)"
        print("before setting \(savedData.shared.getSettings()[1])")
        savedData.shared.updateSettings(index: 1, value: String(currentValue))
        print("after setting \(savedData.shared.getSettings()[1])")
    }
    
    
    @IBAction func timerChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
         timerLabel.text = "\(currentValue)"
        savedData.shared.updateSettings(index: 2, value: String(currentValue))
        
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
