//
//  ViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var stationStatus: UILabel!
    
    //This value is passed by in `prepare(for:sender:)`
//    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationStatus.text = "All elevators at this station are working properly."
    }
    
    


}

