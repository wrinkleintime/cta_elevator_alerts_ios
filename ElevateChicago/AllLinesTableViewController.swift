//
//  AllLinesTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/18/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class AllLinesTableViewController: UITableViewController {

    //MARK: Properties
    var lines = [String](arrayLiteral: "Red", "Blue", "Brown", "Green", "Orange", "Pink", "Purple", "Yellow")

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "AllLinesTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AllLinesTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of AllLinesTableViewCell.")
        }

        // Fetches the appropriate line for the data source layout.
        let line = lines[indexPath.row]

        let imageName = line + "LineIcon"
        cell.lineIcon.image = UIImage(named: imageName)
        cell.lineName.text = line + " Line"
        
        var hasAlert = false
        
        for id in SpecificLineTableViewController.getStationsInOrder(name: line){
            if let station = getStationById(id: id){
                if (station.value(forKeyPath: "hasAlert") as? Bool ?? true){
                    hasAlert = true
                    break
                }
            } else {
                continue
            }
        }
        
        cell.hasAlert.isHidden = !hasAlert
        cell.configureCell(hasAlert)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.safeAreaLayoutGuide.layoutFrame.size.height / CGFloat(lines.count)
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let specificLineViewController = segue.destination as? SpecificLineTableViewController else {
               fatalError("Unexpected destination: \(segue.destination)")
           }

       guard let selectedLineCell = sender as? AllLinesTableViewCell else {
           fatalError("Unexpected sender: \(String(describing: sender))")
       }

       guard let indexPath = tableView.indexPath(for: selectedLineCell) else {
           fatalError("The selected cell is not being displayed by the table")
       }

       specificLineViewController.line = lines[indexPath.row]
    }
}
