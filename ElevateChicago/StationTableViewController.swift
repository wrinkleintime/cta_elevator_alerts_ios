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
    
    //TODO: Test Push notification, Background refresh of alerts with real device
    //TODO: Testing - unit tests, functional tests, user tests
    //TODO: Pay close attention to Apple deployment
    
    //TODO: UI: Add alerts section above specific line, add no favorites text to home
    
    //TODO: Schedule - week 7 (coding complete), week 10 (testing & deployment), week 12 (as done as possible)
    
    //MARK: Properties
    var stations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove separator lines for empty cells
        self.tableView.tableFooterView = UIView()
        
        registerForNotifications()
//        deleteAllStations()
    }
    
    func registerForNotifications() {
      NotificationCenter.default.addObserver(
        forName: .newAlertsFetched,
        object: nil,
        queue: nil) { (notification) in
          print("notification received")
          if let uInfo = notification.userInfo,
             let alerts = uInfo["alerts"] as? Alert {
            self.loadAlerts(currAlerts: alerts)
            self.tableView.reloadData()
          }
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        print("View Will Appear")
        fetchStations()
        fetchAlerts()
        tableView.reloadData()
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
        cell.hasAlert.isHidden = !(station.value(forKeyPath: "hasAlert") as? Bool ?? true)
        cell.redLine.isHidden = !(station.value(forKeyPath: "red") as? Bool ?? true)
        cell.blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
        cell.brownLine.isHidden = !(station.value(forKeyPath: "brown") as? Bool ?? true)
        cell.greenLine.isHidden = !(station.value(forKeyPath: "green") as? Bool ?? true)
        cell.orangeLine.isHidden = !(station.value(forKeyPath: "orange") as? Bool ?? true)
        cell.pinkLine.isHidden = !(station.value(forKeyPath: "pink") as? Bool ?? true)
        cell.purpleLine.isHidden = !(station.value(forKeyPath: "purple") as? Bool ?? true)
        cell.blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
        cell.yellowLine.isHidden = !(station.value(forKeyPath: "yellow") as? Bool ?? true)
        
        //Set filled or unfilled star for favorites
        if (station.value(forKeyPath: "isFavorite") as? Bool ?? true){
            cell.isFavorite.image = UIImage(systemName: "star.fill")
        } else {
            cell.isFavorite.image = UIImage(systemName: "star")
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch(segue.identifier ?? "") {
            case "ShowDetail":
                guard let stationNavController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let viewController = stationNavController.viewControllers[0] as? StationViewController else {
                    fatalError("Unexpected viewConroller!")
                }
                 
                guard let selectedStationCell = sender as? StationTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                 
                guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                 
                let selectedStation = stations[indexPath.row]
                
                viewController.station = selectedStation
            
            case "ShowAllLines":
                return
            
            case "ShowAllAlerts":
                return

            default:
                   fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindFromDetail(sender: UIStoryboardSegue) {
        if sender.source is StationViewController {
            print("Unwinding")
            getStationFavorites()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromSpecificLine(sender: UIStoryboardSegue) {
        if sender.source is SpecificLineTableViewController {
            print("Unwinding")
            getStationFavorites()
            tableView.reloadData()
        }
    }
    
    //MARK: Private Methods

    private func fetchAlerts() {
        AlertManager.pullAlerts() { (alerts) in
            self.loadAlerts(currAlerts: alerts)
            self.tableView.reloadData()
        }
    }
    
    private func fetchStations() {
        if (getStationsExist()){
            print("Stations exist")
            return
        } else
        {
            print("No stations exist")
            StationManager.pullStations() { (stations) in
            self.loadStations(currStations: stations)
            self.tableView.reloadData()
            }
        }
    }
    
    //For testing only
    private func deleteAllStations(){
        print("Deleting stations")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try managedContext.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    managedContext.delete(objectData)
                }
            } catch let error {
                print("Delete all data in Station error :", error)
            }
        }
    }

    private func loadStations(currStations: [CtaStation]){
        print("Loading stations")
        var stationDict = [String: CtaStation]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
        
            for stationJSON in currStations {
                if stationDict.keys.contains(stationJSON.map_id){
                    
                    let tempStation = stationJSON
                    let alreadyLoadedStation = stationDict[stationJSON.map_id]!
                    
                    stationDict[stationJSON.map_id]?.ada = tempStation.ada || alreadyLoadedStation.ada
                    stationDict[stationJSON.map_id]?.red = tempStation.red || alreadyLoadedStation.red
                    stationDict[stationJSON.map_id]?.blue = tempStation.blue || alreadyLoadedStation.blue
                    stationDict[stationJSON.map_id]?.g = tempStation.g || alreadyLoadedStation.g
                    stationDict[stationJSON.map_id]?.brn = tempStation.brn || alreadyLoadedStation.brn
                    stationDict[stationJSON.map_id]?.p = tempStation.p || alreadyLoadedStation.p
                    stationDict[stationJSON.map_id]?.pexp = tempStation.pexp || alreadyLoadedStation.pexp
                    stationDict[stationJSON.map_id]?.y = tempStation.y || alreadyLoadedStation.y
                    stationDict[stationJSON.map_id]?.pnk = tempStation.pnk || alreadyLoadedStation.pnk
                    stationDict[stationJSON.map_id]?.o = tempStation.o || alreadyLoadedStation.o
                } else {
                    stationDict[stationJSON.map_id] = stationJSON
                }
            }
            
            for stationJSON in stationDict.values{
                let entity = NSEntityDescription.entity(forEntityName: "Station",
                                             in: managedContext)!
                let station = NSManagedObject(entity: entity, insertInto: managedContext)
                
                station.setValue("", forKeyPath: "alertDetails")
                station.setValue(stationJSON.map_id, forKeyPath: "id")
                station.setValue(false, forKeyPath: "hasAlert")
                station.setValue(stationJSON.ada, forKeyPath: "hasElevator")
                station.setValue(false, forKeyPath: "isFavorite")
                station.setValue(stationJSON.blue, forKeyPath: "blue")
                station.setValue(stationJSON.brn, forKeyPath: "brown")
                station.setValue(stationJSON.g, forKeyPath: "green")
                station.setValue(stationJSON.o, forKeyPath: "orange")
                station.setValue(stationJSON.pnk, forKeyPath: "pink")
                station.setValue(stationJSON.p || stationJSON.pexp, forKeyPath: "purple")
                station.setValue(stationJSON.red, forKeyPath: "red")
                station.setValue(stationJSON.y, forKeyPath: "yellow")
                
                //Fix incorrect data in JSON
                if stationJSON.map_id == "40040" {
                    station.setValue(true, forKeyPath: "hasElevator")
                }
                
                //Shorten long station names
                switch stationJSON.map_id {
                    case "40850": station.setValue("Harold Wash. Library", forKeyPath: "name")
                    case "40670": station.setValue("Western (O'Hare)", forKeyPath: "name")
                    case "40220": station.setValue("Western (Forest Pk)", forKeyPath: "name")
                    case "40750": station.setValue("Harlem (O'Hare)", forKeyPath: "name")
                    case "40980": station.setValue("Harlem (Forest Pk)", forKeyPath: "name")
                    case "40810": station.setValue("IL Med. District", forKeyPath: "name")
                    case "41690": station.setValue("Cermak-McCorm. Pl.", forKeyPath: "name")
                    default: station.setValue(stationJSON.station_name, forKeyPath: "name")
                }
                
                saveContext(forContext: privateContext)
            }
        }
    }
    
    private func loadAlerts(currAlerts: Alert){
        print("Loading alerts")
        clearAlerts()
        let alerts = currAlerts.ctaAlerts.alerts
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
            for alertJSON in alerts {
                let impact = alertJSON.impact
                let headline = alertJSON.headline
                let shortDesc = alertJSON.shortDescription
                
                if impact != "Elevator Status" || headline == "Back in Service"{
                    continue
                }
                
                for service in alertJSON.impactedService.service{
                    if service.serviceType == "T"{
                        let stationId = service.serviceId
                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
                        fetchRequest.predicate = NSPredicate(format: "id == %@", stationId)

                        do{
                            stations = try managedContext.fetch(fetchRequest)
                            if !stations.isEmpty{
                                let station = stations[0]
                                station.setValue(shortDesc, forKeyPath: "alertDetails")
                                station.setValue(true, forKeyPath: "hasAlert")
                                
                                saveContext(forContext: privateContext)
                            }
                        } catch let error as NSError {
                            print("Could not fetch. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            getStationFavorites()
            print("Alerts loaded")
        }
    }
    
    private func clearAlerts(){
        print("Clearing alerts")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
            fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

            do{
                stations = try managedContext.fetch(fetchRequest)
                
                for station in stations {
                    station.setValue("", forKeyPath: "alertDetails")
                    station.setValue(false, forKeyPath: "hasAlert")
                    saveContext(forContext: privateContext)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func getStationFavorites(){
        print("Getting station favorites")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == 1")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do{
            stations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func getStationsExist() -> Bool {
        print("Getting stations exist")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0{
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    private func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Error when saving !!! \(nserror.localizedDescription)")
                    print("Callstack :")
                    for symbol: String in Thread.callStackSymbols {
                        print(" > \(symbol)")
                    }
                }
            }
        }
    }
}



