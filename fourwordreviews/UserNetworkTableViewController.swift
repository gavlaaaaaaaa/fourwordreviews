//
//  UserNetworkTableViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 20/06/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class UserNetworkTableViewController: UITableViewController  {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    let cellReuseIdentifier = "userCell"
    
    var followers:[User] = []
    var following:[User] = []
    
    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFollowing(userId: UserSingleton.sharedInstance.user_id)
        loadFollowers(userId: UserSingleton.sharedInstance.user_id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnVal = 0
        
        switch(segmentControl.selectedSegmentIndex)
        {
        case 0:
            returnVal = following.count
            break
        case 1:
            returnVal = followers.count
            break
        default:
            break
        }
        
        return returnVal
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UserNetworkTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserNetworkTableViewCell.")
        }
        
        switch(segmentControl.selectedSegmentIndex)
        {
        case 0:
            cell.usernameLabel.text = following[indexPath.row].username
            cell.followButton.isEnabled = true
            cell.followButton.setTitle("Unfollow", for: UIControlState.normal)
        case 1:
            cell.usernameLabel.text = followers[indexPath.row].username
            if following.contains(followers[indexPath.row]){
                cell.followButton.setTitle("Follow Back", for: UIControlState.normal)
                cell.followButton.isEnabled = true
            }
            else {
                cell.followButton.setTitle("Following", for: UIControlState.normal)
                cell.followButton.isEnabled = false
            }
        default:
            break
        }
        
        return cell
        
    }
    
    //MARK - Actions
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    @IBAction func followButtonPressed(_ sender: AnyObject) {
        let senderCell = sender.superview??.superview as! UserNetworkTableViewCell
        switch(segmentControl.selectedSegmentIndex)
        {
        case 0:
            unfollowUser(userId: following[(self.tableView.indexPath(for: senderCell)?.row)!].id!) {(result) -> () in
                if result {
                    //TODO FIX THIS SO IT RUNS ON MAIN THREAD
                    //TODO UNFOLLOW API NOT WORKING
                    senderCell.followButton.setTitle("Follow", for: UIControlState.normal)
                    senderCell.followButton.isEnabled = true
                }
            }
            break
        case 1:
            //returnVal = followers.count
            break
        default:
            break
        }
        
    }
    
    
    //MARK - Helper functions
    
    func loadFollowers(userId: Int){
        let followersEndpoint = URL(string: "http://localhost:3000/api/v1/followers/"+String(userId))!
        let task = session.dataTask(with: followersEndpoint) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                //completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                self.followers = try decoder.decode(UserResponse.self, from:data).users
                self.tableView.reloadData()
                //self.myRefreshControl.endRefreshing()
            } catch let err {
                print ("Error:", err)
            }

        } ;
        task.resume()
        
    }
    
    func loadFollowing(userId: Int){
        let followingEndpoint = URL(string: "http://localhost:3000/api/v1/following/"+String(userId))!
        let task = session.dataTask(with: followingEndpoint) {(data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                //completion(nil)
                return
            }
            do{
                let decoder = JSONDecoder()
                self.following = try decoder.decode(UserResponse.self, from:data).users
                self.tableView.reloadData()
                //self.myRefreshControl.endRefreshing()
            } catch let err {
                print ("Error:", err)
            }
            
        } ;
        task.resume()
        
    }
    
    func unfollowUser(userId: Int, completion: @escaping (_ result: Bool)->()){
        let unfollowEndpoint = URL(string: "http://localhost:3000/api/v1/following/"+String(UserSingleton.sharedInstance.user_id)+"/unfollow/"+String(userId))!
        var request = URLRequest(url: unfollowEndpoint)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                completion(true)
            } else {
                completion(false)
            }
            
        })
        task.resume()
    }
    
    
    
}
