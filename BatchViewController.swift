//
//  BatchViewController.swift
//  QEM
//
//  Created by Justin Owens on 10/20/15.
//  Copyright © 2015 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var unfilteredMembers = [Dictionary<String,String>]()
    var filteredMembers = [Dictionary<String,String>]()
    var punchMembers = [Dictionary<String,String>]()
    var searchController: UISearchController!
    var acceptBarButtonItem: UIBarButtonItem!
    var attendMethod = ""
    
     override func viewDidLoad() {
        super.viewDidLoad()
        acceptBarButtonItem = UIBarButtonItem(title: "Accept", style: .Plain, target: self, action: "performCancel")
        navigationItem.rightBarButtonItem = acceptBarButtonItem
        performRefresh()
        configureSearchController()
        print(attendMethod)
        
    }
    
    //10-21-15 SearchBar code updates
    func configureSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Seach by last name"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.filteredMembers.removeAll(keepCapacity: false)
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var filterPlaceHolder = [Dictionary <String,String>]()
        self.tableView.reloadData()
        if self.searchController.searchBar.text == "" {
        } else {
            
            if self.filteredMembers.count == 0 {
                
                let searchText = self.searchController.searchBar.text!
                filterPlaceHolder = self.unfilteredMembers.filter({
                    $0["LastName"] == searchText
                })
                self.filteredMembers = filterPlaceHolder
            } else {
                
                let searchBarVar = self.searchController.searchBar.text
                let filteredResVar = self.filteredMembers[0]["LastName"]
                if searchBarVar == filteredResVar {
                    
                } else {
                    
                    let searchText = self.searchController.searchBar.text!
                    filterPlaceHolder = self.unfilteredMembers.filter({
                        $0["LastName"] == searchText
                    })
                    
                    self.filteredMembers = filterPlaceHolder
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func performRefresh(){
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Members")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    let swiftyJSONVar = JSON(data)
                    if let resData = swiftyJSONVar["record"].arrayObject{
                        self.unfilteredMembers = resData as! [[String: String]]
                    }
                    self.tableView.reloadData()
                case .Failure(_, let error):
                    print("request failed with error: \(error)")
                    
                    //DO Error Alert
                 }
        }
    }
    
    func performCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active || self.filteredMembers.count > 0) {
            return filteredMembers.count
        } else {
            return self.unfilteredMembers.count
        }
     }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BatchTableViewCell
        let row = indexPath.row
        
        if (self.searchController.active ) {
            cell.lblStatus.text = ""
            let firstName = self.filteredMembers[row]["FirstName"]
            let lastName = self.filteredMembers[row]["LastName"]
            let fullName = lastName! + ", " + firstName!
            cell.lblMemberID.text = self.filteredMembers[row]["MemberID"]
            cell.lblName.text = fullName
            cell.lblGender.text = self.filteredMembers[row]["Sex"]
            cell.lblAge.text = self.filteredMembers[row]["Age"]
        } else if self.filteredMembers.count > 0{
            cell.lblStatus.text = ""
            for var i = 0; i < self.punchMembers.count; ++i {
                if self.punchMembers[i]["MemberID"] == self.filteredMembers[row]["MemberID"]{
                    cell.lblStatus.text = self.punchMembers[i]["Status"]
                }
            }
            let firstName = self.filteredMembers[row]["FirstName"]
            let lastName = self.filteredMembers[row]["LastName"]
            let fullName = lastName! + ", " + firstName!
            cell.lblMemberID.text = self.filteredMembers[row]["MemberID"]
            cell.lblName.text = fullName
            cell.lblGender.text = self.filteredMembers[row]["Sex"]
            cell.lblAge.text = self.filteredMembers[row]["Age"]
        } else {
            cell.lblStatus.text = ""
            for var i = 0; i < self.punchMembers.count; ++i {
                if self.punchMembers[i]["MemberID"] == self.unfilteredMembers[row]["MemberID"]{
                    cell.lblStatus.text = self.punchMembers[i]["Status"]
                }
            }
            let firstName = self.unfilteredMembers[row]["FirstName"]
            let lastName = self.unfilteredMembers[row]["LastName"]
            let fullName = lastName! + ", " + firstName!
            cell.lblMemberID.text = self.unfilteredMembers[row]["MemberID"]
            cell.lblName.text = fullName
            cell.lblGender.text = self.unfilteredMembers[row]["Sex"]
            cell.lblAge.text = self.unfilteredMembers[row]["Age"]
        }
        

        if cell.lblStatus.text == "In" {
            cell.backgroundColor = UIColor.blueColor()
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblStatus.textColor = UIColor.whiteColor()
            cell.lblMemberID.textColor = UIColor.whiteColor()
            cell.lblGender.textColor = UIColor.whiteColor()
            cell.lblAge.textColor = UIColor.whiteColor()
            cell.lblName.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblMemberID.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblStatus.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblGender.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblAge.font = UIFont.boldSystemFontOfSize(18.0)
        
        } else if cell.lblStatus.text == "Out" {
            cell.backgroundColor = UIColor.redColor()
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblStatus.textColor = UIColor.whiteColor()
            cell.lblMemberID.textColor = UIColor.whiteColor()
            cell.lblGender.textColor = UIColor.whiteColor()
            cell.lblAge.textColor = UIColor.whiteColor()
            cell.lblName.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblMemberID.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblStatus.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblGender.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblAge.font = UIFont.boldSystemFontOfSize(18.0)
        } else if cell.lblStatus.text == "" {
            cell.backgroundColor = UIColor.whiteColor()
            cell.lblStatus.textColor = UIColor.blackColor()
            cell.lblName.textColor = UIColor.blackColor()
            cell.lblMemberID.textColor = UIColor.blackColor()
            cell.lblGender.textColor = UIColor.blackColor()
            cell.lblAge.textColor = UIColor.blackColor()
            cell.lblName.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblMemberID.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblStatus.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblGender.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblAge.font = UIFont.boldSystemFontOfSize(18.0)
           
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let myCell = tableView.cellForRowAtIndexPath(indexPath) as! BatchTableViewCell
        let row = indexPath.row
        if self.attendMethod == "In" {
            if self.punchMembers.count == 0 {
                if self.filteredMembers.count > 0{
                    self.punchMembers = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.punchMembers = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    for disc in self.punchMembers {
                        if disc["MemberID"] == self.unfilteredMembers[row]["MemberID"]{
                            for var i = 0; i < self.punchMembers.count; ++i{
                                if self.punchMembers[i] == disc {
                                    self.punchMembers.removeAtIndex(i)
                                }
                            }
                        }
                    }
                self.punchMembers.append(self.unfilteredMembers[row])
                } else {
                    for disc in self.punchMembers {
                        if disc["MemberID"] == self.filteredMembers[row]["MemberID"]{
                            for var i = 0; i < self.punchMembers.count; ++i{
                                if self.punchMembers[i] == disc {
                                    self.punchMembers.removeAtIndex(i)
                                }
                            }
                        }
                    }
                    self.punchMembers.append(self.filteredMembers[row])
                }
            }
            for var i = 0; i < self.punchMembers.count; ++i {
                self.punchMembers[i]["Status"] = "In"
            }
        }
        
        if self.attendMethod == "Out"{
            if self.punchMembers.count == 0 {
                if self.filteredMembers.count > 0{
                    self.punchMembers = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.punchMembers = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    for disc in self.punchMembers {
                        if disc["MemberID"] == self.unfilteredMembers[row]["MemberID"]{
                            for var i = 0; i < self.punchMembers.count; ++i{
                                if self.punchMembers[i] == disc {
                                    print(self.punchMembers[i])
                                    print(disc)
                                    self.punchMembers.removeAtIndex(i)
                                }
                            }
                        }
                    }
                    self.punchMembers.append(self.unfilteredMembers[row])
                } else {
                    for disc in self.punchMembers {
                        if disc["MemberID"] == self.filteredMembers[row]["MemberID"]{
                            for var i = 0; i < self.punchMembers.count; ++i{
                                if self.punchMembers[i] == disc {
                                    self.punchMembers.removeAtIndex(i)
                                }
                            }
                        }
                    }
                    self.punchMembers.append(self.filteredMembers[row])
                }
            }
            for var i = 0; i < self.punchMembers.count; ++i {
                self.punchMembers[i]["Status"] = "Out"
            }
        }
        self.tableView.reloadData()
    }
    
   
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let row = indexPath.row
        let remove = UITableViewRowAction(style: .Normal, title: "Remove"){ action, index in
            for var i = 0; i < self.punchMembers.count; ++i{
                if self.filteredMembers.count == 0{
                    if self.punchMembers[i]["MemberID"] == self.unfilteredMembers[row]["MemberID"]{
                        self.punchMembers.removeAtIndex(i)
                    }
                } else {
                    if self.punchMembers[i]["MemberID"] == self.filteredMembers[row]["MemberID"]{
                        self.punchMembers.removeAtIndex(i)
                    }
                }
            }
            self.tableView.reloadData()
        }
        remove.backgroundColor = UIColor.grayColor()
        return [remove]
    }
    
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
