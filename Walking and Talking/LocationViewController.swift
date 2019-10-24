//
//  FirstViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 22/10/2019.
//  Copyright © 2019 Kieran Waugh. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //title = "veryyyyyyyyyyyy lonnnnnnnng tilleeeeee"
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        //adjustLargeTitleSize()
        locationLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate.getPlacemark(forLocation: delegate.locationlist.last!) {
        (originPlacemark, error) in
            if let err = error {
                print(err)
            } else if let placemark = originPlacemark {
                // Do something with the placemark
                print("placemark: \((placemark.name)!)")
                self.locationLabel.text = (placemark.name)!
                //self.title = "Location\((placemark.name)!)"
                
            }
        }
    }
    

}

extension UIBarButtonItem {
    var view: UIView? {
        return value(forKey: "view") as? UIView
    }
}

//extension UIViewController {
//  func adjustLargeTitleSize() {
//    guard let title = title, #available(iOS 11.0, *) else { return }
//
//    let maxWidth = UIScreen.main.bounds.size.width - 60
//    var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
//    var width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
//
//    while width > maxWidth {
//      fontSize -= 1
//        width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
//    }
//
//    if var titleAttributes = navigationController?.navigationBar.largeTitleTextAttributes {
//        titleAttributes[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: fontSize)
//        navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
//
//    }
//  }
//}


