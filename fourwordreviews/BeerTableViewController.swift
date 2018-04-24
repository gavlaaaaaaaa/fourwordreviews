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
    
    //var beers = [Beer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBeers()
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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    //MARK: Private Methods
    
    private func loadBeers(){
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let reviewEndpoint = URL(string: "http://localhost:3000/api/v1/reviews")!
        let task = session.dataTask(with: reviewEndpoint, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                //completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                //completion(nil)
                return
            }
            let dataArray = json!["response"] as! NSArray
            //TODO: Create Beer object and parse items into Beer array
            for item in dataArray {
                let beer = item as! NSDictionary
                let name : String = beer.value(forKey: "product_name") as! String
                print(name)
            }
            //print(json)
            //completion(result)
        })
        task.resume()
    }

}
