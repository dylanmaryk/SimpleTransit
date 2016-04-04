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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerHeight = self.tableView(tableView, heightForHeaderInSection: section)
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, headerHeight))
        
        let segment = route.segments[section]
        
        let travelModeX: CGFloat = 8
        let travelModeWidth = headerHeight - (travelModeX * 2)
        let travelModeImageView = UIImageView(frame: CGRectMake(travelModeX, travelModeX, travelModeWidth, travelModeWidth))
        
        ImageConverter.imageForSVGAtURL(segment.iconURL) { (image: UIImage?) -> Void in
            travelModeImageView.image = image
        }
        
        let segmentX = (travelModeX * 2) + travelModeWidth
        let segmentWidth = tableView.frame.size.width - segmentX - travelModeX
        let segmentLabel = UILabel(frame: CGRectMake(segmentX, travelModeX, segmentWidth, travelModeWidth))
        
        let numStops = segment.numStops
        let numStopsText = numStops == 1 ? "\(numStops) stop" : "\(numStops) stops"
        
        if let name = segment.name {
            if let description = segment.description {
                segmentLabel.text = "\(name) to \(description): \(numStopsText)"
            } else {
                segmentLabel.text = "\(name): \(numStopsText)"
            }
        } else {
            segmentLabel.text = numStopsText
        }
        
        headerView.backgroundColor = segment.color
        headerView.addSubview(travelModeImageView)
        headerView.addSubview(segmentLabel)
        return headerView
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
