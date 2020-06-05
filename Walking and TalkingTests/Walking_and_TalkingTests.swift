//
//  Walking_and_TalkingTests.swift
//  Walking and TalkingTests
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import XCTest
import UIKit
import CoreLocation
@testable import Walking_and_Talking

class Walking_and_TalkingTests: XCTestCase {
    
    
    func testAddRemoveFav() throws{
        let newPlace = Place(uuid: "uuid", name: "test", latitude: 11.23, longitude: 12.67, open: true, category: "test cat")
        try? savedData.shared.addFavourite(location: newPlace)
        sleep(1)
        var loaded = try? savedData.shared.loadFavourites()
        XCTAssertTrue(loaded!.count>1, "found \(loaded![0].uuid)")
        XCTAssertEqual(newPlace.uuid, loaded![0].uuid)
        print("IN HERE")
        try? savedData.shared.removeFav(id: newPlace.uuid!)
        sleep(1)
        loaded = try? savedData.shared.loadFavourites()
        
        XCTAssertTrue(loaded!.count == 1) // as there is a default value for data population will always be 1
    }

    
    func testAddCategory() throws{
        let titles = ["one","two", "three"]
        try? savedData.shared.saveCategries(list: titles)
        let loaded = try? savedData.shared.loadCategroies()
        XCTAssertEqual(titles,loaded);

    }
    
    
}
