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
    var providerIconURL: String?
    var segments: [Segment]
    var properties: [String: AnyObject]?
    var price: (currency: String, amount: Double)?
    var priceFormatted: String? {
        get {
            guard let priceCurrency = price?.currency,
                priceAmount = price?.amount else {
                    return nil
            }
            
            let priceAmountString = NSString(format: " %.2f", priceAmount) as String
            return priceCurrency + priceAmountString
        }
    }
    var origin: String? {
        get {
            guard let firstStop = getFirstStop() else {
                return nil
            }
            
            return firstStop.name
        }
    }
    var destination: String? {
        get {
            guard let lastStop = getLastStop() else {
                return nil
            }
            
            return lastStop.name
        }
    }
    
    init(type: String?, providerName: String?, providerURL: String?, providerIconURL: String?, segments: [Segment], properties: [String: AnyObject]?, price: (currency: String, amount: Double)?) {
        self.type = type
        self.providerName = providerName
        self.providerURL = providerURL
        self.providerIconURL = providerIconURL
        self.segments = segments
        self.properties = properties
        self.price = price
        
        createOriginDestination()
    }
    
    func createOriginDestination() {
        if let firstStop = getFirstStop() {
            firstStop.createName()
        }
        
        if let lastStop = getLastStop() {
            lastStop.createName()
        }
    }
    
    func getFirstStop() -> Stop? {
        return segments.first?.stops.first
    }
    
    func getLastStop() -> Stop? {
        return segments.last?.stops.last
    }
}
