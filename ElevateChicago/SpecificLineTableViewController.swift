//
//  SpecificLineTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/21/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class SpecificLineTableViewController: UITableViewController {
    
//    //MARK: Properties
//    var line: LineModel?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return line?.stationIDs.count ?? 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cellIdentifier = "SpecificLineTableViewCell"
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SpecificLineTableViewCell else{
//            fatalError("The dequeued cell is not an instance of SpecificLineTableViewCell.")
//        }
//
//        // Fetches the appropriate line for the data source layout.
//        let station = line?.stationIDs[indexPath.row]
//
//        cell.name.text = station
//
//        return cell
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        guard let stationDetailViewController = segue.destination as? StationViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//        guard let selectedStationCell = sender as? SpecificLineTableViewCell else {
//            fatalError("Unexpected sender: \(String(describing: sender))")
//        }
//
////        guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
////            fatalError("The selected cell is not being displayed by the table")
////        }
////
////        let selectedStation = line?.stationIDs[indexPath.row]
//
////        stationDetailViewController.station = StationModel(id: "40100", name: "Morse", hasElevator: false, red: true, blue: false, brown: false, green: false, orange: false, pink: false, purple: false, yellow: false)
//    }
}
