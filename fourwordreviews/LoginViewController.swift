//
//  LoginViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 13/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var loginEmailAddress: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var invalidLoginLabel: UILabel!
    
    let defaultValues = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func userLogin(_ sender: Any) {
        let email : String? = loginEmailAddress.text
        let password: String? = loginPassword.text
        
        let postBody = ["email": email, "password": password]
        
        
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/login")!
        var request = URLRequest(url: reviewEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                //parse user id from json result
                let json = try? JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                let user_id = json!["user_id"] as? Int
                //store user id in UserDefaults so its remembered for next time
                self.defaultValues.set(user_id, forKey: "user_id")
                
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Login Successful!", preferredStyle: .alert)
                        
                        UserSingleton.sharedInstance.user_id = self.defaultValues.integer(forKey: "user_id")
                        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
                        
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                        
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.invalidLoginLabel.text = "Invalid Username or Password. Try Again."
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            self.invalidLoginLabel.text = ""
                        }
                    }
                }
            }
            
        })
        task.resume()
        
    }
    
}
