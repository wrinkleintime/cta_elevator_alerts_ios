//
//  StationViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

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
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let station = station {
            stationName.text = station.name
            redLine.isHidden = !station.red
            blueLine.isHidden = !station.blue
            brownLine.isHidden = !station.brown
            greenLine.isHidden = !station.green
            orangeLine.isHidden = !station.orange
            pinkLine.isHidden = !station.pink
            purpleLine.isHidden = !station.purple
            blueLine.isHidden = !station.blue
            yellowLine.isHidden = !station.yellow
            
            if !station.hasAlert {
                if station.hasElevator{
                    alertDetails.text = "All elevators at this station are working properly."
                } else {
                    alertDetails.text = "There are no elevators at this station."
                }
            } else {
                if station.alertDetails.isEmpty {
                    alertDetails.text = "There is an elevator alert!"
                } else {
                    alertDetails.text = station.alertDetails
                }
            }
        }
    }
}

