//
//  Station.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/17/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class Station {
    
    //MARK: Properties
    
    var id: String
    var name: String
    var alertDetails: String = ""
    var hasElevator: Bool = false
    var hasAlert: Bool = false
    var isFavorite: Bool = false
    var red: Bool = false
    var blue: Bool = false
    var brown: Bool = false
    var green: Bool = false
    var orange: Bool = false
    var pink: Bool = false
    var purple: Bool = false
    var yellow: Bool = false
    
    //MARK: Initialization
     
    init?(id: String, name: String, hasElevator: Bool, red: Bool, blue: Bool, brown: Bool, green: Bool, orange: Bool, pink: Bool, purple: Bool, yellow: Bool, hasAlert: Bool = false, alertDetails: String = "") {
        
        if id.isEmpty || name.isEmpty  {
            return nil
        }
        
        self.id = id
        self.name = name
        self.hasElevator = hasElevator
        self.red = red
        self.blue = blue
        self.brown = brown
        self.green = green
        self.orange = orange
        self.pink = pink
        self.purple = purple
        self.yellow = yellow
        self.hasAlert = hasAlert
        self.alertDetails = alertDetails
    }
}
