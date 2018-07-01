//
//  Utils.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 01/07/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class Utils {
    static func getImageFromUrl(imageUrl: URL, completionHandler: @escaping (_ success: Bool, _ image: UIImage?) -> Void) {

        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            let imageurl = imageUrl
            if error != nil {
                print("Failed fetching image:", error)
                completionHandler(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                completionHandler(false, nil)
                return
            }
            
            completionHandler(true, UIImage(data: data!))
            
        }.resume()
        
        
    }
}
