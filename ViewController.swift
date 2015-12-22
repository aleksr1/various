//
//  ViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/11/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    
    
    
    @IBOutlet weak var lblInOut: UILabel!
    @IBOutlet weak var btnOut: UIButton!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var btnHistoryOne: UIButton!
    @IBOutlet var timeSwitch: UISwitch!
    
   
    @IBOutlet weak var tfTimeDate: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var btnPrefixD: UIButton!
    @IBOutlet weak var btnPrefixC: UIButton!
    @IBOutlet weak var btnPrefixB: UIButton!
    @IBOutlet weak var btnPrefixA: UIButton!
    @IBOutlet weak var lblResult: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var prefixOnePassed:String = ""
    var prefixTwoPassed = ""
    var prefixThreePassed = ""
    var prefixFourPassed = ""
    var selectedItem: String?
    var popDatePicker : PopDatePicker?
    var timeDateHolder = ""
    var personID = ""
    var unitName = ""
    var activityName = ""
    var dateTime = ""
    var status = ""
    var siteCode = ""
    //var child:Child!
    var childIn : [String] = []
    var childIn2 : [String] = []
    let textCellIdentifier = "TextCell"
    var punchMembers = [Dictionary<String,String>]()
    var punchBatchMembers = [Dictionary<String, String>]()
    var membersData = [Dictionary<String, String>]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        popDatePicker = PopDatePicker(forTextField: tfTimeDate)
        performRefresh()
        tfTimeDate.delegate = self
        printTimestamp()
    }
    
    func printTimestamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    func activitySelectionHandler(selectedItem: String){
        self.selectedItem = selectedItem
        NSLog("selectedItem %@", self.selectedItem!)
        self.activityLabel.text = self.selectedItem!
        NSLog("activity %@", self.activityLabel.text!)
        /* Do something with the selected item */
        
    }
    
    @IBAction func newActivityButton(sender: UIBarButtonItem) {
        let tableViewController = ActivityTableViewController()
        tableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        tableViewController.selectionHandler = self.activitySelectionHandler
        
        let popoverPresentationController = tableViewController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.permittedArrowDirections = .Any
        
        popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        
        if unitLabel.text == "Unit"{
            self.buildAlert("NoUnit")
        } else {
            presentViewController(tableViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func newUnitButton(sender: UIBarButtonItem) {
        let tableViewController = UnitTableViewController()
        tableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        tableViewController.selectionHandler = self.unitSelectionHandler
        
        
        let popoverPresentationController = tableViewController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.permittedArrowDirections = .Any
        
        popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        presentViewController(tableViewController, animated: true, completion: nil)
        
    }
   
    
    func unitSelectionHandler(selectedItem: String){
        self.selectedItem = selectedItem
        NSLog("selectedItem %@", self.selectedItem!)
        self.unitLabel.text = self.selectedItem!
        NSLog("unitLabel %@", self.unitLabel.text!)
        /* Do something with the selected item */
        
    }
    
    @IBAction func inOut(sender: UIButton) {
        if sender == self.btnIn {
            self.lblInOut.text = "In"
            
        }
        
        if sender == self.btnOut {
            self.lblInOut.text = "Out"
        }
        
       
    }
    
    @IBAction func currentTimeSwitch(sender: UISwitch) {
        if sender.on {
            
            print("if sender.on timeDateHolder contains : \(timeDateHolder)")
            self.tfTimeDate.text = ""
            self.tfTimeDate.enabled = false
            self.tfTimeDate.placeholder = "Using current date and time"
        } else {
            self.tfTimeDate.enabled = true
        
        if (timeDateHolder != ""){
            self.tfTimeDate.text = timeDateHolder
        } else {
            
            self.tfTimeDate.placeholder = "Tap to select date and time"
        }
        }
        
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
                    //print(data)
                    let swiftyJSONVar = JSON(data)
                    
                    if response?.statusCode == 200 {
                        if let resData = swiftyJSONVar["record"].arrayObject{
                            self.membersData = resData as! [[String: String]]
                        }
                    } else {
                        self.buildAlert("404")
                    }
                    
                
                case .Failure(_, _):
                    self.buildAlert("Offline")
                }
        }
        
        
    }
    
    func buildAlert(alertype:String){
        if alertype == "404" {
            let alert = UIAlertController(title: "Site Not Found", message: "Server is unavailable at this time", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if alertype == "Offline" {
            let alertView = UIAlertController(title: "Offline", message: "Your devices appears to be offline", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if alertype == "NoMember" {
            let alertView = UIAlertController(title: "No Member", message: "Unable to find member", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }

        if alertype == "NoUnit" {
            let alertView = UIAlertController(title: "No Unit", message: "Please select the Unit", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)

        }
        
        if alertype == "NoTime" {
            let alertView = UIAlertController(title: "No Date or Time", message: "Please select the desired date and time", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)

        }
        
        if alertype == "NoActivity" {
            let alertView = UIAlertController(title: "No Activity", message: "Please select the Activity", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if alertype == "NoStatus" {
            let alertView = UIAlertController(title: "No Status", message: "Please select the In or Out", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if alertype == "NoResult" {
            let alertView = UIAlertController(title: "No Member", message: "Please enter a Member ID number", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }

        
    }

    func enterFunc () {
        var placeholder = 0
        print("Enter Button Pressed")
        if(lblResult.text == "") {
            self.tableView.reloadData()
            print("if lblResult.text == ''")
        } else {
            print("else lblResult.text == ''")
            siteCode = "2000"
            personID = lblResult.text!
            unitName = unitLabel.text!
            activityName = activityLabel.text!
            dateTime = tfTimeDate.text!
            status = lblInOut.text!
            lblResult.text = ""
            let stringOne = String(format: "%@ -- %@ -- %@ --  %@", personID, unitName, activityName, dateTime, status)
            print(stringOne)
            //childIn.append(personID)
            
        }
        let first = ["SiteCode": siteCode]
        print("for statement called")
        for var i = 0; i < self.membersData.count; ++i{
            if personID == self.membersData[i]["MemberID"]{
                print("for if personID == self.membersData[i][MemberID]")
                sendPunch(siteCode, memberID: personID, unitName: unitName, activityName: activityName, dateTime: dateTime, status: status)
                
                if self.punchMembers.count > 0 {
                    print("if self.punchMembers.count > 0")
                    self.punchMembers.append(first)
                    let tempElement = self.punchMembers.count  - 1
                    self.punchMembers[tempElement]["MemberID"] = personID
                    self.punchMembers[tempElement]["UniteName"] = unitName
                    self.punchMembers[tempElement]["ActivityName"] = activityName
                    self.punchMembers[tempElement]["DateTime"] = dateTime
                    self.punchMembers[tempElement]["Status"] = status
                    for var i = 0; i < self.membersData.count; ++i{
                        if self.punchMembers[tempElement]["MemberID"] == self.membersData[i]["MemberID"]{
                            self.punchMembers[tempElement]["FirstName"] = self.membersData[i]["FirstName"]
                            self.punchMembers[tempElement]["LastName"] = self.membersData[i]["LastName"]
                        }
                    }
                    
                } else {
                    print("else self.punchMembers.count > 0")
                    print(self.punchMembers)
                    self.punchMembers.append(first)
                    self.punchMembers[0]["MemberID"] = personID
                    self.punchMembers[0]["UniteName"] = unitName
                    self.punchMembers[0]["ActivityName"] = activityName
                    self.punchMembers[0]["DateTime"] = dateTime
                    self.punchMembers[0]["Status"] = status
                    for var i = 0; i < self.membersData.count; ++i{
                        if self.punchMembers[0]["MemberID"] == self.membersData[i]["MemberID"]{
                            self.punchMembers[0]["FirstName"] = self.membersData[i]["FirstName"]
                            self.punchMembers[0]["LastName"] = self.membersData[i]["LastName"]
                        }
                    }
                    
                }
            }
        }
        self.tableView.reloadData()
        
        for var i = 0; i < self.punchMembers.count; ++i{
            if personID == self.punchMembers[i]["MemberID"]{
                placeholder = 1
            }
        }
        
        if placeholder == 0 {
            self.buildAlert("NoMember")
        }

    }
    
    @IBAction func enterBtn(sender: AnyObject) {
        if self.unitLabel.text != "" {
            if self.activityLabel.text != "" {
                if self.lblInOut.text != "" {
                    if self.timeSwitch.on == false{
                        if self.tfTimeDate.text != "" {
                            if self.lblInOut.text != "" {
                                if self.lblResult.text != "" {
                                    self.enterFunc()
                                } else {
                                    self.buildAlert("NoResult")
                                }
                            } else {
                                self.buildAlert("NoStatus")
                            }
                        } else {
                            self.buildAlert("NoTime")
                        }
                    } else if self.timeSwitch.on == true{
                        if self.lblInOut.text != ""{
                            if self.lblResult.text != "" {
                                self.enterFunc()
                            } else {
                                self.buildAlert("NoResult")
                            }
                        } else {
                            self.buildAlert("NoStatus")
                        }
                    }
                } else {
                    self.buildAlert("NoStatus")
                }
            } else {
                self.buildAlert("NoActivity")
            }
        } else {
            self.buildAlert("NoUnit")
        }
        
        
    }
    
    func sendPunch(siteCode: String, memberID: String, unitName:String, activityName:String, dateTime:String, status:String ){
        let record = [ "record" : [ "SiteCode" : siteCode, "MemberID" : memberID, "UnitName" : unitName, "ActivityName" : activityName, "DateTime" : dateTime, "Status" : status ] ]
        
        print(record)
        let header = [
            "X-Dreamfactory-Application-Name" : "QEMobile"
        ]

        Alamofire.request(.POST, "http://192.5.31.22:92/rest/Test/Punch", parameters: record, headers: header)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success( _):
                    if response?.statusCode == 200 {
                        print(response)
                    } else {
                        self.buildAlert("404")
                    }
                case .Failure(_,_):
                    self.buildAlert("Offline")
                }
        }
    }
    
    
    @IBAction func btnNumber(sender: UIButton) {
        let num = sender.currentTitle
        lblResult.text = lblResult.text! + num!
    }
    
    @IBAction func btnClear(sender: UIButton) {
        lblResult.text = ""
       
    }
    
    @IBAction func btnBack(sender: UIButton) {
        if(lblResult.text == "") {
        
        } else {
            var currentEntry: String = lblResult.text!
            currentEntry = String(currentEntry.characters.dropLast())
            lblResult.text = "\(currentEntry)"
        }
    }
    
    
    @IBAction func unwindBatchToHome(segue: UIStoryboardSegue){
        if let controller = segue.sourceViewController as? BatchViewController{
            self.punchMembers += controller.punchMembers
            print("unwindBatchToHome self.punchMembers:\(self.punchMembers)")
        }
    }
    
    
    
    @IBAction func unwindConfigAccept(segue: UIStoryboardSegue){
        if let controller = segue.sourceViewController as? ConfigViewController {
        //let ViewController = segue.destinationViewController
            
            print("unwindeConfigAccept called")
            let prefixA = controller.txtPrefixOne.text
            prefixOnePassed = prefixA!
            
            let prefixB = controller.txtPrefixTwo.text
            prefixTwoPassed = prefixB!
            
            let prefixC = controller.txtPrefixThree.text
            prefixThreePassed = prefixC!
            
            let prefixD = controller.txtPrefixFour.text
            prefixFourPassed = prefixD!
            
            
            if prefixOnePassed.isEmpty || controller.didCancel == "yes" {
                //btnPrefixA.setTitle("A", forState: UIControlState.Normal)
            } else {
                btnPrefixA.setTitle(prefixOnePassed, forState: UIControlState.Normal)
            }
            
            if prefixTwoPassed.isEmpty || controller.didCancel == "yes" {
                //btnPrefixB.setTitle("B", forState: UIControlState.Normal)
            } else {
                btnPrefixB.setTitle(prefixTwoPassed, forState: UIControlState.Normal)
                
            }
            
            if prefixThreePassed.isEmpty || controller.didCancel == "yes" {
                //btnPrefixC.setTitle("C", forState: UIControlState.Normal)
            } else {
                btnPrefixC.setTitle(prefixThreePassed, forState: UIControlState.Normal)
            }
            
            if prefixFourPassed.isEmpty || controller.didCancel == "yes" {
                //btnPrefixD.setTitle("D", forState: UIControlState.Normal)
            } else {
                btnPrefixD.setTitle(prefixFourPassed, forState: UIControlState.Normal)
            }
        }
       
        
    }
   
    func test(sender: UITextField) {
        
        NSLog("textField %@", sender.description)
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(tfTimeDate.text!)
        //let forTextField = tfTimeDate
        popDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField: UITextField) -> () in
            //NSLog("forTextField %@", forTextField)
            self.tfTimeDate.text = newDate.ToDateMediumString()
            //NSLog("todatemediumstring called")
            
        })

        
      

    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        tfTimeDate.text = dateFormatter.stringFromDate(sender.date)
        print("handleDatePicker called")
    }
    
  
    
    func resign() {
        
        tfTimeDate.resignFirstResponder()
        
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField == tfTimeDate) {
            NSLog("textField %@", textField.description)
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate = formatter.dateFromString(tfTimeDate.text!)
            //let forTextField = tfTimeDate
            popDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField: UITextField) -> () in
            NSLog("forTextField %@", forTextField)
            self.tfTimeDate.text = newDate.ToDateMediumString()
            NSLog("todatemediumstring called")
                
            })
            return false
            } else {
            return true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.punchMembers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        let row = indexPath.row
     
        
        
        var placeholder = Array(self.punchMembers.reverse())
        let spaceColon = " : "
        let space = " "
        if var punchHistory = placeholder[row]["MemberID"]{
            punchHistory += spaceColon
            punchHistory += placeholder[row]["FirstName"]!
            punchHistory += space
            punchHistory += placeholder[row]["LastName"]!
            punchHistory += spaceColon
            punchHistory += placeholder[row]["Status"]!
            print("\n\npunchhistory\n\n \(punchHistory)")
            cell.lblOutput.text = punchHistory
        } else {
            print("\n\n\n\npunch history not created")
        }
        
        
    
        

      
        
        return cell
    }
    

    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Undo") { action, index in
            let cell = tableView.cellForRowAtIndexPath(indexPath) as!  HistoryTableViewCell
            
            print("undo called")
            print("cell.textLabel.text == \(cell.lblOutput.text!)")
            let row = indexPath.row
            var i = 0
            var y = 0
            if cell.lblOutput.text! == "" {
                print("cell.lblOutput.text ==  '' ")
            } else {
                let x = cell.lblOutput.text!
                for name in self.childIn {
                    print("name in self.childIn \(name)")
                    print("x is \(x)")
                   
                    if x == name {
                        self.childIn.removeAtIndex(i)
                        print("\(x) == \(name) at \(i)")
                        for duck in self.childIn2{
                            print("duck in self.childIn2 \(duck)")
                            print("x is \(x)")
                            if x == duck{
                                self.childIn2.removeAtIndex(y)
                                print("\(x) == \(duck) at \(y)")
                            } else {
                                y++
                            }
                        }
                        
                    } else {
                        i++
                    }
                    
                }

            }
            
            
            
            self.tableView.reloadData()
        }
        delete.backgroundColor = UIColor.lightGrayColor()
        
        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [/*share, favorite, */delete]
    }*/
    
   
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "segueToBatch" {
            if self.lblInOut.text! == ""{
                self.buildAlert("NoStatus")
                
                return false
            } else if self.unitLabel.text == ""{
                self.buildAlert("NoUnit")
                return false
                
            } else if self.activityLabel.text == "" {
                self.buildAlert("NoActivity")
                
                return false
            } else  if self.timeSwitch.on == false{
                if self.tfTimeDate.text == "" {
                    self.buildAlert("NoTime")
                } else {
                    return true
                }
            } else if self.timeSwitch.on == true{
                return true
            }
            
            
        }
        return true
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToBatch" {
            if let destinationVC = segue.destinationViewController as? BatchViewController{
                destinationVC.attendMethod = self.lblInOut.text!
                destinationVC.unitName = self.unitLabel.text!
                destinationVC.activityName = self.activityLabel.text!
                if timeSwitch.on {
                    destinationVC.useCurrentTime = true
                } else {
                    destinationVC.dateTime = self.tfTimeDate.text!
                    destinationVC.useCurrentTime = false
                }
                
            }
         
        }
    }
}

    
   




