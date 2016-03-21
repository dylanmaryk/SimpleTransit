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
    var priceFormatted: String?
    
    init(type: String?, providerName: String?, providerURL: String?, providerIconURL: String?, segments: [Segment], properties: [String: AnyObject]?, price: (currency: String, amount: Double)?) {
        self.type = type
        self.providerName = providerName
        self.providerURL = providerURL
        self.providerIconURL = providerIconURL
        self.segments = segments
        self.properties = properties
        self.price = price
        
        if let priceCurrency = price?.currency,
            priceAmount = price?.amount {
                let priceAmountString = NSString(format: " %.2f", priceAmount) as String
                priceFormatted = priceCurrency + priceAmountString
        }
    }
    
    func createOrigin(completion: (origin: String?) -> Void) {
        guard let firstStop = getFirstStop() else {
            completion(origin: nil)
            return
        }
        
        if let name = firstStop.name {
            completion(origin: name)
        }
        
        firstStop.createNameFromLocation { (name: String?) -> Void in
            completion(origin: name)
        }
    }
    
    private func getFirstStop() -> Stop? {
        return segments.first?.stops.first
    }
    
    private func getLastStop() -> Stop? {
        return segments.last?.stops.last
    }
}
