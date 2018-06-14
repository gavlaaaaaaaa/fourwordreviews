//
//  UserSingleton.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//
import Foundation

class UserSingleton {
    
    static let sharedInstance: UserSingleton = { UserSingleton() }()
    var user_id: Int!
    
}
