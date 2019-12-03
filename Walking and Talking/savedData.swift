//
//  savedData.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 30/11/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import Foundation



class savedData {
    
    static let shared = savedData()
    
    var Favoutites : [String] = []
    
    var Settings : [String] = ["default", "100", "5", "1", "en-gb"]
    // [0] - default ["default", "100"]
    // [1] - radius
    // [2] - speach rate
    // [3] - timer
    // [4] - speech region
    
    public func saveCategries(list: [String]){
        let dir = try? FileManager.default.url(for: .documentDirectory,
        in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = dir?.appendingPathComponent("savedcategories").appendingPathExtension("plist")
        (list as NSArray).write(to: fileURL!, atomically: true)
    }
    
    func loadCategroies() throws ->[String]{
        let dir = try? FileManager.default.url(for: .documentDirectory,
        in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = dir?.appendingPathComponent("savedcategories").appendingPathExtension("plist")
        
        var savedArray = NSArray(contentsOf: fileURL!) as? [String]
        
        if (savedArray == nil){
            savedArray = ["New Category"]
        }
        
        print("saved is: \(savedArray!)")
        return savedArray!
    }
    
    func addFavourite(location: Place){
        var currentList : [Place] = try! loadFavourites()
        print("current list \(currentList)")
        print("place name is \(location.name!)")
        currentList.append(location)
        print(currentList)
        let placesData = try! JSONEncoder().encode(currentList)
        UserDefaults.standard.set(placesData, forKey: "favourites")
            
    }
    
    func updateFavourites(locations: [Place]){
        
        let placesData = try! JSONEncoder().encode(locations)
        UserDefaults.standard.set(placesData, forKey: "favourites")
    }
    
    func loadFavourites() throws -> [Place]{
        Favoutites = []
        let placeData = UserDefaults.standard.data(forKey: "favourites")
        var placeArray : [Place] = []
        //return placeArray
        
        if (placeData == nil){
            print("is nil")
            let location = Place(uuid: "default", name: "You Currently Have No Favourites.", latitude: 0, longitude: 0, open: false, category: "default")
            placeArray = [location]
            return placeArray
            
        }else{
            placeArray = try! JSONDecoder().decode([Place].self, from: placeData!)
            if (placeArray.count == 0){
                let location = Place(uuid: "default", name: "You Currently Have No Favourites.", latitude: 0, longitude: 0, open: false, category: "default")
                placeArray = [location]
                return placeArray
            }
            
            if placeArray[0].name == "You Currently Have No Favourites." && placeArray.count >= 1 {
                placeArray.removeFirst()
            }
            print("fav count \(placeArray.count)")
            for item in placeArray {
                Favoutites.append(item.uuid!)
            }
            return placeArray
        }
        
        
    }
    
    func removeFav(id : String){
        let currentList : [Place] = try! loadFavourites()
        var counter = 0
        for item in currentList {
            print("found item at index \(counter)")
            if item.uuid == id{
                Favoutites.remove(at: counter)
                var favs = try! loadFavourites()
                favs.remove(at: counter)
                updateFavourites(locations: favs)
            }else{
                counter += 1
            }
        }
    }
    
    func loadFavouritesNames() -> [String] {
        let favourites = try! loadFavourites()
        var names : [String] = []
        for place in favourites {
            names.append((place.name!))
        }
        return names
    }
    
    func updateSettings(index: Int, value: String){
        Settings[index] = value
        //Settings = ["default", "100", "5", "1", "en-gb"]
        //Settings = ["default", "100", "5", "en-gb"] // for debugging
        print("updates settings \(Settings)")
        let settingsData = try! JSONEncoder().encode(Settings)
        UserDefaults.standard.set(settingsData, forKey: "settings")
    }
    
    func getSettings() -> [String]{
        print("settings getting")
        let settingsData = UserDefaults.standard.data(forKey: "settings")
        var settingsArray : [String] = []
        
        if (settingsData == nil){
            print("settings is nil")
            Settings = ["default", "100", "5", "1", "en-gb"]
            return Settings
            
        }else{
            settingsArray = try! JSONDecoder().decode([String].self, from: settingsData!)
            if (settingsArray.count == 0){
                print("settings is 0")
                Settings = ["default", "100", "5", "1", "en-gb"]
                return settingsArray
            }
            print("saved settings \(settingsArray)")
            return settingsArray
        }
    }
    
    
}
