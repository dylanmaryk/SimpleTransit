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
            
            var routes = [Route]()
            
            for JSONRoute in JSONRoutes {
                let type = JSONRoute["type"] as? String
                var providerName = JSONRoute["provider"] as? String
                var providerURL: String?
                var providerIconURL: String?
                
                if let validProvider = providerName,
                    JSONProviderAttributes = JSON["provider_attributes"] as? [String: [String: String]],
                    JSONProviderAttribute = JSONProviderAttributes[validProvider] {
                        if let iconURL = JSONProviderAttribute["provider_icon_url"] {
                            providerIconURL = iconURL
                        }
                        
                        if let iTunesURL = JSONProviderAttribute["ios_itunes_url"],
                            displayName = JSONProviderAttribute["display_name"] {
                                providerName = displayName
                                providerURL = iTunesURL
                            }
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
                        let polyline = JSONSegment["polyline"] as? String // Temporarily just hold as string
                        let segment = Segment(name: segmentName, stops: stops, travelMode: travelMode, description: description, color: color, iconURL: iconURL, polyline: polyline)
                        segments.append(segment)
                    }
                }
                
                let properties = JSONRoute["properties"] as? [String: AnyObject] // Temporarily just hold arbitrary data
                var price: (currency: String, amount: Double)?
                
                if let validPrice = JSONRoute["price"] as? [String: AnyObject],
                    currency = validPrice["currency"] as? String,
                    amount = validPrice["amount"] as? Double {
                        price = (currency, amount)
                }
                
                let route = Route(type: type, providerName: providerName, providerURL: providerURL, providerIconURL: providerIconURL, segments: segments, properties: properties, price: price)
                routes.append(route)
            }
            
            self.delegate?.routesUpdated(routes)
        }
    }
}
