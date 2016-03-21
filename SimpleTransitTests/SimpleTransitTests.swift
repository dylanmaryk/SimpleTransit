//
//  SimpleTransitTests.swift
//  SimpleTransitTests
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import XCTest
@testable import SimpleTransit

class SimpleTransitTests: XCTestCase, DataModelDelegate {
    var expectation: XCTestExpectation?
    var routes = [Route]()
    
    override func setUp() {
        super.setUp()
        
        expectation = expectationWithDescription("DataModel updates routes")
        
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.updateRoutes()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func routesUpdated(routes: [Route]) {
        self.routes = routes
        
        expectation?.fulfill()
    }
    
    func testPriceFormatted() {
        XCTAssertEqual(routes.first?.priceFormatted, "EUR 270.00")
    }
    
    func testOriginFromName() {
        XCTAssertEqual(routes[3].origin, "Torstraße 103, 10119 Berlin, Deutschland")
    }
}
