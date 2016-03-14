//
//  Route.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Foundation

class Route {
    var type: String?
    var providerName: String?
    var providerURL: String?
    var segments: [Segment]
    var properties: [String: AnyObject]?
    var price: (currency: String, amount: Double)?
    
    init(type: String?, providerName: String?, providerURL: String?, segments: [Segment], properties: [String: AnyObject]?, price: (currency: String, amount: Double)?) {
        self.type = type
        self.providerName = providerName
        self.providerURL = providerURL
        self.segments = segments
        self.properties = properties
        self.price = price
    }
}
