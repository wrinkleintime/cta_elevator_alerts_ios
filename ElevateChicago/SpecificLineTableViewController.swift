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
    var allStations = [NSManagedObject]()
    var alertStations = [NSManagedObject]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = line + " Line";
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ids = SpecificLineTableViewController.getStationsInOrder(name: line)
        
        for id in ids {
            let station = getStationById(id: id)
            
            if let station = station {
                allStations.append(station)
                
                if (station.value(forKeyPath: "hasAlert") as? Bool ?? false){
                    alertStations.append(station)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return alertStations.count
            case 1:
                return allStations.count
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificLineTableViewCell", for: indexPath) as? SpecificLineTableViewCell else{
                fatalError("The dequeued cell is not an instance of SpecificLineTableViewCell.")
            }
            let station = alertStations[indexPath.row]
            
            cell.accessible.isHidden = true
            cell.topLine.isHidden = true
            cell.bottomLine.isHidden = true
            cell.isFavorite.isHidden = true
            cell.circle.tintColor = getLineColor()
            cell.alert.isHidden = false
            cell.name.text = station.value(forKeyPath: "name") as? String
            
            cell.configureCell(!cell.alert.isHidden, !cell.isFavorite.isHidden)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificLineTableViewCell", for: indexPath) as? SpecificLineTableViewCell else{
                fatalError("The dequeued cell is not an instance of SpecificLineTableViewCell.")
            }
              
            let station = allStations[indexPath.row]
 
            switch indexPath.row {
            case 0:
                cell.topLine.isHidden = true;
                cell.bottomLine.isHidden = false

            case allStations.count - 1:
                cell.topLine.isHidden = false
                cell.bottomLine.isHidden = true;

            default:
                cell.topLine.isHidden = false
                cell.bottomLine.isHidden = false
           }

            cell.name.text = station.value(forKeyPath: "name") as? String
            cell.alert.isHidden = !(station.value(forKeyPath: "hasAlert") as? Bool ?? true)
            let favorite = (station.value(forKeyPath: "isFavorite") as? Bool ?? false)
                   
            cell.isFavorite.isHighlighted = favorite
            cell.isFavorite.isUserInteractionEnabled = true;
            let tappy = SpecificLineTapGesture(target: self, action: #selector(prechangeFavorite))
            cell.isFavorite.addGestureRecognizer(tappy)
            tappy.station = station
            tappy.isFavorite = favorite
            tappy.cell = cell

            cell.topLine.backgroundColor = getLineColor()
            cell.bottomLine.backgroundColor = getLineColor()
            cell.circle.tintColor = getLineColor()
            cell.accessible.backgroundColor = getLineColor()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

            let hasElevator = (station.value(forKeyPath: "hasElevator") as? Bool ?? false)

            cell.accessible.isHidden = !hasElevator
            cell.isFavorite.isHidden = !hasElevator
            
            cell.configureCell(!cell.alert.isHidden, !cell.isFavorite.isHidden)

            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                if alertStations.count == 0{
                    return nil
                }
                return "Stations with Alerts"
            case 1:
                if allStations.count == 0{
                    return nil
                }
                return "All Stations"
            default:
                return "Default title"
        }
    }

    @objc func prechangeFavorite(_ sender: SpecificLineTapGesture) {
        print("prechanging favorite")
        if (sender.isFavorite){
            if let stations = sender.station {
                changeFavorite(isNowFavorite: false, station: stations)
            } else {
                return
            }
            if let cell = sender.cell {
                cell.isFavorite.image = UIImage(systemName: "star")
            } else {
                return
            }
        } else {
            if let stations = sender.station {
                changeFavorite(isNowFavorite: true, station: stations)
            } else {
                return
            }
            if let cell = sender.cell {
                cell.isFavorite.image = UIImage(systemName: "star.fill")
            } else {
                return
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        case "ShowDetailSpecific":

            guard let stationNavController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
            guard let stationViewController = stationNavController.viewControllers[0] as? StationViewController else {
                fatalError("Unexpected viewController!")
            }

            guard let selectedStationCell = sender as? SpecificLineTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }

            guard let indexPath = tableView.indexPath(for: selectedStationCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            switch indexPath.section {
                case 0:
                    stationViewController.station = alertStations[indexPath.row]
                case 1:
                    stationViewController.station = allStations[indexPath.row]
                default:
                    return
            }
        default:
            return
        }
    }
    
    //MARK: Actions
    @IBAction func unwindFromDetail(sender: UIStoryboardSegue) {
        if sender.source is StationViewController {
            print("unwinding")
            tableView.reloadData()
        }
    }
    
    //MARK: Private Methods
    static func getStationsInOrder(name: String) -> [String] {
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

    private func getLineColor() -> UIColor? {
       switch line {
           case "Red":
               return UIColor(named: "C6222F")
           case "Green":
               return UIColor(named: "259B3A")
           case "Blue":
               return UIColor(named: "34A1DE")
           case "Orange":
               return UIColor(named: "F7451B")
           case "Purple":
               return UIColor(named: "522298")
           case "Pink":
               return UIColor(named: "E27EA6")
           case "Brown":
               return UIColor(named: "62361A")
           case "Yellow":
               return UIColor(named: "F9E300")
           default:
               return UIColor(named: "000000")
       }
    }
    
    private func changeFavorite(isNowFavorite: Bool, station: NSManagedObject){
        print("changing favorite")
        station.setValue(isNowFavorite, forKeyPath: "isFavorite")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
          }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

public extension UIColor {
    convenience init?(named: String) {
        var hex = named

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int64(hex, radix: 16) else {
            self.init()
            return nil
        }

        self.init(red:   CGFloat( (hexVal & 0xFF0000) >> 16 ) / 255.0,
        green: CGFloat( (hexVal & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat( (hexVal & 0x0000FF) >> 0 ) / 255.0, alpha: 1.0)
    }
}

class SpecificLineTapGesture: UITapGestureRecognizer {
    var station: NSManagedObject?
    var isFavorite = Bool()
    var cell: SpecificLineTableViewCell?
}

