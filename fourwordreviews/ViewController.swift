//
//  ViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit
import os.log
import MapKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
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
    @IBOutlet weak var locationButton: UIButton!
    let locationManager = CLLocationManager()
    var userLocation : CLLocation? = nil
    var selectedLocation: MKMapItem? = nil
    var selectedLocationAddress: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        word1TextField.delegate = self
        word2TextField.delegate = self
        word3TextField.delegate = self
        word4TextField.delegate = self
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if textField == nameTextField {
            navigationItem.title = textField.text
        }
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
        if(segue.identifier == "AddItem"){
            // Configure the destination view controller only when the save button is pressed.
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
                return
            }
        }
        
        if (segue.identifier == "locationSegue") {
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let nav = segue.destination as! UINavigationController
            let locationVC = nav.topViewController as! LocationSearchViewController;
            locationVC.userLocation = self.userLocation
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
    
    @IBAction func unwindFromGetLocationVC(_ sender: UIStoryboardSegue){
        if sender.source is LocationSearchViewController {
            if let locationVC = sender.source as? LocationSearchViewController {
                self.selectedLocation = locationVC.selectedLocation
                self.selectedLocationAddress = locationVC.parseAddress(selectedItem: (selectedLocation?.placemark)!)
            }
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text == ""
        let fourwords = word1TextField.text == "" || (word1TextField.text?.split(separator: " ").count)! > 1 ||
            word2TextField.text == "" || ( word2TextField.text?.split(separator: " ").count)! > 1 ||
            word3TextField.text == "" || (word3TextField.text?.split(separator: " ").count)! > 1 ||
            word4TextField.text == "" || (word4TextField.text?.split(separator: " ").count)! > 1
        
        saveButton.isEnabled = !text && !fourwords
    }
    
    
    
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            locationButton.isEnabled = true
            locationManager.requestLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        /*for (_,location) in locations.enumerated() {
            print("location:: \(location)")
        }*/
        
        if let location = locations.first {
            userLocation = location
        }
        
    }
    
}

