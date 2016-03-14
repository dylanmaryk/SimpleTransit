//
//  Segment.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

class Segment {
    var name: String?
    var numStops: Int
    var stops: [Stop]
    var travelMode: String?
    var description: String?
    var color: UIColor?
    var iconURL: String?
    var polyline: String?
    
    init(name: String?, stops: [Stop], travelMode: String?, description: String?, color colorString: String?, iconURL: String?, polyline: String?) {
        self.name = name
        self.stops = stops
        self.travelMode = travelMode
        self.description = description
        self.iconURL = iconURL
        self.polyline = polyline
        
        if stops.count > 0 {
            numStops = stops.count - 1
        } else {
            numStops = 0
        }
        
        if let colorStringToConvert = colorString {
            color = UIColor(rgba: colorStringToConvert)
        }
    }
}
