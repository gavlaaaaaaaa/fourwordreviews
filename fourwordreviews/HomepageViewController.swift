//
//  HomepageTableViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 07/08/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore


class HomepageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    var beers = [BeerReview]()
    let cellReuseIdentifier = "BeerTableViewCell"
    private let myRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.async{
            self.loadBeers()
            
        }
        
        myRefreshControl.addTarget(self, action: #selector(refreshBeers(_:)), for: .valueChanged)
        
        myRefreshControl.tintColor = UIColor.blue
        self.tableView.addSubview(myRefreshControl)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? BeerTableViewCell else {
            fatalError("The dequeued cell is not an instance of BeerTableViewCell.")
        }
        let beer = beers[indexPath.row]
        cell.nameLabel.text = beer.name
        cell.ratingControl.rating = beer.rating!
       // cell.fourWordReviewLabel.text = "\(String(describing:  beer.word1!)), \(String(describing:  beer.word2!)), \(String(describing:  beer.word3!)), \(String(describing: beer.word4!))"
        
        if beer.image != nil {
            cell.imageView?.image = beer.image
            cell.imageView?.setNeedsLayout()
            cell.imageView?.layoutIfNeeded()
        }
        else{
            if !(beer.imageUrl?.isEmpty)!{
                if let url = URL(string: beer.imageUrl!)  {
                    API.getImageFromUrl(imageUrl: url, completionHandler: { (success,image) in
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

    
    
}
