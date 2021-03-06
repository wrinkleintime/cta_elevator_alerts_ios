//
//  StationTableViewCell.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/17/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var hasAlert: UIImageView!
    @IBOutlet weak var redLine: UIView!
    @IBOutlet weak var brownLine: UIView!
    @IBOutlet weak var greenLine: UIView!
    @IBOutlet weak var orangeLine: UIView!
    @IBOutlet weak var pinkLine: UIView!
    @IBOutlet weak var purpleLine: UIView!
    @IBOutlet weak var blueLine: UIView!
    @IBOutlet weak var yellowLine: UIView!
    @IBOutlet weak var isFavorite: UIImageView!
    @IBOutlet weak var accessibleLineNames: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        hasAlert.isHidden = true
        redLine.isHidden = true
        brownLine.isHidden = true
        greenLine.isHidden = true
        orangeLine.isHidden = true
        pinkLine.isHidden = true
        purpleLine.isHidden = true
        blueLine.isHidden = true
        yellowLine.isHidden = true
    }
    
    func configureCell(_ containsAlert: Bool) {
        applyAccessibility(containsAlert)
    }
}

extension StationTableViewCell {
    func applyAccessibility(_ containsAlert: Bool) {
        isFavorite.isAccessibilityElement = true
        isFavorite.accessibilityTraits = [.image, .button]
        isFavorite.accessibilityLabel = "This is a favorite station. Click to remove it as a favorite."
        
        if (containsAlert){
            hasAlert.isAccessibilityElement = true
            hasAlert.accessibilityTraits = .image
            hasAlert.accessibilityLabel = "This station has an elevator alert."
        }
  }
}
