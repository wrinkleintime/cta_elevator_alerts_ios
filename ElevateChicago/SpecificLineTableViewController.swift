//
//  SpecificLineTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/21/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class SpecificLineTableViewController: UITableViewController {
    
    //MARK: Properties
    var line: String = ""
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getStationsInOrder(name: line).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "SpecificLineTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SpecificLineTableViewCell else{
            fatalError("The dequeued cell is not an instance of SpecificLineTableViewCell.")
        }

        // Fetches the appropriate line for the data source layout.
        let stationID = getStationsInOrder(name: line)[indexPath.row]
        let station = getStationById(id: stationID)

        if let station = station {
            cell.name.text = station.value(forKeyPath: "name") as? String
        } else {
            cell.name.text = "No station!"
        }

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
        super.prepare(for: segue, sender: sender)

        guard let stationNavController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        
        guard let stationViewController = stationNavController.viewControllers[0] as? StationViewController else {
            fatalError("Unexpected viewConroller!")
        }

        guard let selectedStationCell = sender as? SpecificLineTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }

        guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        // Fetches the appropriate line for the data source layout.
        let stationID = getStationsInOrder(name: line)[indexPath.row]
        let selectedStation = getStationById(id: stationID)

        if let selectedStation = selectedStation {
            stationViewController.station = selectedStation
        } else {
            stationViewController.station = nil
        }
    }
    
    //MARK: Actions
    @IBAction func unwindFromDetail(sender: UIStoryboardSegue) {
        if sender.source is StationViewController {
            tableView.reloadData()
        }
    }
    
    
    //MARK: Private Methods
    private func getStationsInOrder(name: String) -> [String] {
        switch(name){
        case "Red":
            return ["40900", "41190", "40100", "41300", "40760", "40880", "41380", "40340", "41200", "40770", "40540", "40080", "41420", "41320", "41220", "40650", "40630", "41450", "40330", "41660", "41090", "40560", "41490", "41400", "41000", "40190", "41230", "41170", "40910", "40990", "40240", "41430", "40450"]
        case "Blue":
            return ["40890", "40820", "40230", "40750", "41280", "41330", "40550", "41240", "40060", "41020", "40570", "40670", "40590", "40320", "41410", "40490", "40380", "40370", "40790", "40070", "41340", "40430", "40350", "40470", "40810", "40220", "40250", "40920", "40970", "40010", "40180", "40980", "40390"]
        case "Brown":
            return ["41290", "41180", "40870", "41010", "41480", "40090", "41500", "41460", "41440", "41310", "40360", "41320", "41210", "40530", "41220", "40660", "40800", "40710", "40460", "40730", "40040", "40160", "40850", "40680", "41700", "40260", "40380"]
        case "Green":
            return ["40020", "41350", "40610", "41260", "40280", "40700", "40480", "40030", "41670", "41070", "41360", "40170", "41510", "41160", "40380", "40260", "41700", "40680", "41400", "41690", "41120", "40300", "41270", "41080", "40130", "40510", "41140", "40720", "40940", "40290"]
        case "Orange":
            return ["40930", "40960", "41150", "40310", "40120", "41060", "41130", "41400", "40850", "40160", "40040", "40730", "40380", "40260", "41700", "40680"]
        case "Pink":
            return ["40580", "40420", "40600", "40150", "40780", "41040", "40440", "40740", "40210", "40830", "41030", "40170", "41510", "41160", "40380", "40260", "41700", "40680", "40850", "40160", "40040", "40730"]
        case "Purple":
            return ["41050", "41250", "40400", "40520", "40050", "40690", "40270", "40840", "40900", "40540", "41320", "41210", "40530", "41220", "40660", "40800", "40710", "40460", "40380", "40260", "41700", "40680", "40850", "40160", "40040", "40730"]
        case "Yellow":
            return ["40140", "41680", "40900"]
        default:
            return []
        }
    }
    
    private func getStationById(id: String) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            let station = try managedContext.fetch(fetchRequest)
            
            if (station.count == 0){
                return nil
            } else {
                return station[0]
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
