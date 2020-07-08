//
//  SpecificLineTableViewCell.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/21/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class SpecificLineTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var accessible: UIImageView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var alert: UIImageView!
    @IBOutlet weak var isFavorite: UIImageView!
    @IBOutlet weak var hasAlertStationsWithAlerts: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ containsAlert: Bool, _ containsFavorite: Bool) {
        applyAccessibility(containsAlert, containsFavorite)
    }
}

extension SpecificLineTableViewCell {
    func applyAccessibility(_ containsAlert: Bool, _ containsFavorite: Bool) {
        
        circle.isAccessibilityElement = false
        
        accessible.isAccessibilityElement = true
        accessible.accessibilityTraits = .none
        accessible.accessibilityLabel = "This station is accessible."
        
        isFavorite.isAccessibilityElement = true
        isFavorite.accessibilityTraits = [.image, .button]
        
        if (containsFavorite){
            isFavorite.accessibilityLabel = "This is a favorite station. Click to make it not a favorite."
        } else {
            isFavorite.accessibilityLabel = "This is not a favorite station. Click to make it a favorite."
        }
        
        if (containsAlert){
            alert.isAccessibilityElement = true
            alert.accessibilityTraits = .image
            alert.accessibilityLabel = "This station has an elevator alert. Click to find out more information."
        }
  }
}
