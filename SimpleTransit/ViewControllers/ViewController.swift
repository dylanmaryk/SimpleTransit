//
//  ViewController.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataModelDelegate {
    @IBOutlet var routeTableView: UITableView!
    
    var routes = [Route]()
    var routeSelected: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataModel = DataModel()
        dataModel.delegate = self
        dataModel.updateRoutes()
    }
    
    func routesUpdated(routes: [Route]) {
        self.routes = routes
        routeTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let routeCell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath: indexPath) as! RouteTableViewCell
        let route = routes[indexPath.row]
        routeCell.setupCell(route)
        return routeCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        routeSelected = routes[indexPath.row]
        performSegueWithIdentifier("ShowRoute", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRoute",
            let routeVC = segue.destinationViewController as? RouteViewController,
            route = routeSelected {
            routeVC.route = route
        }
    }
}
