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
/*extension Array {
    subscript(path: NSIndexPath) -> T{
        return self[path.row]
    }
}

extension NSIndexPath {
    class func firstIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}*/

class ActivityTableViewController: UITableViewController {
    
    struct TableViewValues {
        static let identifier = "Cell"
    }
    /*
    lazy var items: [String] = {
        var returnValue = [String]()
        for counter in 1...100{
            returnValue.append("Activity \(counter)")
        }
        return returnValue
        }()*/
    var items: [String] = []
    
   
    var cancelBarButtonItem: UIBarButtonItem!
    var selectionHandler: ((selectedItem: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewValues.identifier)
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "performCancel")
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        
        performRefresh()
        print("viewDidLoad()", terminator: "")
        
        
    }
    
    func performCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performRefresh(){
        items = []
        print("refreshed items: \(items)", terminator: "")
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Activities")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        
        var JSONSerializationError: NSError? = nil
        
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
       
        
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    let record = json["record"].string
                    var indexValue = 0
                    
                    
                    
                    for (index, item) in json["record"] {
                        let indvItem = json["record"][indexValue]["Activityname"].stringValue
                        print(indvItem)
                        self.items.insert(indvItem, atIndex: indexValue)
                        indexValue++
                    }
                    self.tableView.reloadData()

                case .Failure(_, let error):
                    print("request failed with error: \(error)")
                }
                
                       }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = CGSize(width: 300, height: 300)
        if (self.items.count > 1)
        {
            print("if viewWillAppear and items contains : \(self.items)", terminator: "")
            performRefresh()
            print("if performRefresh() viewWillAppear and items contains : \(self.items)", terminator: "")

            self.tableView.reloadData()
        } else {
            print("else viewWillAppear and items contains : \(self.items)", terminator: "")
        }
        //performRefresh()
        //println("viewWillAppear()")
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.items = ["disappear"]
        self.tableView.reloadData()
        print("viewWillDisappear()", terminator: "")

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning()", terminator: "")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewValues.identifier, forIndexPath: indexPath) as? UITableViewCell
        
        
        
        cell?.textLabel?.text = items[indexPath]
        
        return cell!
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
