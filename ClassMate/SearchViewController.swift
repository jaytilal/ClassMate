//
//  SearchViewController.swift
//  ClassMate
//
//  Created by Oshin Mundada on 12/12/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var filteredGroups = [Groups]()
    @IBOutlet weak var tableView: UITableView!
    let databaseRef = Database.database().reference()
    var allGroupList = [Groups]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchFooter: SearchFooter!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups"
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.allGroupList = [Groups]()
        databaseRef.child("groups").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                
                for each in snapDict{
                    let grpname = each.value["name"] as! String
                    let desc = each.value["hashtags"]! as! String!
                    let groupDesc = Groups(name:grpname, hashtags: desc!)
                    self.allGroupList.append(groupDesc)
                    self.tableView.reloadData()
                }
                print(self.allGroupList)
                
            }
        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering() {
//            return filteredGroups.count
//        }
//
//        return allGroupList.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredGroups.count, of: allGroupList.count)
            return filteredGroups.count
        }
        searchFooter.setNotFiltering()
        return allGroupList.count
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        let grpCell = allGroupList[indexPath.row]
//        cell.textLabel!.text = grpCell.name
//        cell.detailTextLabel!.text = grpCell.hashtags
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let grpCell: Groups
        if isFiltering() {
            grpCell = filteredGroups[indexPath.row]
        } else {
            grpCell = allGroupList[indexPath.row]
        }
        cell.textLabel!.text = grpCell.name
        cell.detailTextLabel!.text = grpCell.hashtags
        return cell
    }

    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
       
        filteredGroups = allGroupList.filter({(groupres : Groups) -> Bool in
            return groupres.name.lowercased().contains(searchText.lowercased()) || groupres.hashtags.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
