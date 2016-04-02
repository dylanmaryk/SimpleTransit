//
//  RouteTableViewCell.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 31/03/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Alamofire
import CloudConvert
import UIKit

class RouteTableViewCell: UITableViewCell {
    @IBOutlet weak var providerIconImageView: UIImageView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var journeyTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupCell(route: Route) {
        if let providerIconURL = route.providerIconURL {
            let inputFormat = "svg"
            let outputFormat = "png"
            
            let providerIconDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let providerIconName = ((providerIconURL as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
            let providerIconPath = providerIconDir.absoluteString + providerIconName
            let providerIconPathOriginal = providerIconPath + "." + inputFormat
            let providerIconPathConverted = providerIconPath + "." + outputFormat
            
            if let imagePath = self.removeFilePrefixFromPath(providerIconPathConverted),
                providerIconImage = UIImage(contentsOfFile: imagePath) {
                    self.providerIconImageView.image = providerIconImage
            } else {
                let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
                Alamofire.download(.GET, providerIconURL, destination: destination).response { response in
                    if let providerIconPathOriginalURL = NSURL(string: providerIconPathOriginal),
                        providerIconPathConvertedURL = NSURL(string: providerIconPathConverted) {
                            CloudConvert.apiKey = "q6QFqfv1ijW8reXIP72a99Eu7-h988adr_mwk7pIc7ctpz1RJeY3_r3-NlrOncxLkVAMffvHQdsvTWEOOHOKhw" // Temporarily hard-coded, should be in a config file
                            CloudConvert.convert(
                                ["inputformat": inputFormat,
                                "outputformat": outputFormat,
                                "input": "upload",
                                "file": providerIconPathOriginalURL,
                                "download": providerIconPathConvertedURL],
                                progressHandler: nil,
                                completionHandler: { (path, error) -> Void in
                                    if let imagePath = self.removeFilePrefixFromPath(path?.absoluteString) {
                                        self.providerIconImageView.image = UIImage(contentsOfFile: imagePath)
                                    }
                            })
                    }
                }
            }
        }
        
        route.createOrigin { (origin: String?) -> Void in
            self.fromLabel.text = origin
        }
        
        route.createDestination { (destination: String?) -> Void in
            self.toLabel.text = destination
        }
        
        if let journeyTime = route.journeyTime {
            journeyTimeLabel.text = "Journey time: \(journeyTime) minutes"
        }
        
        if let priceFormatted = route.priceFormatted {
            priceLabel.text = priceFormatted
        }
    }
    
    private func removeFilePrefixFromPath(path: String?) -> String? {
        return path?.stringByReplacingOccurrencesOfString("file://", withString: "")
    }
}
