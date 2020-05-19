//
//  StationTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/17/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import os.log

class StationTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var stations = [Station]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleStations()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "StationTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StationTableViewCell  else {
            fatalError("The dequeued cell is not an instance of StationTableViewCell.")
        }

        // Fetches the appropriate meal for the data source layout.
        let station = stations[indexPath.row]
        
        cell.stationName.text = station.name
        cell.redLine.isHidden = !station.red
        cell.blueLine.isHidden = !station.blue
        cell.brownLine.isHidden = !station.brown
        cell.greenLine.isHidden = !station.green
        cell.orangeLine.isHidden = !station.orange
        cell.pinkLine.isHidden = !station.pink
        cell.purpleLine.isHidden = !station.purple
        cell.blueLine.isHidden = !station.blue
        cell.yellowLine.isHidden = !station.yellow

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let stationDetailViewController = segue.destination as? StationViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
         
        guard let selectedStationCell = sender as? StationTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
         
        guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
         
        let selectedStation = stations[indexPath.row]
        stationDetailViewController.station = selectedStation
    }
    
    //MARK: Private Methods
     
    private func loadSampleStations() {
        guard let station1 = Station(id: "40100", name: "Morse", hasElevator: false, red: true, blue: false, brown: false, green: false, orange: false, pink: false, purple: false, yellow: false) else {
            fatalError("Unable to instantiate station1")
        }
        
        guard let station2 = Station(id: "40120", name: "35th/Archer", hasElevator: true, red: false, blue: false, brown: false, green: false, orange: true, pink: false, purple: false, yellow: false, hasAlert: true) else {
            fatalError("Unable to instantiate station2")
        }
        
        guard let station3 = Station(id: "40380", name: "Clark/Lake", hasElevator: true, red: false, blue: false, brown: false, green: true, orange: true, pink: true, purple: true, yellow: false, hasAlert: true, alertDetails: "The elevator at Clark/Lake is down!") else {
            fatalError("Unable to instantiate station3")
        }
        
        stations += [station1, station2, station3]
    }
}
