//
//  UserResponse.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 20/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class UserResponse: Codable {
    
    var username: String?
    var id: Int?
    var email: String?
    var image_url: String?
    var users = [User]()
    
    private enum RootKeys: String, CodingKey{
        case status, error, response
    }
    private enum CodingKeys: String, CodingKey {
        case username
        case id
        case email
        case image_url
    }
    
    required init(from decoder:Decoder) throws{
        let base = try decoder.container(keyedBy: RootKeys.self)
        var usersContainer = try base.nestedUnkeyedContainer(forKey: .response)
        
        while !usersContainer.isAtEnd {
            let userContainer = try usersContainer.nestedContainer(keyedBy: CodingKeys.self)
            username = try userContainer.decode(String.self, forKey: .username)
            email = try userContainer.decode(String.self, forKey: .email)
            id = try userContainer.decode(Int.self, forKey: .id)
            do { image_url = try userContainer.decode(String.self, forKey: .image_url)} catch{  image_url = ""}
            let user : User = User(id: id!, username: username!, email: email!, image: image_url!)
            users.append(user)
        }
        
    }
    
}
