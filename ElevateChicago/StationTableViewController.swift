//
//  StationTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/17/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class StationTableViewController: UITableViewController {
    
    //MARK: Properties
    var stations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        do{
            stations = try managedContext.fetch(fetchRequest)
            // Load the sample data.
            if (stations.count == 0){
                loadSampleStations()
                stations = try managedContext.fetch(fetchRequest)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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

        // Fetches the appropriate station for the data source layout.
        let station = stations[indexPath.row]
        
        cell.stationName.text = station.value(forKeyPath: "name") as? String
        cell.redLine.isHidden = !(station.value(forKeyPath: "red") as? Bool ?? true)
        cell.blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
        cell.brownLine.isHidden = !(station.value(forKeyPath: "brown") as? Bool ?? true)
        cell.greenLine.isHidden = !(station.value(forKeyPath: "green") as? Bool ?? true)
        cell.orangeLine.isHidden = !(station.value(forKeyPath: "orange") as? Bool ?? true)
        cell.pinkLine.isHidden = !(station.value(forKeyPath: "pink") as? Bool ?? true)
        cell.purpleLine.isHidden = !(station.value(forKeyPath: "purple") as? Bool ?? true)
        cell.blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
        cell.yellowLine.isHidden = !(station.value(forKeyPath: "yellow") as? Bool ?? true)

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
        
        switch(segue.identifier ?? "") {

            case "ShowDetail":
                guard let stationViewController = segue.destination as? StationViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                 
                guard let selectedStationCell = sender as? StationTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                 
                guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                 
                let selectedStation = stations[indexPath.row]
                stationViewController.station = selectedStation
            
            case "ShowAllLines":
                return
//                guard let allLinesViewController = segue.destination as? LineTableViewController else {
//                    fatalError("Unexpected destination: \(segue.destination)")
//                }
                 
//                guard let selectedStationCell = sender as? StationTableViewCell else {
//                    fatalError("Unexpected sender: \(String(describing: sender))")
//                }
//
//                guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
//                    fatalError("The selected cell is not being displayed by the table")
//                }
//
//                let selectedStation = stations[indexPath.row]
//                stationDetailViewController.station = selectedStation
//
        default:
               fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Methods
     
    private func loadSampleStations() {
        save(id: "40100", name: "Morse", hasElevator: false, red: true, blue: false, brown: false, green: false, orange: false, pink: false, purple: false, yellow: false)

        save(id: "40120", name: "35th/Archer", hasElevator: true, red: false, blue: false, brown: false, green: false, orange: true, pink: false, purple: false, yellow: false)
        
        save(id: "40380", name: "Clark/Lake", hasElevator: true, red: false, blue: false, brown: false, green: true, orange: true, pink: true, purple: true, yellow: false)
    }
    
    private func save(id: String, name: String, hasElevator: Bool, red: Bool, blue: Bool, brown: Bool, green: Bool, orange: Bool, pink: Bool, purple: Bool, yellow: Bool) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
      
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Station",
                                   in: managedContext)!
        let station = NSManagedObject(entity: entity, insertInto: managedContext)
      
        station.setValue(name, forKeyPath: "name")
        print(name)
        station.setValue("", forKeyPath: "alertDetails")
        station.setValue(id, forKeyPath: "id")
        station.setValue(false, forKeyPath: "hasAlert")
        station.setValue(hasElevator, forKeyPath: "hasElevator")
        station.setValue(false, forKeyPath: "isFavorite")
        station.setValue(blue, forKeyPath: "blue")
        station.setValue(brown, forKeyPath: "brown")
        station.setValue(green, forKeyPath: "green")
        station.setValue(orange, forKeyPath: "orange")
        station.setValue(pink, forKeyPath: "pink")
        station.setValue(purple, forKeyPath: "purple")
        station.setValue(red, forKeyPath: "red")
        print(red)
        station.setValue(yellow, forKeyPath: "yellow")

        do {
            try managedContext.save()
            stations.append(station)
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    /*
    //For testing only

    private func deleteAllStations(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in Station error :", error)
        }
    }
 */
}
