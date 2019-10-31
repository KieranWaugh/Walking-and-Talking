//
//  FirstViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    
    let sectionTitle = ["Saved", "Near You"]
    let items = [["saved 1", "saved 2"],["near 1", "near 2"]]
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.adjustsFontSizeToFitWidth = true
        

        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate.getPlacemark(forLocation: delegate.locationlist.last!) {
        (originPlacemark, error) in
            if let err = error {
                print(err)
            } else if let placemark = originPlacemark {
                // Do something with the placemark
                if ((placemark.name) != nil) {
                    print("placemark: \((placemark.name)!)")
                    self.locationLabel.text = (placemark.name)!
                }
                
                
            }
        }
    }
    

}

extension UIBarButtonItem {
    var view: UIView? {
        return value(forKey: "view") as? UIView
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.section][indexPath.item]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.section][indexPath.item]
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return mobileBrand[section].brandName
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        //view.backgroundColor = #colorLiteral(red: 1, green: 0.3653766513, blue: 0.1507387459, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = sectionTitle[section]
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}


