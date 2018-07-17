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
    var follows:[User] = []
    
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
    
    
    
    override func willMove(toParentViewController viewController: UIViewController?) {
        super.willMove(toParentViewController: viewController)
        (viewController as? UserNetworkTableViewController)?.following.append(contentsOf: follows)
        (viewController as? UserNetworkTableViewController)?.tableView.reloadData()
    }

    
    
    //MARK - Actions
    
    
    @IBAction func followButtonPressed(_ sender: AnyObject) {
        let senderCell = sender.superview??.superview as! UserNetworkTableViewCell

        followUser(followUserId: suggested[(self.tableView.indexPath(for: senderCell)?.row)!].id! ) {(result) -> () in
            if result {
                DispatchQueue.main.async {
                    self.follows.append(self.suggested[(self.tableView.indexPath(for: senderCell)?.row)!])
                    self.tableView.reloadData()
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
    
    func unfollowUser(unfollowUserId: Int, completion: @escaping (_ result: Bool)->()){
        let unfollowEndpoint = URL(string: "http://localhost:3000/api/v1/following/")!
        var request = URLRequest(url: unfollowEndpoint)
        
        let postBody = ["user_id": UserSingleton.sharedInstance.user_id, "follows_user_id": unfollowUserId ] as [String : Any]
        
        
        request.httpMethod = "DELETE"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
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
    
    func followUser(followUserId: Int, completion: @escaping (_ result: Bool)->()){
        let followEndpoint = URL(string: "http://localhost:3000/api/v1/following/")!
        var request = URLRequest(url: followEndpoint)
        
        let postBody = ["user_id": UserSingleton.sharedInstance.user_id, "follows_user_id": followUserId ] as [String : Any]
        
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody, options: [])
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


