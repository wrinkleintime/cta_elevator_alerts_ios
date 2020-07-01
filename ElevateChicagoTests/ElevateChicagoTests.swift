//
//  ElevateChicagoTests.swift
//  ElevateChicagoTests
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import XCTest
import CoreData
@testable import ElevateChicago

class ElevateChicagoTests: XCTestCase {
    
    // Test CtaStation.Swift
    func testCtaStation() {
        let morseStation = CtaStation.init(map_id: "11111", station_name: "Morse", ada: true, red: true, blue: false, g: false, brn: false, p: false, pexp: false, y: false, pnk: false, o: false)
        XCTAssertNotNil(morseStation)
        XCTAssertEqual(morseStation.map_id, "11111")
        XCTAssertTrue(morseStation.red)
        XCTAssertFalse(morseStation.g)
    }
    
    // Test stations property in StationTableViewController
    func testStationTableViewControllerStations() {
        let vc = StationTableViewController.init()
        vc.stations = [NSManagedObject]()
        
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.stations)
        XCTAssertTrue(vc.stations.isEmpty)
    }
    
    // Test station property in StationViewController
    func testStationViewControllerStations() {
        let vc = StationViewController.init()
        vc.station = NSManagedObject()
        
        XCTAssertNotNil(vc)
        XCTAssertNotNil(vc.station)
    }
}
