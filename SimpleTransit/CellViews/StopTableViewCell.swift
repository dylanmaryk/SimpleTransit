//
//  StopTableViewCell.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 03/04/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import UIKit

class StopTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    func setupCell(stop: Stop) {
        if let name = stop.name {
            nameLabel.text = name
        } else {
            nameLabel.text = nil
        }
        
        if let dateTimeFormatted = stop.dateTimeFormatted {
            dateTimeLabel.text = dateTimeFormatted
        } else {
            dateTimeLabel.text = nil
        }
    }
}
