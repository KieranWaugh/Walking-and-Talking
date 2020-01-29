//
//  NearYouViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 02/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class NearYouViewController: UITableViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var downloadURL = ""
    var list : [Result] = []
    var nameList : [String] = []
    struct Collection: Decodable { // or Decodable
      let results: [Result]
    }
    
    struct Result : Decodable {
        let name : String
        let geometry : Geometry
        let id : String
        let opening_hours : Opening_Hours?
    }
    
    struct Geometry : Decodable{
        let location : Location
    }
    
    struct Location : Decodable {
        let lat : Double
        let lng :Double
    }
    
    struct Opening_Hours : Decodable {
        let open_now : Bool?
        
        enum CodingKeys: String, CodingKey {
            case openNow = "open_now"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.open_now = try container.decodeIfPresent(Bool.self, forKey: .openNow)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\((delegate.locationlist.last?.coordinate.latitude)!),\((delegate.locationlist.last?.coordinate.longitude)!)&radius=\(savedData.shared.getSettings()[1])&keyword=\((self.title)!)&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc")
        downloadURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\((delegate.locationlist.last?.coordinate.latitude)!),\((delegate.locationlist.last?.coordinate.longitude)!)&radius=\(savedData.shared.getSettings()[1])&keyword=\((self.title)!)&key=AIzaSyDj4mKyfextSfHk-0K89rCnG5H01ydabZc"

        dataDownload()
    }
    
    func dataDownload(){
        print(downloadURL)
        downloadURL = downloadURL.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: downloadURL) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     let res = try JSONDecoder().decode(Collection.self, from: data)
                    print(res)
                    for result in res.results {
                        self.nameList.append(result.name)
                        self.list.append(result)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                        }
                     }
                  } catch let error {
                     print("error is ", error)
                  }
               }
           }.resume()
        }
           
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "INFO", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if (nameList.count == 0){
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)
        let label = cell.contentView.viewWithTag(3) as! UILabel
        label.text = "loading data..."
        return cell
    }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)
        let label = cell.viewWithTag(3) as! UILabel
        label.text = nameList[indexPath.row]
        return cell
    }
    
    
   }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //showError(message: "location is \(list[indexPath.row].geometry.location.lat), \(list[indexPath.row].geometry.location.lng)")
        //performSegue(withIdentifier: "categorySegue", sender: list[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "categorySegue" {
               if let indexPath = tableView.indexPathForSelectedRow{
                let title = list[indexPath.row].name
                   if let controller = (segue.destination as? UINavigationController)?.topViewController as?  CategoryViewController{
                        controller.title = title
                    
                  
                    let location = Place(uuid:list[indexPath.row].id, name:list[indexPath.row].name, latitude:list[indexPath.row].geometry.location.lat, longitude:list[indexPath.row].geometry.location.lng, open:list[indexPath.row].opening_hours?.open_now ?? true, category: self.title!)
                    
                    controller.location = location
                        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                        controller.navigationItem.leftItemsSupplementBackButton = true
                   }
               }
           }
       }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? LocationViewController {
            controller.tableView.reloadData()
        }
    }

}


