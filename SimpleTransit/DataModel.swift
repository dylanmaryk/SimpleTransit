//
//  DataModel.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Alamofire
import Foundation

protocol DataModelDelegate: class {
    func routesUpdated(routes: [Route])
}

class DataModel {
    weak var delegate: DataModelDelegate?
    
    func updateRoutes() {
        Alamofire.request(.GET, "https://raw.githubusercontent.com/allyapp/transit-app-task/master/data.json").responseJSON { response in
            guard let JSON = response.result.value as? [String: AnyObject],
                let JSONRoutes = JSON["routes"] as? [[String: AnyObject]] else {
                    return
            }
            
            for JSONRoute in JSONRoutes {
                let type = JSONRoute["type"] as? String
                var providerName = JSONRoute["provider"] as? String
                var providerURL: String?
                
                if let validProvider = providerName,
                    let JSONProviderAttributes = JSON["provider_attributes"] as? [String: [String: String]],
                    let JSONProviderAttribute = JSONProviderAttributes[validProvider],
                    let iTunesURL = JSONProviderAttribute["ios_itunes_url"],
                    let displayName = JSONProviderAttribute["display_name"] {
                        providerName = displayName
                        providerURL = iTunesURL
                }
                
                var segments = [Segment]()
                
                if let JSONSegments = JSONRoute["segments"] as? [[String: AnyObject]] {
                    for JSONSegment in JSONSegments {
                        let segmentName = JSONSegment["name"] as? String
                        var stops = [Stop]()
                        
                        if let JSONStops = JSONSegment["stops"] as? [[String: AnyObject]] {
                            for JSONStop in JSONStops {
                                let lat = JSONStop["lat"] as? Double
                                let lng = JSONStop["lng"] as? Double
                                let dateTime = JSONStop["datetime"] as? String
                                let stopName = JSONStop["name"] as? String
                                let stop = Stop(lat: lat, lng: lng, dateTime: dateTime, name: stopName)
                                stops.append(stop)
                            }
                        }
                        
                        let travelMode = JSONSegment["travel_mode"] as? String
                        let description = JSONSegment["description"] as? String
                        let color = JSONSegment["color"] as? String
                        let iconURL = JSONSegment["icon_url"] as? String
                        let polyline = JSONSegment["polyline"] as? String
                        let segment = Segment(name: segmentName, stops: stops, travelMode: travelMode, description: description, color: color, iconURL: iconURL, polyline: polyline)
                        segments.append(segment)
                    }
                }
                
                let properties = JSONRoute["properties"] as? [String: AnyObject]
                let price = JSONRoute["price"] as? [String: AnyObject]
            }
        }
    }
}
