//
//  BatchViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 8/25/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

/*import UIKit
import Foundation

/*class Kids {
    var name : String
    
    var status : String
    
    init(name: String, status: String) { self.name = name ; self.status = status }
    
    
}*/

class BatchViewControllerDEAD: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    
    var textCellIdentifier = "TextCell"
    //var testArray = ["George Bluth Sr", "Lucille Bluth", "Gob Bluth", "Michael Bluth", "Lindsey Funke", "Buster Bluth", "Tobias Funke", "George Michael Bluth", "Maeby Funke"]
    var testArray : [String] = []
    var signInArray : [String] = []
    var signOutArray : [String] = []
    var childStatus : [String] = []
    /*var theBluths = [Kids]()
    var resultSearchController = UISearchController()
    var filteredBluths = [Kids]()
    var searchActive : Bool = false
    var bluths2 : Kids!*/
    
    //Using Members 10/06/15
    /*var members: Array<Members>?
    var membersWrapper:MembersWrapper? // holds the last wrapper loaded
    var isLoadingMembers = false*/
    //End

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Using Members 10/06/15
        //self.loadFirstMembers()
        // place tableview below status bar, cuz I think it's prettier that way
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        //End
        
        
        
        /*self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar*/
        
        /*var kid1 = Kids(name: "George Bluth Sr", status: "");
        var kid2 = Kids(name: "Lucille Bluth", status: "")
        var kid3 = Kids(name: "Oscar Bluth", status: "")
        var kid4 = Kids(name: "Gob Bluth", status: "")
        var kid5 = Kids(name: "Lindsey Funke", status: "")
        var kid6 = Kids(name: "Michael Bluth", status: "")
        var kid7 = Kids(name: "Buster Bluth", status: "")
        var kid8 = Kids(name: "Tobias Funke", status: "")
        var kid9 = Kids(name: "George Michael Bluth", status: "")
        var kid10 = Kids(name: "Maeby Funke", status: "")
        var kid11 = Kids(name: "Annyong Bluth", status: "")
        var kid12 = Kids(name: "Steave Holt", status: "")
        var kid13 = Kids(name: "Ann Veal", status: "")*/
        /*self.theBluths += [Kids(name: "George Bluth Sr", status: "")]
        self.theBluths += [Kids(name: "Lucille Bluth", status: "")]
        self.theBluths += [Kids(name: "Oscar Bluth", status: "")]
        self.theBluths += [Kids(name: "Gob Bluth", status: "")]
        self.theBluths += [Kids(name: "Lindsey Funke", status: "")]
        self.theBluths += [Kids(name: "Michael Bluth", status: "")]
        self.theBluths += [Kids(name: "Buster Bluth", status: "")]
        self.theBluths += [Kids(name: "Tobias Funke", status: "")]
        self.theBluths += [Kids(name: "George Michael Bluth", status: "")]
        self.theBluths += [Kids(name: "Maeby Funke", status: "")]
        self.theBluths += [Kids(name: "Annyong Bluth", status: "")]
        self.theBluths += [Kids(name: "Steve Holt", status: "")]
        self.theBluths += [Kids(name: "Ann Veal", status: "")]
        
        self.filteredBluths += [Kids(name: "George Bluth Sr", status: "")]
        self.filteredBluths += [Kids(name: "Lucille Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Oscar Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Gob Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Lindsey Funke", status: "")]
        self.filteredBluths += [Kids(name: "Michael Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Buster Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Tobias Funke", status: "")]
        self.filteredBluths += [Kids(name: "George Michael Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Maeby Funke", status: "")]
        self.filteredBluths += [Kids(name: "Annyong Bluth", status: "")]
        self.filteredBluths += [Kids(name: "Steve Holt", status: "")]
        self.filteredBluths += [Kids(name: "Ann Veal", status: "")]*/

        
        /*theBluths.append(kid1)
        theBluths.append(kid2)
        theBluths.append(kid3)
        theBluths.append(kid4)
        theBluths.append(kid5)
        theBluths.append(kid6)
        theBluths.append(kid7)
        theBluths.append(kid8)
        theBluths.append(kid9)
        theBluths.append(kid10)
        theBluths.append(kid11)
        theBluths.append(kid12)
        theBluths.append(kids13)*/
        
        
                
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //Using Members 10/06/15
    /*func loadFirstMembers()
    {
        isLoadingMembers = true
        Members.getMembers({ (membersWrapper, error) in
            if error != nil
            {
                self.isLoadingMembers = false
                var alert = UIAlertController(title: "Error", message: "Could not load first member\(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.addMembersFromWrapper(membersWrapper)
            self.isLoadingMembers = false
            self.tableView?.reloadData()
     })
    }
    
    func loadMoreMembers()
    {
        self.isLoadingMembers = true
        if self.members != nil && self.membersWrapper != nil && self.members!.count < self.membersWrapper!.count
        {
            // there are more members out there!
            Members.getMoreMembers(self.membersWrapper, completionHandler: { (moreWrapper, error) in
                if error != nil
                {
                    // TODO: improved error handling
                    self.isLoadingMembers = false
                    var alert = UIAlertController(title: "Error", message: "Could not load more members \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                print("got more!")
                self.addMembersFromWrapper(moreWrapper)
                self.isLoadingMembers = false
                self.tableView?.reloadData()
            })
        }
    }
    
    func addMembersFromWrapper(wrapper: MembersWrapper?)
    {
        self.membersWrapper = wrapper
        if self.members == nil
        {
            self.members = self.membersWrapper?.members
        }
        else if self.membersWrapper != nil && self.membersWrapper!.members != nil
        {
            self.members = self.members! + self.membersWrapper!.members!
        }
    }*/
    //END
    
    /*func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filteredBluths.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.filteredBluths as NSArray).filteredArrayUsingPredicate(searchPredicate)
        self.filteredBluths = array as! [String]
        
        self.tableView.reloadData()
    }*/
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sortForwardAlphabetical(sender: UIButton) {
        theBluths.sortInPlace() { $0.name < $1.name }
        self.tableView.reloadData()
    }
    @IBAction func sortBackwardsAlphabetical(sender: UIButton) {
        theBluths.sortInPlace() { $0.name >  $1.name }
        self.tableView.reloadData()
    }
    
    @IBAction func btnAccept(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("UnwindBatchToHome", sender: self)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        //Using Members 10/06/15
        if (self.members == nil)
        {
            return 0
        }
       return self.members!.count
       //End
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : BatchTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! BatchTableViewCell
        let row = indexPath.row
                
        //var bluths2 : Kids
        //cell.lblName.text = testArray[row]
        //let bluths = theBluths[row]
        //cell.lblName.text = bluths.name
        //cell.lblStatus.text = bluths.status
        /*if (self.resultSearchController.active)
        {
            //cell.textLabel?.text = self.filteredBluths[row]
            cell.lblName.text = filteredBluths.
            cell.lblStatus.text = bluths2.status
            
            return cell
        }
        cell.lblName.text = bluths2.name
        cell.lblStatus.text = bluths2.status*/
        
        
        //Using Members 10/06/15
        /*if self.members != nil && self.members!.count >= row
        {
            let members = self.members![row]
            cell.lblName.text = members.name
            
            //see if we need to load more members
            let rowsToLoadFromBottom = 5;
            let rowsLoaded = self.members!.count
            if (!self.isLoadingMembers && (row >= (rowsLoaded - rowsToLoadFromBottom)))
            {
                let totalRows = self.membersWrapper!.count!
                let remainingMembersToLoad = totalRows - rowsLoaded;
                if (remainingMembersToLoad > 0)
                {
                    self.loadMoreMembers()
                }
            }
        }*/
        
        
        
        
        if cell.lblStatus.text == "Scan In" {
            cell.backgroundColor = UIColor.blueColor()
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblName.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblStatus.textColor = UIColor.whiteColor()
            cell.lblStatus.font = UIFont.boldSystemFontOfSize(18.0)
            //cell.lblStatus.textColor = UIColor.blueColor()
            //cell.lblName.textColor = UIColor.blueColor()
        } else if cell.lblStatus.text == "Scan Out" {
            cell.backgroundColor = UIColor.redColor()
            cell.lblName.textColor = UIColor.whiteColor()
            cell.lblName.font = UIFont.boldSystemFontOfSize(18.0)
            cell.lblStatus.textColor = UIColor.whiteColor()
            cell.lblStatus.font = UIFont.boldSystemFontOfSize(18.0)
            //cell.lblStatus.textColor = UIColor.redColor()
            //cell.lblName.textColor = UIColor.redColor()
        } else if cell.lblStatus.text == "" {
            cell.backgroundColor = UIColor.whiteColor()
            cell.lblStatus.textColor = UIColor.blackColor()
            cell.lblName.textColor = UIColor.blackColor()
            cell.lblName.font = UIFont.systemFontOfSize(17.0)
            cell.lblStatus.font = UIFont.systemFontOfSize(17.0)
        }
        
        
        //println(theBluths[row].name)
        
        return cell
    }
    
    
    /*override func tableView(tableView: (UITableView!), didSelectRowAtIndexPath indexPath: (NSIndexPath!)) {
    println("Row \(indexPath.row) selected")
    let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
    
    }*/
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let signIn = UITableViewRowAction(style: .Normal, title: "Scan In") { action, index in
            //let cell = tableView.dequeueReusableCellWithIdentifier(self.textCellIdentifier, forIndexPath: indexPath) as! BatchTableViewCell
            let myCell = tableView.cellForRowAtIndexPath(indexPath) as! BatchTableViewCell
            let row = indexPath.row
            let bluths = self.theBluths[row]
            bluths.status = "Scan In"
            
            self.tableView.reloadData()

            
            let myStr = myCell.lblName.text! + " : Scanned In"
            self.signInArray.append(myStr)
            
        }
        signIn.backgroundColor = UIColor.blueColor()
        
        let signOut = UITableViewRowAction(style: .Normal, title: "Scan Out") { action, index in
            
            let myCell = tableView.cellForRowAtIndexPath(indexPath) as! BatchTableViewCell
            let row = indexPath.row
            let bluths = self.theBluths[row]
            bluths.status = "Scan Out"
            
            self.tableView.reloadData()
            
            let myStr = myCell.lblName.text! + " : Scanned out"
            self.signInArray.append(myStr)
        }
        signOut.backgroundColor = UIColor.redColor()
        let cancel = UITableViewRowAction(style: .Normal, title: "Undo"){ action, index in
            let myCell = tableView.cellForRowAtIndexPath(indexPath) as! BatchTableViewCell
            //println(self.signInArray)
            let row = indexPath.row
            let bluths = self.theBluths[row]
            bluths.status = ""
            
            self.tableView.reloadData()
            
            let x = myCell.lblName.text! + " : Scanned In"
            let y = myCell.lblName.text! + " : Scanned out"
           
            self.signInArray.indexOf(x)
            var i = 0
            for name in self.signInArray{
                
                
                print("printing name : \(name)")
                print("printing i : \(i)")
                print("printing x : \(x)")
                
                if x ==  name ||  y == name {
                    print(" undo \(i)")
                    self.signInArray.removeAtIndex(i)
                    print("signInArray contains after removal: \(self.signInArray)")
                } else {
                    ++i
                }
            }
        }
        
        cancel.backgroundColor = UIColor.grayColor()
        
        
        return [signOut, signIn, cancel]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UnwindBatchToHome"
        {
            //if let sourceViewController = segue.sourceViewController as? ViewController{
            //sourceViewController.childIn += self.signInArray
            //sourceViewController.tableView.reloadData()
            //}
            print(self.signInArray)
            print(self.signOutArray)
        }
    }
}*/
