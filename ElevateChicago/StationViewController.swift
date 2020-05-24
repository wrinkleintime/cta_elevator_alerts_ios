//
//  StationViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class StationViewController: UIViewController {

    //MARK: Properties

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var redLine: UIView!
    @IBOutlet weak var brownLine: UIView!
    @IBOutlet weak var greenLine: UIView!
    @IBOutlet weak var orangeLine: UIView!
    @IBOutlet weak var pinkLine: UIView!
    @IBOutlet weak var purpleLine: UIView!
    @IBOutlet weak var blueLine: UIView!
    @IBOutlet weak var yellowLine: UIView!
    @IBOutlet weak var alertDetails: UILabel!
    
    //This value is passed by in `prepare(for:sender:)`
    var station: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let station = station {
//            stationName.text = station.name
//            redLine.isHidden = !station.red
//            blueLine.isHidden = !station.blue
//            brownLine.isHidden = !station.brown
//            greenLine.isHidden = !station.green
//            orangeLine.isHidden = !station.orange
//            pinkLine.isHidden = !station.pink
//            purpleLine.isHidden = !station.purple
//            blueLine.isHidden = !station.blue
//            yellowLine.isHidden = !station.yellow
            
            
            stationName.text = station.value(forKeyPath: "name") as? String
            redLine.isHidden = !(station.value(forKeyPath: "red") != nil)
            blueLine.isHidden = !(station.value(forKeyPath: "blue") != nil)
            brownLine.isHidden = !(station.value(forKeyPath: "brown") != nil)
            greenLine.isHidden = !(station.value(forKeyPath: "green") != nil)
            orangeLine.isHidden = !(station.value(forKeyPath: "orange") != nil)
            pinkLine.isHidden = !(station.value(forKeyPath: "pink") != nil)
            purpleLine.isHidden = !(station.value(forKeyPath: "purple") != nil)
            blueLine.isHidden = !(station.value(forKeyPath: "blue") != nil)
            yellowLine.isHidden = !(station.value(forKeyPath: "yellow") != nil)
            
            if !(station.value(forKeyPath: "hasAlert") != nil) {
                if (station.value(forKeyPath: "hasElevator") != nil){
                    alertDetails.text = "All elevators at this station are working properly."
                } else {
                    alertDetails.text = "There are no elevators at this station."
                }
//            } else {
//                if ((station.value(forKeyPath: "alertDetails")) as? String).isEmpty {
//                    alertDetails.text = "There is an elevator alert!"
//                } else {
//                    alertDetails.text = station.alertDetails
//                }
//            }
            
//            if !station.hasAlert {
//                if station.hasElevator{
//                    alertDetails.text = "All elevators at this station are working properly."
//                } else {
//                    alertDetails.text = "There are no elevators at this station."
//                }
//            } else {
//                if station.alertDetails.isEmpty {
//                    alertDetails.text = "There is an elevator alert!"
//                } else {
//                    alertDetails.text = station.alertDetails
//                }
//            }
            }
        }
    }
}

