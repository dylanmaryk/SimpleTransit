//
//  ViewController.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 13/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DataModelDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataModel().updateRoutes()
    }
    
    func routesUpdated(routes: [Route]) {
        
    }
}
