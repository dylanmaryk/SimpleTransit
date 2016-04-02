//
//  RouteViewController.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 02/04/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var stopTableView: UITableView!
    
    var route: Route!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return route.segments.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.segments[section].stops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let stopCell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath: indexPath) as! StopTableViewCell
        let stop = route.segments[indexPath.section].stops[indexPath.row]
        stopCell.setupCell(stop)
        return stopCell
    }
}
