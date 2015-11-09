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
    var scanInPunch = [Dictionary <String,String>]()
    var scanOutPunch = [Dictionary<String,String>]()
    var searchController: UISearchController!
    var acceptBarButtonItem: UIBarButtonItem!
    var attendMethod = ""
    var duplicates    = NSMutableArray()
    var noDuplicates  = NSMutableArray()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        acceptBarButtonItem = UIBarButtonItem(title: "Accept", style: .Plain, target: self, action: "performCancel")
        navigationItem.rightBarButtonItem = acceptBarButtonItem
        performRefresh()
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 44.0
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
        print("------------------------------------------------------------------------------ NEW PRESS --------------------------------------------------")
        if self.attendMethod == "In" {
            if self.scanInPunch.count == 0 {
                if self.filteredMembers.count > 0{
                    self.scanInPunch = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.scanInPunch = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    
                    for var i = 0; i < self.scanInPunch.count; ++i {
                        if self.scanInPunch[i]["MemberID"] == self.unfilteredMembers[row]["MemberID"]{
                        print(" if self.scanInPunch[\(i)][MemberID] == self.unfilteredMembers[row][MemberID]")
                        self.scanInPunch.removeAtIndex(i)
                        }

                    }
                    for var i = 0; i < self.scanInPunch.count; ++i {
                        if self.scanInPunch[i]["MemberID"] != self.unfilteredMembers[row]["MemberID"]{
                            print("if self.scanInPunch[\(i)][MemberID] != self.unfilteredMembers[row][MemberID]")
                            self.scanInPunch.append(self.unfilteredMembers[row])
                        }
                    }
                    
                } else {
                    for var i = 0; i < self.scanInPunch.count; ++i {
                        if self.scanInPunch[i]["MemberID"] == self.filteredMembers[row]["MemberID"]{
                            print("if self.scanInPunch[i][MemberID] == self.filteredMembers[row][MemberID]")
                        }
                    }

                    self.scanInPunch.append(self.filteredMembers[row])
                }
            }
            
            self.punchMembers = self.scanInPunch
            
            
            
            /*for dics in self.punchMembers {
                print("----------------LOOP START")
                if noDuplicates.containsObject(dics){
                    
                    if !duplicates.containsObject(dics){
                        duplicates.addObject(dics)
                        for disc in duplicates {
                            
                            for var i = 0; i < self.punchMembers.count; ++i{
                                if self.punchMembers[i] == disc as! [String : String]{
                                    print("if self.punchMembers[\(i)] == disc as! [String : String]\n")
                                    print("self.punchMembers[\(i)] = \(self.punchMembers[i])")
                                    self.punchMembers.removeAtIndex(i)
                                    
                                    print("after removeAtIndex self.punchMembers[\(i)] = \(self.punchMembers[i])")
                                    print("disc = \(disc)")
                                }
                            }
                            for var i = 0; i < self.scanInPunch.count; ++i {
                                if self.scanInPunch[i] == disc as! [String: String] {
                                    self.scanInPunch.removeAtIndex(i)
                                    print("if self.scanInPunch[\(i)] == disc as! [String: String]")
                                    print("self.scanInPunch[\(i)] = \(self.scanInPunch[i])")
                                    print("disc = \(disc)")

                                }
                            }
                        }
                    }
                }
                else{
                    noDuplicates.addObject(dics)
                }
                
                print("duplicates = \(duplicates)\n")
                print("noDuplicates =\(noDuplicates)\n")
                
                
                
                //to find the duplicate items key
                for dics in duplicates{
                    print("dics = \(dics)\n")
                }
                print("-----------------------Loop end")
                
            }*/
        
            print("self.punchMembers = \(self.punchMembers)\n")
        
            
            for var i = 0; i < self.punchMembers.count; ++i {
               
                self.punchMembers[i]["Status"] = "In"
                print("self.punchMembers[\(i)] = \(self.punchMembers[i])")
            }
        
        }
        
        if self.attendMethod == "Out"{
            if self.scanOutPunch.count == 0 {
                if self.filteredMembers.count > 0{
                    self.scanOutPunch = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.scanOutPunch = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    self.scanOutPunch.append(self.unfilteredMembers[row])
                } else {
                    self.scanOutPunch.append(self.filteredMembers[row])
                }
            }
            self.punchMembers = self.scanOutPunch
            
            for dics in self.punchMembers {
                print("----------------LOOP START")
                if noDuplicates.containsObject(dics){
                    
                    if !duplicates.containsObject(dics){
                        duplicates.addObject(dics)
                        self.punchMembers.removeLast()
                        self.punchMembers.removeLast()
                        self.scanOutPunch.removeLast()
                        self.scanOutPunch.removeLast()
                    }
                }
                else{
                    noDuplicates.addObject(dics)
                }
                
                print("duplicates = \(duplicates)\n")
                print("noDuplicates =\(noDuplicates)\n")
                
                
                
                //to find the duplicate items key
                for dics in duplicates{
                    print("dics = \(dics)\n")
                }
                print("-----------------------Loop end")
                
            }

            
            for var i = 0; i < self.punchMembers.count; ++i {
                self.punchMembers[i]["Status"] = "Out"
                print("self.punchMembers[\(i)] = \(self.punchMembers[i])")

            }

        }
        
        self.tableView.reloadData()
    }
    
   
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let row = indexPath.row
        
        let myCell = tableView.cellForRowAtIndexPath(indexPath) as! BatchTableViewCell
        
        let signIn = UITableViewRowAction(style: .Normal, title: "Scan In"){ action, index in
            
            if self.scanInPunch.count == 0 {
                if self.filteredMembers.count > 0{
                    self.scanInPunch = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.scanInPunch = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    self.scanInPunch.append(self.unfilteredMembers[row])
                } else {
                    self.scanInPunch.append(self.filteredMembers[row])
                }
            }
            self.punchMembers = self.scanInPunch
            
            for var i = 0; i < self.punchMembers.count; ++i {
                self.punchMembers[i]["Status"] = "In"
            }
            for var i = 0; i < self.punchMembers.count; ++i{
                
            }
            self.tableView.reloadData()
        }
        signIn.backgroundColor = UIColor.blueColor()
        
        let signOut = UITableViewRowAction(style: .Normal, title: "Scan Out"){ action, index in
            
            if self.scanOutPunch.count == 0 {
                if self.filteredMembers.count > 0{
                    self.scanOutPunch = self.filteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                } else {
                    self.scanOutPunch = self.unfilteredMembers.filter({
                        $0["MemberID"] == myCell.lblMemberID.text
                    })
                }
            } else {
                if self.filteredMembers.count == 0 {
                    self.scanOutPunch.append(self.unfilteredMembers[row])
                } else {
                    self.scanOutPunch.append(self.filteredMembers[row])
                }
            }
            self.punchMembers = self.scanOutPunch
            
            for var i = 0; i < self.punchMembers.count; ++i {
                self.punchMembers[i]["Status"] = "Out"
            }
            for var i = 0; i < self.punchMembers.count; ++i{
                
            }
            self.tableView.reloadData()
        }
        signOut.backgroundColor = UIColor.redColor()
        
        let cancel = UITableViewRowAction(style: .Normal, title: "Cancel"){ action, index in
            myCell.lblStatus.text = ""
            self.tableView.reloadData()
        }
        cancel.backgroundColor = UIColor.grayColor()
        
        return [cancel, signOut, signIn]
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
