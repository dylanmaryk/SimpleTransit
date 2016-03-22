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
    var expectationDataModel: XCTestExpectation?
    var routes = [Route]()
    
    override func setUp() {
        super.setUp()
        
        expectationDataModel = expectationWithDescription("DataModel updates routes")
        
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.updateRoutes()
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func routesUpdated(routes: [Route]) {
        self.routes = routes
        
        expectationDataModel?.fulfill()
    }
    
    func testPriceFormatted() {
        XCTAssertEqual(routes.first?.priceFormatted, "EUR 270.00")
    }
    
    func testOriginFromLocation() {
        let expectation = expectationWithDescription("Route creates origin from location")
        
        routes.first?.createOrigin { (origin: String?) -> Void in
            XCTAssertEqual(origin, "Torstraße 105, 10119 Berlin, Germany")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testOriginFromName() {
        let expectation = expectationWithDescription("Route creates origin from name")
        
        routes[3].createOrigin { (origin: String?) -> Void in
            XCTAssertEqual(origin, "Torstraße 103, 10119 Berlin, Deutschland")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testDestinationFromName() {
        let expectation = expectationWithDescription("Route creates destination from name")
        
        routes[3].createDestination { (destination: String?) -> Void in
            XCTAssertEqual(destination, "Leipziger Platz 7, 10117 Berlin, Deutschland")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
}
