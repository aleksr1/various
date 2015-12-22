//
//  ActivityTableViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/16/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ActivityTableViewController: UITableViewController {
    
    struct TableViewValues {
        static let identifier = "Cell"
    }
    var items: [String] = []
    var cancelBarButtonItem: UIBarButtonItem!
    var selectionHandler: ((selectedItem: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewValues.identifier)
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "performCancel")
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        performRefresh()
    }
    
    func performCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performRefresh(){
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Activities")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    var indexValue = 0
                    if response?.statusCode == 200 {
                        for (_, _) in json["record"] {
                            let indvItem = json["record"][indexValue]["Activityname"].stringValue
                            //print(indvItem)
                            self.items.insert(indvItem, atIndex: indexValue)
                            indexValue++
                        }
                        self.tableView.reloadData()
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
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = CGSize(width: 300, height: 300)
        if (self.items.count > 1)
        {
            performRefresh()
            self.tableView.reloadData()
        } else {
        }
            }
    
    override func viewWillDisappear(animated: Bool) {
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewValues.identifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = items[indexPath]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = items[indexPath]
        selectionHandler?(selectedItem: selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
