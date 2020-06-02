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
        
//        deleteAllStations()
        
        if (stations.count == 0){
            print("Pulling stations")
            pullStations()
        }
                                
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Station")
        do{
            stations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            tableView.reloadData()
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
        station.setValue(yellow, forKeyPath: "yellow")
        
        if (id == "40380"){
            station.setValue(true, forKeyPath: "hasAlert")
            station.setValue("The elevator at Clark/Lake is out of service.", forKeyPath: "alertDetails")
            station.setValue(true, forKeyPath: "isFavorite")
        }

        do {
            try managedContext.save()
            stations.append(station)
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
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
            print("Detele all data in Station error :", error)
        }
    }
    
    private func pullStations(){
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
                print(stationsJSON[0].station_name)
                print("Loading stations")
                DispatchQueue.main.async {
                    self.loadStations(currStations: stationsJSON)
                    self.tableView.reloadData()
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func loadStations(currStations: [StationJSON]){
        print(currStations.count)
        var stationDict = [String: StationJSON]()
        
        for stationJSON in currStations {
            if stationDict.keys.contains(stationJSON.map_id){
                
                let tempStation = stationJSON
                let alreadyLoadedStation = stationDict[stationJSON.map_id]!
                
                if stationJSON.map_id == "40900"{
                    print("Updating Howard 2nd")
                    print("Already Loaded Red: " + alreadyLoadedStation.red.description)
                    print("New Loaded Red: " + tempStation.red.description)
                }
                
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
                
                if stationJSON.map_id == "40900"{
                    print("Updating Howard 1st")
                    print("Red: " + stationJSON.red.description)
                }
            }
        }
        
        print("Station logic parsed")
        print(stationDict.values.count)

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
            
            do {
                try managedContext.save()
                stations.append(station)
                } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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



