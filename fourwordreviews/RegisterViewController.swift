//
//  RegisterViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var registerUsername: UITextField!
    @IBOutlet weak var registerEmailAddress: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerSignupButton: UIButton!
    @IBOutlet weak var invalidRegistrationLabel: UILabel!
    
    let defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func userRegister(_ sender: Any) {
        let username : String? = registerUsername.text
        let email : String? = registerEmailAddress.text
        let password: String? = registerPassword.text
        
        let postBody = ["username": username, "email": email, "password": password]
        
        
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/register")!
        var request = URLRequest(url: reviewEndpoint)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Registration Successful!", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // dismiss after a few seconds
                        alert.dismiss(animated: true, completion: nil)
                    }
                    // set login credentials
                    let loginViewController = LoginViewController()
                    loginViewController.loginEmailAddress = UITextField()
                    loginViewController.loginEmailAddress.text = email
                    loginViewController.loginPassword = UITextField()
                    loginViewController.loginPassword.text = password
                    
                    // call login function with new credentials
                    loginViewController.userLogin([])
                }
            } else {
                DispatchQueue.main.async {
                    self.invalidRegistrationLabel.text = "Unable to register. Try Again in a few minutes."
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // auto reset label after a few seconds
                        self.invalidRegistrationLabel.text = ""
                    }
                }
            }
            
        })
        task.resume()
    }
    
}

