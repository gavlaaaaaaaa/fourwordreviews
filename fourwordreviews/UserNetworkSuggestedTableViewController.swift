//
//  UserNetworkTableViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 20/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class UserNetworkSuggestedTableViewController: UITableViewController  {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    let cellReuseIdentifier = "userCell"
    
    var suggested:[User] = []
    
    // will be passed from prepare for segue function
    var userNetworkVC: UserNetworkTableViewController?
    
    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSuggested(userId: UserSingleton.sharedInstance.user_id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggested.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UserNetworkTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserNetworkTableViewCell.")
        }
        
        let suggestedUser : User = suggested[indexPath.row]
        cell.usernameLabel.text = suggestedUser.username
        
        return cell
        
    }


    
    
    //MARK - Actions
    
    
    @IBAction func followButtonPressed(_ sender: AnyObject) {
        let senderCell = sender.superview??.superview as! UserNetworkTableViewCell
        
        let selectedUser: User = suggested[(self.tableView.indexPath(for: senderCell)?.row)!]
        // call the followUser function created in the main network view controller
        self.userNetworkVC?.followUser(followUserId: selectedUser.id! ) {(result) -> () in
            if result {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // add the new user to list of following and reload the table ready for when we go back
                    self.userNetworkVC?.following.append(selectedUser)
                    self.userNetworkVC?.tableView.reloadData()
                    senderCell.followButton.isEnabled = false
                    senderCell.followButton.setTitle("Following", for: UIControlState.normal)
                }
            }
        }
        
    }
    
    
    //MARK - Helper functions
    
    func loadSuggested(userId: Int){
        let suggestedFollowEndpoint = URL(string: "http://localhost:3000/api/v1/following/suggested/"+String(userId))!
        let task = session.dataTask(with: suggestedFollowEndpoint) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                //completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                self.suggested = try decoder.decode(UserResponse.self, from:data).users
                self.tableView.reloadData()
                //self.myRefreshControl.endRefreshing()
            } catch let err {
                print ("Error:", err)
            }
            
        } ;
        task.resume()
        
    }
    
    
    
}


