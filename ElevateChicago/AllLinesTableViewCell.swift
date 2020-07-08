//
//  AllLinesTableViewCell.swift
//  ElevateChicago
//
//  Created by Sam Siner on 5/18/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class AllLinesTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var lineIcon: UIImageView!
    @IBOutlet weak var lineName: UILabel!
    @IBOutlet weak var hasAlert: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ containsAlert: Bool) {
        applyAccessibility(containsAlert)
    }
}

extension AllLinesTableViewCell {
    func applyAccessibility(_ containsAlert: Bool) {
        lineIcon.isAccessibilityElement = true
        lineIcon.accessibilityTraits = .none
        lineIcon.accessibilityLabel = "Icon of a train."
        
        if (containsAlert){
            hasAlert.isAccessibilityElement = true
            hasAlert.accessibilityTraits = .image
            hasAlert.accessibilityLabel = "This line contains a station with an elevator alert."
        }
  }
}

