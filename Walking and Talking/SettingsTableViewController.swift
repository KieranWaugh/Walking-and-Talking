//
//  SettingsTableViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 20/02/2020.
//  Copyright © 2020 Kieran Waugh. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var rateSelector: UISlider!
    
    @IBOutlet weak var accentSelector: UITextField!
    @IBOutlet weak var timerSlider: UISlider!
    @IBOutlet weak var picker: UIPickerView!
    
    let languageItems = ["English - UK", "English - US", "English - IE", "English - ZA", "English - AU"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateSelector.setValue(Float(savedData.shared.getSettings()[2])!, animated: true)
        timerSlider.setValue(Float(savedData.shared.getSettings()[3])!, animated: true)
        accentSelector.text = "\(savedData.shared.getSettings()[4])"
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        accentSelector.inputView = pickerView
        picker.isHidden = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue //UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        accentSelector.inputAccessoryView = toolBar

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
        accentSelector.text = languageItems[row]
        
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
    
    
    @IBAction func rateChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        savedData.shared.updateSettings(index: 2, value: String(currentValue))
    }
    
    @IBAction func timerChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        savedData.shared.updateSettings(index: 3, value: String(currentValue))
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    

}
