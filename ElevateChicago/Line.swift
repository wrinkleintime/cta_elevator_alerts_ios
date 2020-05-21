//
//  Line.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/18/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class Line {
    //MARK: Properties
    
    var icon: UIImage?
    var name: String
    var stationIDs: [String]
    
    //MARK: Initialization
     
    init?(icon: UIImage?, name: String, stationIDs: [String]) {
        
        if name.isEmpty  {
            return nil
        }
        
        self.icon = icon
        self.name = name
        self.stationIDs = stationIDs
    }
}

