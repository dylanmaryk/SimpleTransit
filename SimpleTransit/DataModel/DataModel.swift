//
//  DataModel.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

protocol DataModelDelegate: class {
    func routesUpdated(routes: [Route])
}

class DataModel {
    weak var delegate: DataModelDelegate?
    
    func updateRoutes() {
        Alamofire.request(.GET, "https://raw.githubusercontent.com/allyapp/transit-app-task/master/data.json").responseJSON { response in
            guard let responseValue = response.result.value else {
                return
            }
            
            let json = JSON(responseValue)
            
            var routes = [Route]()
            
            for jsonRoute in json["routes"].arrayValue {
                let type = jsonRoute["type"].string
                
                var providerName = jsonRoute["provider"].string
                var providerURL: String?
                var providerIconURL: String?
                
                if let validProvider = providerName,
                    jsonProviderAttribute = json["provider_attributes"][validProvider].dictionary {
                    providerName = jsonProviderAttribute["display_name"]?.string
                    providerURL = jsonProviderAttribute["ios_itunes_url"]?.string
                    providerIconURL = jsonProviderAttribute["provider_icon_url"]?.string
                }
                
                var segments = [Segment]()
                
                for jsonSegment in jsonRoute["segments"].arrayValue {
                    let segmentName = jsonSegment["name"].string
                    
                    var stops = [Stop]()
                    
                    for jsonStop in jsonSegment["stops"].arrayValue {
                        let lat = jsonStop["lat"].double
                        let lng = jsonStop["lng"].double
                        let dateTime = jsonStop["datetime"].string
                        let stopName = jsonStop["name"].string
                        let stop = Stop(lat: lat, lng: lng, dateTime: dateTime, name: stopName)
                        stops.append(stop)
                    }
                    
                    let travelMode = jsonSegment["travel_mode"].string
                    let description = jsonSegment["description"].string
                    let color = jsonSegment["color"].string
                    let iconURL = jsonSegment["icon_url"].string
                    let polyline = jsonSegment["polyline"].string // Temporarily just hold as string
                    let segment = Segment(name: segmentName, stops: stops, travelMode: travelMode, description: description, color: color, iconURL: iconURL, polyline: polyline)
                    segments.append(segment)
                }
                
                let properties = jsonRoute["properties"].dictionaryObject // Temporarily just hold arbitrary data
                
                var price: (currency: String, amount: Double)?
                let validPrice = jsonRoute["price"]
                
                if let currency = validPrice["currency"].string,
                    amount = validPrice["amount"].double {
                    price = (currency, amount)
                }
                
                let route = Route(type: type, providerName: providerName, providerURL: providerURL, providerIconURL: providerIconURL, segments: segments, properties: properties, price: price)
                routes.append(route)
            }
            
            self.delegate?.routesUpdated(routes)
        }
    }
}
