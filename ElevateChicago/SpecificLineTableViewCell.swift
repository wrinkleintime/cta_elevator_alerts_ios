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

}
