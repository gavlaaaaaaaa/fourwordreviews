//
//  ViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit
import os.log


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
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
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
    
   
    
}

