//
//  Stop.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Foundation

class Stop {
    var lat: Double?
    var lng: Double?
    var dateTime: NSDate?
    var name: String?
    
    init(lat: Double?, lng: Double?, dateTime dateTimeString: String?, name: String?) {
        self.lat = lat
        self.lng = lng
        self.name = name
        
        if let dateTimeStringToConvert = dateTimeString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.dateTime = dateFormatter.dateFromString(dateTimeStringToConvert) // Date differs from original data according to timezone
        }
    }
}
