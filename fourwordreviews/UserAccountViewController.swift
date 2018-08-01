//
//  UserAccountViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 01/08/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    let api = API()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.getUserByID(userId: UserSingleton.sharedInstance.user_id) { (result, user) in
            if result {
                DispatchQueue.main.async {
                    self.usernameField.text = user?.username
                    self.emailField.text = user?.email
                }
            }
            
        }
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary contaiing an image but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateUser(_ sender: Any) {
        api.updateUserByID(userId: UserSingleton.sharedInstance.user_id, username: usernameField.text!, email: emailField.text!) { (result) in
            if result {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Update Successful!", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // dismiss after a few seconds
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
            }
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed!", message: "Update Failed, try again!", preferredStyle: .alert)
                    self.present(alert, animated: true)
                    
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // dismiss after a few seconds
                        alert.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
