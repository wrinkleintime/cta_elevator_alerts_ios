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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
