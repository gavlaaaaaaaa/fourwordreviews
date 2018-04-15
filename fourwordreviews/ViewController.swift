//
//  ViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var word1TextField: UITextField!
    @IBOutlet weak var word2TextField: UITextField!
    @IBOutlet weak var word3TextField: UITextField!
    @IBOutlet weak var word4TextField: UITextField!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var fourWordReviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func addReviewButton(_ sender: UIButton) {
        
        let postBody = ["product_name": nameTextField.text, "word1": word1TextField.text, "word2": word2TextField.text, "word3": word3TextField.text, "word4": word4TextField.text]
        
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews")!
        var request = URLRequest(url: reviewEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
        
    }
    
}

