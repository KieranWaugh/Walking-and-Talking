//
//  DirectionsViewController.swift
//  Walking and Talking
//
//  Created by Kieran Waugh on 28/01/2020.
//  Copyright © 2020 Kieran Waugh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DirectionsViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var route : [Direction] = []
    @IBOutlet weak var label: UILabel!
    
    var link: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = ""
        setupLabel()
    }
    
    func setupLabel(){
        for step in route{
            label.text = label.text! + "\n\(step.instruction!)"
        }
    }
   
    func updateInstructions(){
        
        
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

