//
//  SearchViewController.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 14/08/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController{
    
    
    //MARK: Properties
    var reviewResults = [BeerReview]()
    var peopleResults = [User]()
    var api = API()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet var searchController: UISearchController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.tableView.reloadData()
        definesPresentationContext = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        return cell
    }
    
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: Action
    @IBAction func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    
    
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        api.searchReviews(searchTerm: searchBarText) { (result, searchResults) in
            if result {
                DispatchQueue.main.async {
                    self.reviewResults = searchResults!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
}
