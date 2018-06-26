//
//  AWSConfigSingleton.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 22/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import Foundation

class AWSConfigSingleton {
    
    static let sharedInstance: AWSConfigSingleton = { AWSConfigSingleton() }()
    var imageS3Bucket: String = "fourwordbeerreview-images"
    var reviewImageFolder: String = "review_images"
    
    
}
