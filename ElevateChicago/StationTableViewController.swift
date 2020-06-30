//
//  StationTableViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/17/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class StationTableViewController: UITableViewController {
    
    //TODO: Fix issue with re-fetching alerts when going back into app
    //TODO: Testing - unit tests, functional tests, user tests
    //TODO: Pay close attention to Apple deployment
    //TODO: UI: Add alerts section above specific line, add no favorites text to home
    
    //TODO: Schedule - week 7 (coding complete), week 10 (testing & deployment), week 12 (as done as possible)
    
    //MARK: Properties
    var stations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove separator lines for empty cells
//        self.tableView.tableFooterView = UIView()
        
        registerUserForNotifications()
        registerAppForNotifications()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:  #selector(handleRefreshControl), for: .valueChanged)
        
//        deleteAllStations()
    }
    
    @objc func handleRefreshControl() {
       fetchAlerts()
       tableView.reloadData()

       // Dismiss the refresh control.
       DispatchQueue.main.async {
          self.refreshControl?.endRefreshing()
       }
    }
    
    func registerUserForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            if granted {
                print("Notification access granted")
            } else {
                print("Notification access NOT granted")
            }
        }
    }
    
    func registerAppForNotifications() {
      NotificationCenter.default.addObserver(
        forName: .newAlertsFetched,
        object: nil,
        queue: nil) { (notification) in
          print("notification received")
          if let uInfo = notification.userInfo,
             let alerts = uInfo["alerts"] as? Alert {
            self.loadAlerts(currAlerts: alerts)
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
        getStationFavorites()

//        clearAlerts()
        
        var changedFavoriteElevators = [(String, String, Bool)]()
        
        let alerts = currAlerts.ctaAlerts.alerts
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
            
            // First, get previous alert IDs
            var changedAlertIds = [(String, String)]()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
            fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

            do{
                let tempstations = try managedContext.fetch(fetchRequest)
                
                // Add all previous IDs to changedAlertIds, to start
                for station in tempstations {
                    if let name = (station.value(forKeyPath: "name") as? String), let id = (station.value(forKeyPath: "id") as? String) {
                        changedAlertIds.append((id, name))
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        privateContext.performAndWait {
            // First, get previous alert IDs
            var changedAlertIds = [(String, String)]()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
            fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

            do{
                let tempstations = try managedContext.fetch(fetchRequest)
                
                // Add all previous IDs to changedAlertIds, to start
                for station in tempstations {
                    if let name = (station.value(forKeyPath: "name") as? String), let id = (station.value(forKeyPath: "id") as? String) {
                        changedAlertIds.append((id, name))
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        privateContext.performAndWait {
            // First, get previous alert IDs
            var changedAlertIds = [(String, String)]()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
            fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

            do{
                let tempstations = try managedContext.fetch(fetchRequest)
                
                // Add all previous IDs to changedAlertIds, to start
                for station in tempstations {
                    if let name = (station.value(forKeyPath: "name") as? String), let id = (station.value(forKeyPath: "id") as? String) {
                        changedAlertIds.append((id, name))
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        
            // Second, load alerts
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
                        let newFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
                        newFetchRequest.predicate = NSPredicate(format: "id == %@", stationId)

                        do{
                            stations = try managedContext.fetch(newFetchRequest)
                            
                            if !stations.isEmpty {
                                let station = stations[0]
                                station.setValue(shortDesc, forKeyPath: "alertDetails")
                                
                                // If the station didn't have an alert before, it's a new alert
                                // so add it to the local notification list
                                let id = (station.value(forKeyPath: "id") as? String ?? "")
                                let name = (station.value(forKeyPath: "name") as? String ?? "")
                                
                                if !(station.value(forKeyPath: "hasAlert") as? Bool ?? true) && (station.value(forKeyPath: "isFavorite") as? Bool ?? false){
                                    print("Favorite elevator out of service: " + name)
                                    changedFavoriteElevators.append((id, name, true))
                                }
                                
                                // If the station had an alert before, remove it from the
                                // changedAlertIds list
                                for (tempid, tempname) in changedAlertIds{
                                    if id == tempid {
                                        changedAlertIds = changedAlertIds.filter{$0 != (tempid, tempname)}
                                        print(changedAlertIds)
                                    }
                                }
                                
                                station.setValue(true, forKeyPath: "hasAlert")
                                
                                saveContext(forContext: privateContext)
                            }
                        } catch let error as NSError {
                            print("Could not fetch. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            
            privateContext.performAndWait {
                // First, get previous alert IDs
                var changedAlertIds = [(String, String)]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
                fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

                do{
                    let tempstations = try managedContext.fetch(fetchRequest)
                    
                    // Add all previous IDs to changedAlertIds, to start
                    for station in tempstations {
                        if let name = (station.value(forKeyPath: "name") as? String), let id = (station.value(forKeyPath: "id") as? String) {
                            changedAlertIds.append((id, name))
                        }
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
            
            privateContext.performAndWait {
                // First, get previous alert IDs
                var changedAlertIds = [(String, String)]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
                fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

                do{
                    let tempstations = try managedContext.fetch(fetchRequest)
                    
                    // Add all previous IDs to changedAlertIds, to start
                    for station in tempstations {
                        if let name = (station.value(forKeyPath: "name") as? String), let id = (station.value(forKeyPath: "id") as? String) {
                            changedAlertIds.append((id, name))
                        }
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
                
            privateContext.performAndWait {
                // Add alerts that no longer exist to the local notification list
                // and remove their alert
                for (tempid, tempname) in changedAlertIds{
                                        
                    let newFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
                    newFetchRequest.predicate = NSPredicate(format: "id == %@", tempid)
                    
                    do{
                        let tempstations = try managedContext.fetch(newFetchRequest)
                        let tempstation = tempstations[0]
                        tempstation.setValue(false, forKeyPath: "hasAlert")
                        saveContext(forContext: privateContext)
                        
                        if (tempstation.value(forKeyPath: "isFavorite") as? Bool ?? false){
                            print("Favorite elevator back in service: " + tempname)
                            changedFavoriteElevators.append((tempid, tempname, false))
                        }
                    } catch let error as NSError {
                        print("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            }
   
            sendNotifications(content: changedFavoriteElevators)
            getStationFavorites()
            print("Alerts loaded")
        }
    }
        
    func sendNotifications(content: [(String, String, Bool)]) {
        print("Sending notifications")
        
        var counter = 1
            
        for contentItem in content{
            print("id: " + contentItem.0 + ", name: " + contentItem.1 + ", bool: " + contentItem.2.description)
            
            let content = UNMutableNotificationContent()
            
            if contentItem.2{
                content.title = "Elevator is Out of Service!"
                content.body = "Elevator is down at " + contentItem.1
                content.userInfo = ["id": contentItem.0]
            } else {
                content.title = "Elevator is Back in Service!"
                content.body = "Elevator is working at " + contentItem.1
                content.userInfo = ["id": contentItem.0]
            }
            let identifier = "notification.id." + counter.description
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            counter += 1
        }
    }
    
    @IBAction func testNotifications(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let newFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        
        //Test adding alert for Logan Square
        newFetchRequest.predicate = NSPredicate(format: "id == %@", "41020")
        
        do{
            let stations = try managedContext.fetch(newFetchRequest)
            let station = stations[0]
            station.setValue(false, forKeyPath: "hasAlert")
            station.setValue(true, forKeyPath: "isFavorite")
            saveContext(forContext: managedContext)
            print("Logan Square test added")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //Test removing alert for Wilson
        newFetchRequest.predicate = NSPredicate(format: "id == %@", "40540")
        
        do{
            let stations = try managedContext.fetch(newFetchRequest)
            let station = stations[0]
            station.setValue(true, forKeyPath: "hasAlert")
            station.setValue(true, forKeyPath: "isFavorite")
            saveContext(forContext: managedContext)
            print("Wilson test added")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
                let tempstations = try managedContext.fetch(fetchRequest)
                
                for station in tempstations {
                    station.setValue("", forKeyPath: "alertDetails")
                    station.setValue(false, forKeyPath: "hasAlert")
                    saveContext(forContext: privateContext)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func getCurrentAlerts() -> [NSManagedObject]{
        print("Getting current alerts")
        
        var currAlerts = [NSManagedObject]()
                
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return currAlerts
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = managedContext
        
        privateContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
            fetchRequest.predicate = NSPredicate(format: "hasAlert == YES")

            do{
                currAlerts = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        return currAlerts
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



