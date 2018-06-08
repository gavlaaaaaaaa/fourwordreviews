//
//  BeerTableViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 24/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit


class BeerTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var beers = [BeerReview]()
    let cellReuseIdentifier = "BeerTableViewCell"
    let cellSpacingHeight: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async{
            self.loadBeers()
         
        }
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
        return beers.count
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? BeerTableViewCell else {
            fatalError("The dequeued cell is not an instance of BeerTableViewCell.")
        }
        let beer = beers[indexPath.section]
        cell.nameLabel.text = beer.name
        cell.ratingControl.rating = beer.rating!
        cell.fourWordReviewLabel.text = "\(String(describing:  beer.word1!)), \(String(describing:  beer.word2!)), \(String(describing:  beer.word3!)), \(String(describing: beer.word4!))"

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
        let sourceViewController = sender.source as? ViewController
        if sourceViewController != nil {
            
            let rating : String? = String(sourceViewController!.ratingControl.rating)
            let postBody = ["product_name": sourceViewController!.nameTextField.text, "word1": sourceViewController!.word1TextField.text, "word2": sourceViewController!.word2TextField.text, "word3": sourceViewController!.word3TextField.text, "word4": sourceViewController!.word4TextField.text, "rating": rating]
            
            
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
        }
        
        
    }
    //MARK: Private Methods
    
    private func loadBeers(){
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews")!
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
                self.tableView.reloadData()

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
