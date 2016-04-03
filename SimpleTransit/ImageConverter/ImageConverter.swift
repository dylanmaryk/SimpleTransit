//
//  ImageConverter.swift
//  SimpleTransit
//
//  Created by Dylan Maryk on 03/04/2016.
//  Copyright © 2016 Dylan Maryk. All rights reserved.
//

import Alamofire
import CloudConvert
import UIKit

class ImageConverter {
    static func imageForSVGAtURL(svgURL: String?, completion: (image: UIImage?) -> Void) {
        if let imageURL = svgURL {
            let inputFormat = "svg"
            let outputFormat = "png"
            
            let providerIconDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let providerIconName = ((imageURL as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
            let providerIconPath = providerIconDir.absoluteString + providerIconName
            let providerIconPathOriginal = providerIconPath + "." + inputFormat
            let providerIconPathConverted = providerIconPath + "." + outputFormat
            
            if let imagePath = removeFilePrefixFromPath(providerIconPathConverted),
                providerIconImage = UIImage(contentsOfFile: imagePath) {
                completion(image: providerIconImage)
            } else {
                let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
                Alamofire.download(.GET, imageURL, destination: destination).response { response in
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
                                    completion(image: UIImage(contentsOfFile: imagePath))
                                }
                        })
                    }
                }
            }
        }
    }
    
    private static func removeFilePrefixFromPath(path: String?) -> String? {
        return path?.stringByReplacingOccurrencesOfString("file://", withString: "")
    }
}
