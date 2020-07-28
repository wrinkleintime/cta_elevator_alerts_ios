//
//  StationViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class StationViewController: UIViewController, UINavigationControllerDelegate {

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
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var accessibleLineNames: UILabel!
    
    //This value is passed by in `prepare(for:sender:)`
    var station: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let station = station {
            stationName.text = station.value(forKeyPath: "name") as? String
            
            // Allow for differentiation without color
            if UIAccessibility.shouldDifferentiateWithoutColor{
                redLine.isHidden = true
                blueLine.isHidden = true
                brownLine.isHidden = true
                greenLine.isHidden = true
                orangeLine.isHidden = true
                pinkLine.isHidden = true
                purpleLine.isHidden = true
                blueLine.isHidden = true
                yellowLine.isHidden = true
                
                accessibleLineNames.isHidden = false
                var name = ""
                            
                if (station.value(forKeyPath: "red") as? Bool ?? true){
                    name += "R/"
                }
                if (station.value(forKeyPath: "blue") as? Bool ?? true){
                    name += "Blu/"
                }
                if (station.value(forKeyPath: "brown") as? Bool ?? true){
                    name += "Brn/"
                }
                if (station.value(forKeyPath: "green") as? Bool ?? true){
                    name += "G/"
                }
                if (station.value(forKeyPath: "orange") as? Bool ?? true){
                    name += "O/"
                }
                if (station.value(forKeyPath: "pink") as? Bool ?? true){
                    name += "Pnk/"
                }
                if (station.value(forKeyPath: "purple") as? Bool ?? true){
                    name += "Pur/"
                }
                if (station.value(forKeyPath: "yellow") as? Bool ?? true){
                    name += "Y/"
                }
                
                name = String(name.dropLast())
                accessibleLineNames.text = name
            } else {
                accessibleLineNames.isHidden = true
                redLine.isHidden = !(station.value(forKeyPath: "red") as? Bool ?? true)
                blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
                brownLine.isHidden = !(station.value(forKeyPath: "brown") as? Bool ?? true)
                greenLine.isHidden = !(station.value(forKeyPath: "green") as? Bool ?? true)
                orangeLine.isHidden = !(station.value(forKeyPath: "orange") as? Bool ?? true)
                pinkLine.isHidden = !(station.value(forKeyPath: "pink") as? Bool ?? true)
                purpleLine.isHidden = !(station.value(forKeyPath: "purple") as? Bool ?? true)
                blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
                yellowLine.isHidden = !(station.value(forKeyPath: "yellow") as? Bool ?? true)
            }
            
            //Display the correct elevator status details.
            if !(station.value(forKeyPath: "hasElevator") as? Bool ?? true){
                alertDetails.text = "There are no elevators at this station."
            } else {
                if (station.value(forKeyPath: "hasAlert") as? Bool ?? true) {
                    let str = station.value(forKeyPath: "alertDetails") as? String
                    alertDetails.text = str?.replacingOccurrences(of: "temp.", with: "temporarily")
                } else{
                    alertDetails.text = "All elevators at this station are working properly!"
                }
            }
            
            favoriteButton.isEnabled = false
            favoriteButton.tintColor = UIColor.clear
        }
    }
}

