//
//  ViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var word1TextField: UITextField!
    @IBOutlet weak var word2TextField: UITextField!
    @IBOutlet weak var word3TextField: UITextField!
    @IBOutlet weak var word4TextField: UITextField!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var fourWordReviewLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        // Set the picker to use the camera
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .photoLibrary
        }
        else{
            imagePickerController.sourceType = .camera
        }
        
        // Make sure ViewController is notified when user takes an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
        
    }
    
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

