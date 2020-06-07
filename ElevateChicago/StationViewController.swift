//
//  StationViewController.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/14/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit
import CoreData

class StationViewController: UIViewController, UINavigationControllerDelegate {

    //MARK: Properties

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var redLine: UIView!
    @IBOutlet weak var brownLine: UIView!
    @IBOutlet weak var greenLine: UIView!
    @IBOutlet weak var orangeLine: UIView!
    @IBOutlet weak var pinkLine: UIView!
    @IBOutlet weak var purpleLine: UIView!
    @IBOutlet weak var blueLine: UIView!
    @IBOutlet weak var yellowLine: UIView!
    @IBOutlet weak var alertDetails: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    //This value is passed by in `prepare(for:sender:)`
    var station: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let station = station {
            stationName.text = station.value(forKeyPath: "name") as? String
            redLine.isHidden = !(station.value(forKeyPath: "red") as? Bool ?? true)
            blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
            brownLine.isHidden = !(station.value(forKeyPath: "brown") as? Bool ?? true)
            greenLine.isHidden = !(station.value(forKeyPath: "green") as? Bool ?? true)
            orangeLine.isHidden = !(station.value(forKeyPath: "orange") as? Bool ?? true)
            pinkLine.isHidden = !(station.value(forKeyPath: "pink") as? Bool ?? true)
            purpleLine.isHidden = !(station.value(forKeyPath: "purple") as? Bool ?? true)
            blueLine.isHidden = !(station.value(forKeyPath: "blue") as? Bool ?? true)
            yellowLine.isHidden = !(station.value(forKeyPath: "yellow") as? Bool ?? true)
            
            //Display the correct elevator status details.
            if !(station.value(forKeyPath: "hasElevator") as? Bool ?? true){
                alertDetails.text = "There are no elevators at this station."
            } else {
                if (station.value(forKeyPath: "hasAlert") as? Bool ?? true) {
                    alertDetails.text = station.value(forKeyPath: "alertDetails") as? String
                } else{
                    alertDetails.text = "All elevators at this station are working properly."
                }
            }
            
            if ((station.value(forKeyPath: "hasElevator") as? Bool ?? false) == false){
                favoriteButton.isEnabled = false
                favoriteButton.tintColor = UIColor.clear
            } else if (station.value(forKeyPath: "isFavorite") as? Bool ?? false){
                favoriteButton.image = UIImage(systemName: "star.fill")
            } else {
                favoriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    //MARK: Actions
    @IBAction func clickFavoriteButton(_ sender: UIBarButtonItem) {
        if (sender.image == UIImage(systemName: "star.fill")){
            changeFavorite(isNowFavorite: false);
            sender.image = UIImage(systemName: "star")
        } else {
            changeFavorite(isNowFavorite: true);
            sender.image = UIImage(systemName: "star.fill")
        }
    }
    
    //MARK: Private functions
    func changeFavorite(isNowFavorite: Bool){
        station?.setValue(isNowFavorite, forKeyPath: "isFavorite")
        
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

