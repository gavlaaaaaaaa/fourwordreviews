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

class API {
    
    let userEndpoint : String =  "http://localhost:3000/api/v1/users/"
    let reviewsEndpoint : String = "http://localhost:3000/api/v1/reviews/"
    
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
    
    func getUserByID(userId: Int, completionHandler: @escaping (_ success: Bool, _ user: User?) -> Void) {
        
        URLSession.shared.dataTask(with: URL(string: self.userEndpoint+String(userId))!) {(data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Failed fetching user:", error)
                completionHandler(false, nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                let getUser = try decoder.decode(UserResponse.self, from:data!).users[0]
                completionHandler(true, getUser)
                return

            } catch let err {
                print ("Error:", err)
                completionHandler(false, nil)
                return
            }
        }.resume()
    }
    
    func updateUserByID(userId: Int, username: String, email: String, completionHandler: @escaping (_ success: Bool) -> Void){
        let postBody = ["username": username, "email": email]

        var request = URLRequest(url: URL(string: self.userEndpoint+String(userId))!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Failed fetching user:", error)
                completionHandler(false)
                return
            }
            else{
                completionHandler(true)
                return
            }
        }.resume()
    }
    
    func searchReviews(searchTerm: String, completionHandler: @escaping (_ success: Bool, _ reviews: [BeerReview]?) -> Void) {
        URLSession.shared.dataTask(with: URL(string: self.reviewsEndpoint+"search?term="+searchTerm)!) {(data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Failed fetching search results:", error)
                completionHandler(false, nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                let getReviews = try decoder.decode(ReviewResponse.self, from:data!).beers
                completionHandler(true, getReviews)
                return
                
            } catch let err {
                print ("Error:", err)
                completionHandler(false, nil)
                return
            }
            }.resume()
        
    }
}
