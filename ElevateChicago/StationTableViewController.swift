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
    
    //TODO: Alerts, push notifications, alerts by line, home button, splash screen
    //TODO: Specific line -- locations of alert, star
    //TODO: Architecture - performance, concurrency
    //TODO: Testing - unit tests, functional tests, user tests
    //TODO: Apple watch - ??
    //TODO: Pay close attention to Apple deployment
    
    //TODO: Schedule - week 7 (coding complete), week 10 (testing & deployment), week 12 (as done as possible)
    
    //MARK: Properties
    var stations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteAllStations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        print("View Will Appear")
        getStationFavorites()
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
    
    //For testing only
    private func deleteAllStations(){
        print("Deleting stations")

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
            print("Delete all data in Station error :", error)
        }
    }
    
    //TODO: Where to put this?
    private func pullStations(){
        print("Pulling stations")
        let session = URLSession.shared
        let url = URL(string: "https://data.cityofchicago.org/resource/8pix-ypme.json")!
        
        var stationsJSON: [StationJSON] = []
                
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error!")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Bad HTTP status code!")
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
        
            do{
                stationsJSON = try JSONDecoder().decode([StationJSON].self, from: data!)
                DispatchQueue.main.async {
                    self.loadStations(currStations: stationsJSON)
                    self.getStationFavorites()
                    self.tableView.reloadData()
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func loadStations(currStations: [StationJSON]){
        //FIXME: Make sure # of stations is correct
        print("Loading stations")
        var stationDict = [String: StationJSON]()
        
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
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                  return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Station",
                                         in: managedContext)!
            let station = NSManagedObject(entity: entity, insertInto: managedContext)
            
            station.setValue(stationJSON.station_name, forKeyPath: "name")
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
            
            //Dummy alerts
            if stationJSON.map_id == "41300" {
                station.setValue(true, forKeyPath: "hasAlert")
                station.setValue("The elevator at Loyola is out!", forKeyPath: "alertDetails")
            }
            
            do {
                try managedContext.save()
                stations.append(station)
                } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func getStationFavorites(){
        print("Getting station favorites")
        
        if (stations.count == 0){
            pullStations()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == 1")

        do{
           stations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //Decoded from API call
    struct StationJSON: Codable {
        var map_id: String
        var station_name: String
        var ada: Bool
        var red: Bool
        var blue: Bool
        var g: Bool
        var brn: Bool
        var p: Bool
        var pexp: Bool
        var y: Bool
        var pnk: Bool
        var o: Bool
    }
}



