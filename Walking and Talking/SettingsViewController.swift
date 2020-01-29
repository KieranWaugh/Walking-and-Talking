//
//  SettingsViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 03/12/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    

    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var speechRateSlider: UISlider!
    @IBOutlet weak var speechRateLabel: UILabel!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var languageField: UITextField!
    @IBOutlet weak var langugePicker: UIPickerView!
    
    let languageItems = ["English - UK", "English - US", "English - IE", "English - ZA", "English - AU"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusSlider.setValue(Float(savedData.shared.getSettings()[1])!, animated: true)
        speechRateSlider.setValue(Float(savedData.shared.getSettings()[2])!, animated: true)
        timerSlider.setValue(Float(savedData.shared.getSettings()[3])!, animated: true)
        radiusLabel.text = "\(savedData.shared.getSettings()[1]) metres"
        speechRateLabel.text = "\(savedData.shared.getSettings()[2])X"
        timerLabel.text = "\(savedData.shared.getSettings()[3]) Mins"
        languageField.text = "\(savedData.shared.getSettings()[4])"
        let pickerView = UIPickerView()
        pickerView.delegate = self
        languageField.inputView = pickerView
        langugePicker.isHidden = true
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        languageField.inputAccessoryView = toolBar
        // Do any additional setup after loading the view.
    }
    

    @IBAction func radiusChanged(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        radiusLabel.text = "\(currentValue) metres"
        print("before setting \(savedData.shared.getSettings()[1])")
        savedData.shared.updateSettings(index: 1, value: String(currentValue))
        print("after setting \(savedData.shared.getSettings()[1])")
    }
    
    @IBAction func speechRateSliderChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        speechRateLabel.text = "\(currentValue)X"
        savedData.shared.updateSettings(index: 2, value: String(currentValue))
    }
    
    
    @IBAction func timerSliderChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        timerLabel.text = "\(currentValue) Mins"
        savedData.shared.updateSettings(index: 3, value: String(currentValue))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageField.text = languageItems[row]
        
        switch languageItems[row] {
        case "English - UK":
            savedData.shared.updateSettings(index: 4, value: "en-GB")
        case "English - US":
            savedData.shared.updateSettings(index: 4, value: "en-US")
        case "English - IE":
            savedData.shared.updateSettings(index: 4, value: "en-IE")
        case "English - ZA":
            savedData.shared.updateSettings(index: 4, value: "en-ZA")
        case "English -AU":
            savedData.shared.updateSettings(index: 4, value: "en-AU")
        default:
            savedData.shared.updateSettings(index: 4, value: "en-GB")
        }
    }
    
    @objc func donePicker(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //langu.isHidden = false
        return false
    }
}
