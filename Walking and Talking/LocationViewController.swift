//
//  FirstViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationViewController: UITableViewController {
    
    var placesClient: GMSPlacesClient!
    
    let sectionTitle = ["", "Saved", "Near You"]
    let items = [["row"],["saved 1", "saved 2"],["Restaurants", "transport", "Medical"]]
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    //@IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        //locationLabel.adjustsFontSizeToFitWidth = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Location"
        //tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
            tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.updateLocaition()
        }
    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")
            cell!.selectionStyle = .none
            return cell!
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath)
            
            let label = cell.contentView.viewWithTag(1) as! UILabel
            label.text = items[indexPath.section ][indexPath.item]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearCell", for: indexPath)
            let label = cell.contentView.viewWithTag(2) as! UILabel
            label.text = items[indexPath.section ][indexPath.item]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return nil
        }else{
            return sectionTitle[section]
        }

    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        }

        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 80
        }else{
            return 40
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NearYouSegue" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let title = items[indexPath.section ][indexPath.item]
                if let controller = (segue.destination as? UINavigationController)?.topViewController as?  NearYouViewController{
                    controller.title = title
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
}




