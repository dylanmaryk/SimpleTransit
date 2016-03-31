//
//  RouteTableViewCell.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 31/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Alamofire
import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var providerIconImageView: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var journeyTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupCell(route: Route) {
        route.createOrigin  { (origin: String?) -> Void in
            self.fromLabel.text = origin
        }
        
        route.createDestination { (destination: String?) -> Void in
            self.toLabel.text = destination
        }
        
        if let journeyTime = route.journeyTime {
            journeyTimeLabel.text = "Journey time: \(journeyTime) minutes"
        }
        
        if let priceFormatted = route.priceFormatted {
            priceLabel.text = priceFormatted
        }
    }
}