//
//  Stop.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import CoreLocation
import Foundation

class Stop {
    var location: CLLocation?
    var dateTime: NSDate?
    var dateTimeFormatted: String?
    var name: String?
    
    init(lat: Double?, lng: Double?, dateTime dateTimeString: String?, name: String?) {
        self.name = name
        
        if let latToConvert = lat,
            lngToConvert = lng {
            location = CLLocation(latitude: latToConvert, longitude: lngToConvert)
        }
        
        if let dateTimeStringToConvert = dateTimeString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateTime = dateFormatter.dateFromString(dateTimeStringToConvert) // Date differs from original data according to timezone
            
            if let dateTimeFromString = dateTime {
                dateFormatter.dateFormat = "HH:mm"
                dateTimeFormatted = dateFormatter.stringFromDate(dateTimeFromString)
            }
        }
    }
    
    func createNameFromLocation(completion: (name: String?) -> Void) {
        guard let existingLocation = location else {
            completion(name: nil)
            return
        }
        
        LocationManager().reverseGeocodeLocationWithCoordinates(existingLocation) { (reverseGeocodeInfo, placemark, error) -> Void in
            if let geocodeInfo = reverseGeocodeInfo,
                address = geocodeInfo["formattedAddress"] as? String {
                self.name = address
                completion(name: address)
            } else {
                completion(name: nil)
            }
        }
    }
}
