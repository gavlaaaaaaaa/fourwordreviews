//
//  BeerReview.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 29/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class BeerReview: NSObject {
    
    let name : String?
    let word1: String?
    let word2: String?
    let word3: String?
    let word4: String?
    let rating: Int?
    let imageUrl: String?
    var image: UIImage?
    

    init(name: String, word1: String, word2: String, word3: String, word4: String, rating: Int, imageUrl: String, image: UIImage?){
        self.name = name
        self.word1 = word1
        self.word2 = word2
        self.word3 = word3
        self.word4 = word4
        self.rating = rating
        self.imageUrl = imageUrl
        self.image = image
    }
}
