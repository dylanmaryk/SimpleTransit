//
//  RouteTableViewCell.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 31/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var providerIconImageView: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var journeyTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupCell(route: Route) {
        providerIconImageView.image = nil // Prevents possible duplicate image due to cell reuse
        
        ImageConverter.imageForSVGAtURL(route.providerIconURL) { (image: UIImage?) -> Void in
            self.providerIconImageView.image = image
        }
        
        route.createOrigin { (origin: String?) -> Void in
            self.fromLabel.text = origin
        }
        
        route.createDestination { (destination: String?) -> Void in
            self.toLabel.text = destination
        }
        
        if let journeyTime = route.journeyTime {
            journeyTimeLabel.text = "Journey time: \(journeyTime) minutes"
        } else {
            journeyTimeLabel.text = nil
        }
        
        if let priceFormatted = route.priceFormatted {
            priceLabel.text = priceFormatted
        } else {
            priceLabel.text = nil
        }
    }
}
