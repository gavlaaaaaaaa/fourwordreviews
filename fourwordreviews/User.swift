//
//  User.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 20/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let id: Int?
    let username : String?
    let image: String?
    
    
    init(id: Int, username: String, image: String){
        self.id = id
        self.username = username
        self.image = image
    }
}
