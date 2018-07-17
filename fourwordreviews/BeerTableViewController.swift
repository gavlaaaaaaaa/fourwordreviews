//
//  BeerTableViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 24/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore


class BeerTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var beers = [BeerReview]()
    let cellReuseIdentifier = "BeerTableViewCell"
    let cellSpacingHeight: CGFloat = 10
    private let myRefreshControl = UIRefreshControl()
    let transferManager = AWSS3TransferManager.default()

    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async{
            self.loadBeers()
         
        }
        myRefreshControl.addTarget(self, action: #selector(refreshBeers(_:)), for: .valueChanged)

        myRefreshControl.tintColor = UIColor.blue
        self.tableView.addSubview(myRefreshControl)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? BeerTableViewCell else {
            fatalError("The dequeued cell is not an instance of BeerTableViewCell.")
        }
        let beer = beers[indexPath.row]
        cell.nameLabel.text = beer.name
        cell.ratingControl.rating = beer.rating!
        cell.fourWordReviewLabel.text = "\(String(describing:  beer.word1!)), \(String(describing:  beer.word2!)), \(String(describing:  beer.word3!)), \(String(describing: beer.word4!))"
        
        if beer.image != nil {
            cell.imageView?.image = beer.image
            cell.imageView?.setNeedsLayout()
            cell.imageView?.layoutIfNeeded()
        }
        else{
            if !(beer.imageUrl?.isEmpty)!{
                if let url = URL(string: beer.imageUrl!)  {
                    Utils.getImageFromUrl(imageUrl: url, completionHandler: { (success,image) in
                        if success {
                            beer.image = image
                            DispatchQueue.main.async {
                                cell.imageView?.image = image
                                cell.imageView?.setNeedsLayout()
                                cell.imageView?.layoutIfNeeded()
                            }
                        }
                    })
                }
            }
            else {
                beer.image = UIImage(named: "defaultPhoto")
            }
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Actions
    
    @IBAction func addReviewButton(sender: UIStoryboardSegue) {
        if let sourceViewController : AddReviewViewController = sender.source as? AddReviewViewController {
            
            let product_name : String = sourceViewController.nameTextField.text ?? ""
            let word1 : String = sourceViewController.word1TextField.text ?? ""
            let word2 : String = sourceViewController.word2TextField.text ?? ""
            let word3 : String = sourceViewController.word3TextField.text ?? ""
            let word4 : String = sourceViewController.word4TextField.text ?? ""
            let rating : String = String(sourceViewController.ratingControl?.rating ?? 0)
            let latitude = sourceViewController.selectedLocation?.placemark.coordinate.latitude ?? 0.0
            let longitude = sourceViewController.selectedLocation?.placemark.coordinate.longitude ?? 0.0
            let location_name = sourceViewController.selectedLocation?.placemark.name ?? ""
            let location_address = sourceViewController.selectedLocationAddress ?? ""
            var imageUrl = ""
            //TODO: Refactor and move into seperate place
            
            if let image : UIImage = sourceViewController.photoImageView.image{
                
                //store image to disk
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory : NSString = paths[0] as NSString
                let imageFileUrl = URL(fileURLWithPath: documentsDirectory.appendingPathComponent("tempreviewfile"+String(UserSingleton.sharedInstance.user_id)) as String)

                if let data = UIImageJPEGRepresentation(image, 0.75){
                    do {
                        try data.write(to: imageFileUrl)
                        print("Successfully saved image at path: \(imageFileUrl)")
                    } catch {
                        print("Error saving image: \(error)")
                    }
                }
                
                let uploadRequest = AWSS3TransferManagerUploadRequest()!
                
                uploadRequest.bucket = AWSConfigSingleton.sharedInstance.imageS3Bucket
                uploadRequest.key = AWSConfigSingleton.sharedInstance.reviewImageFolder+"/"+String(UserSingleton.sharedInstance.user_id)+"/"+String(Date().timeIntervalSince1970)+product_name+".jpeg"
                uploadRequest.body = imageFileUrl
                let savingAlert = UIAlertController(title: "Saving Review", message: "Saving...", preferredStyle: UIAlertControllerStyle.alert)
                self.present(savingAlert, animated: true, completion: nil)
                    
                transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                    savingAlert.dismiss(animated: true, completion: nil)
                    if let error = task.error as NSError? {
                        let failedAlert = UIAlertController(title: "Whoops", message: "Looks like our servers are drunk. Unable to save your review! Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(failedAlert, animated: true, completion: nil)
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            failedAlert.dismiss(animated: true, completion: nil)
                        }
                        
                        if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                            switch code {
                            case .cancelled, .paused:
                                break
                            default:
                                print("Error uploading: \(uploadRequest.key ?? "") Error: \(error)")
                            }
                        } else {
                            print("Error uploading: \(uploadRequest.key ?? "") Error: \(error)")
                        }
                        return nil
                    }

                    imageUrl = "https://s3.eu-west-2.amazonaws.com/"+AWSConfigSingleton.sharedInstance.imageS3Bucket+"/"+uploadRequest.key!.replacingOccurrences(of: " ", with: "+")
                    //let uploadOutput = task.result
                    print("Upload complete for: \(uploadRequest.key ?? "")")
                    
                    let postBody = ["product_name": product_name, "user_id": String(UserSingleton.sharedInstance.user_id), "word1": word1, "word2": word2, "word3": word3, "word4": word4, "rating": rating,
                                    "latitude": latitude, "longitude":longitude, "location_name": location_name, "location_address": location_address, "image_url": imageUrl ] as [String : Any]
                    
                    
                    let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews")!
                    var request = URLRequest(url: reviewEndpoint)
                    request.httpMethod = "POST"
                    request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                        if let data = data {
                            let json = try? JSONSerialization.jsonObject(with: data)
                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                                self.addBeer(json: json as? [String:Any])
                            } else {
                                
                            }
                        }
                    })
                    task.resume()
                    return nil
                })
            }
            
            
        }
        
        
    }
    //MARK: Private Methods
    @objc private func refreshBeers(_ sender: Any){
        loadBeers()
    }
    
    
    private func loadBeers(){
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews/user/"+String(UserSingleton.sharedInstance.user_id))!
        let task = session.dataTask(with: reviewEndpoint) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                //completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                self.beers = try decoder.decode(ReviewResponse.self, from:data).beers
                self.beers.sort(by: { (a, b) -> Bool in
                    a.rating! > b.rating!
                })
                DispatchQueue.main.async {

                    self.tableView.reloadData()
                    self.myRefreshControl.endRefreshing()
                }

            } catch let err {
                print ("Error:", err)
            }
        };
        task.resume()
    }
    
    private func addBeer(json: [String:Any]?){
        let data = json!["data"] as? [String:Any]
        let insertId : Int = data!["insertId"] as! Int
        
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews/"+String(insertId))!
        let task = session.dataTask(with: reviewEndpoint) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                //completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                self.beers.append(try decoder.decode(ReviewResponse.self, from:data).beers[0])
                self.beers.sort(by: { (a, b) -> Bool in
                    a.rating! > b.rating!
                })
                
                self.tableView.reloadData()
                
            } catch let err {
                print ("Error:", err)
            }
        };
        task.resume()
    }
    

}
