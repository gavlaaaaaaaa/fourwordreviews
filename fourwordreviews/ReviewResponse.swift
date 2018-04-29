//
//  BeerReview.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 29/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class ReviewResponse: Codable {
   
    var product_name: String?
    var word1: String?
    var word2: String?
    var word3: String?
    var word4: String?
    var rating: Int?
    var image_url: String?
    var beers = [BeerReview]()
    
    private enum RootKeys: String, CodingKey{
        case status, error, response
    }
    private enum CodingKeys: String, CodingKey {
        case product_name
        case word1
        case word2
        case word3
        case word4
        case rating
        case image_url
    }
        
    required init(from decoder:Decoder) throws{
        let base = try decoder.container(keyedBy: RootKeys.self)
        var beersContainer = try base.nestedUnkeyedContainer(forKey: .response)
        
        while !beersContainer.isAtEnd {
            let beerContainer = try beersContainer.nestedContainer(keyedBy: CodingKeys.self)
            product_name = try beerContainer.decode(String.self, forKey: .product_name)
            word1 = try beerContainer.decode(String.self, forKey: .word1)
            word2 = try beerContainer.decode(String.self, forKey: .word2)
            word3 = try beerContainer.decode(String.self, forKey: .word3)
            word4 = try beerContainer.decode(String.self, forKey: .word4)
            rating = try beerContainer.decode(Int.self, forKey: .rating)
            do { image_url = try beerContainer.decode(String.self, forKey: .image_url)} catch{  image_url = ""}
            let beer : BeerReview = BeerReview(name: product_name!, word1: word1!, word2: word2!, word3: word3!, word4: word4!, rating: rating!, image: image_url!)
            beers.append(beer)
        }
       
    }
    
}
