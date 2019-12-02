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
    private var nearYouLocations : [String] = []
    
    let sectionTitle = ["", "Saved", "Near You"]
    var items = [[""],[""],[""]]
    var favourites : [Place] = []
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let fileManager = FileManager.default
    var documentsFolder : URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }
    
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        //locationLabel.adjustsFontSizeToFitWidth = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Location"
        
        //nearYouLocations = self.load()
        
        loadData()
        
        
        //tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        loadData()
        print("will appear data \(items)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func loadData(){
        favourites = try! savedData.shared.loadFavourites()
        print(savedData.shared.loadFavouritesNames())
        if (try! savedData.shared.loadCategroies().count == 0){
            //items = [["row"],savedData.shared.loadFavouritesNames(), ["New Category"]]
            items[0]=(["row"])
            items[1]=(savedData.shared.loadFavouritesNames())
            items[2]=(["New Category"])
        }else{
            nearYouLocations = try! savedData.shared.loadCategroies()
            //items = [["row"],savedData.shared.loadFavouritesNames(), nearYouLocations]
            items[0]=(["row"])
            items[1]=(savedData.shared.loadFavouritesNames())
            items[2]=(nearYouLocations)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationTableViewCell
            tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.updateLocaition()
        }
        
        if (indexPath.section == 2 && indexPath.item == 0){
            let alert = UIAlertController(title: "Name Category", message: "Enter a name for the category you would like to search.", preferredStyle: UIAlertController.Style.alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
                
                //getting the input values from user
                var category = alert.textFields?[0].text
                category = category?.trimmingCharacters(in: .illegalCharacters)
                category = category?.trimmingCharacters(in: .whitespacesAndNewlines)
                print("text is: \(category!)")
                self.nearYouLocations.append(category!)
                print(self.nearYouLocations)
                self.items = [["row"],savedData.shared.loadFavouritesNames(), self.nearYouLocations]
                savedData.shared.saveCategries(list: self.nearYouLocations)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
            alert.addAction(confirmAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "Enter text:"
                textField.isSecureTextEntry = false
                textField.autocapitalizationType = .words// for password input
                
            })
            
            self.present(alert, animated: true, completion: nil)
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
            print(indexPath.row)
            label.text = items[indexPath.section][indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            
            if (indexPath.item == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath)
                let label = cell.contentView.viewWithTag(6) as! UILabel
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
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 2 && indexPath.row != 0 {
            return UITableViewCell.EditingStyle.delete
        }else if indexPath.section == 1{
            if (items[1][indexPath.row] == "You Currently Have No Favourites."){
                return UITableViewCell.EditingStyle.none
            }else{
                return UITableViewCell.EditingStyle.delete
            }
        }
        else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return nil
        }else{
            return sectionTitle[section]
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 2){
            if editingStyle == .delete {
               self.nearYouLocations.remove(at: indexPath.row)
                self.items[indexPath.section].remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
                savedData.shared.saveCategries(list: nearYouLocations)
                
            }
        }
        
        if (indexPath.section == 1){
            if editingStyle == .delete {
                self.favourites.remove(at: indexPath.row)
                self.items[indexPath.section].remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
                savedData.shared.updateFavourites(locations: favourites)
                
                if items[1].count == 0 {
                    items[1].append( "You Currently Have No Favourites.")
                    tableView.reloadData()
                }
                
            }
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
        
        if segue.identifier == "favouriteSegue" {
            
            if let indexPath = tableView.indexPathForSelectedRow{
                print("segue \(favourites[indexPath.row])")
                print("segue \(favourites[indexPath.row].name!)")
             let title = favourites[indexPath.row].name
                if let controller = (segue.destination as? UINavigationController)?.topViewController as?  CategoryViewController{
                     controller.title = title! 
                 
               
                 
                 
                    controller.location = favourites[indexPath.row]
                     controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                     controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }

    }
    
    
    
}




