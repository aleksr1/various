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

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    @IBOutlet weak var lblInOut: UILabel!
    @IBOutlet weak var btnOut: UIButton!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var btnHistoryOne: UIButton!
    
   
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
    var time = ""
    var inOut = ""
    //var child:Child!
    var childIn : [String] = []
    var childIn2 : [String] = []
    let textCellIdentifier = "TextCell"
    let swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
    

    
    lazy var activityPopoverContentController: UINavigationController = {
        let controller = ActivityTableViewController(style: .Plain)
        controller.selectionHandler = self.activitySelectionHandler
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
        }()
    
    lazy var activityPopoverController: UIPopoverController = {
        // DO WORK TO PREVENT OPENING ACTIVITY DROP DOWN UNLESS UNIT AND TIME ARE SELECTED
        
        return UIPopoverController(contentViewController: self.activityPopoverContentController)
        }()
    
    
    lazy var unitPopoverContentController: UINavigationController = {
        let controller = UnitTableViewController(style: .Plain)
        controller.selectionHandler = self.unitSelectionHandler
        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
        }()
    
    lazy var unitPopoverController: UIPopoverController = {
        return UIPopoverController(contentViewController: self.unitPopoverContentController)
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        popDatePicker = PopDatePicker(forTextField: tfTimeDate)
        
        tfTimeDate.delegate = self
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @IBAction func activityButton(sender: UIBarButtonItem) {
        activityPopoverController.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
    }
   
    
    
    func unitSelectionHandler(selectedItem: String){
        self.selectedItem = selectedItem
        NSLog("selectedItem %@", self.selectedItem!)
        self.unitLabel.text = self.selectedItem!
        NSLog("unitLabel %@", self.unitLabel.text!)
        /* Do something with the selected item */
        
    }
    
    @IBAction func unitButton(sender: UIBarButtonItem) {
        unitPopoverController.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
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
            timeDateHolder = self.tfTimeDate.text!
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
    
   
    
    @IBAction func enterBtn(sender: AnyObject) {
       
        
        if(lblResult.text == "") {
            self.tableView.reloadData()
        } else {
        
            personID = lblResult.text!
            unitName = unitLabel.text!
            activityName = activityLabel.text!
            time = tfTimeDate.text!
            inOut = lblInOut.text!
            lblResult.text = ""
            let stringOne = String(format: "%@ -- %@ -- %@ --  %@", personID, unitName, activityName, time)
            print(stringOne)
            childIn.append(personID)
            self.tableView.reloadData()
        }
        
        //btnHistoryOne.setTitle(stringOne, forState: UIControlState.Normal)
      
        /*let record = [
            "record" :[
                "PersonID" : personID,
                "Unitname" : unitName,
                "Activityname" : activityName,
                "DateTime" : time,
                "InOut" : inOut
        ]]
        println(record)
        let URL = NSURL(string: "http://192.5.31.22:92/rest/Test/SignIn")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        var JSONSerializationError: NSError? = nil
        
        //Use for adding parameters
        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(record, options: nil, error: &JSONSerializationError)
        
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        Alamofire.request(mutableURLRequest)
        .responseJSON { (request, response, data, error) in
            //println(request)
            //println(response)
            println(data)
            }*/


    }
    
    
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        let alertView = UIAlertController(title: "Under Development", message: "This portion of the application is currently disabled", preferredStyle: .Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        
        
        if index == 0{
            self.performSegueWithIdentifier("mainToConfigSegue", sender: nil);
            
        } else if index == 1 {
                        presentViewController(alertView, animated: true, completion: nil)

        } else if index == 2 {
                        presentViewController(alertView, animated: true, completion: nil)

        }
    }
    
    @IBAction func btnNumber(sender: UIButton) {
         var num = sender.currentTitle
        
        
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
    
    
    /*@IBAction func unwindBatchToHome(segue:UIStoryboardSegue){
        if let svc = segue.sourceViewController as? TestBatchViewController{
        
                self.childIn += svc.signInArray + svc.signOutArray
                self.tableView.reloadData()
            
        }
        
    }*/
    
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
   
    @IBAction func test(sender: UITextField) {
        
        NSLog("textField %@", sender.description)
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(tfTimeDate.text!)
        let forTextField = tfTimeDate
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
            let forTextField = tfTimeDate
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
        return childIn.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        let row = indexPath.row
     
        childIn2 = Array(childIn.reverse())
    
        cell.lblOutput.text = childIn2[row]

      
        
        return cell
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(childIn[row])
    }*/
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
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
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "segueToBatch" {
            if self.lblInOut.text! == "In/Out"{
                let alert = UIAlertController(title: "Error", message: "Please choose In or Out", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }/* else if self.unitLabel.text == "Unit"{
                let alert = UIAlertController(title: "Error", message: "Please select a Unit", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return false
                
            } else if self.activityLabel.text == "Activity" {
                let alert = UIAlertController(title: "Error", message: "Please select an Activity", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }*/ else {
                return true
            }
            
            
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToBatch" {
            if self.lblInOut.text! == "In" {
                if let destinationVC = segue.destinationViewController as? BatchViewController{
                    destinationVC.attendMethod = self.lblInOut.text!
                }
            }
            if self.lblInOut.text! == "Out" {
                if let destinationVC = segue.destinationViewController as? BatchViewController{
                    destinationVC.attendMethod = self.lblInOut.text!
                }
            }
        }
    }
}

    
   




