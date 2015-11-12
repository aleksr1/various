//
//  TestBatchViewController.swift
//  QEM
//
//  Created by Justin Owens on 10/13/15.
//  Copyright © 2015 VisionCPS. All rights reserved.
//














import UIKit
import Alamofire
import SwiftyJSON

class BatchTableViewControllerDEAD: UITableViewController {
    struct TableViewValues {
        static let identifier = "Cell"
    }

    var arrRes = [[String:String]]() //Array of dictionary
    var cancelBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()\n", terminator: "")
        tableView.registerClass(/*UITableViewCell.classForCoder()*/BatchTableViewCell.self, forCellReuseIdentifier: TableViewValues.identifier)
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "performCancel")
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        performRefresh()
        
    }
    
    func performRefresh(){
        print("performRefresh\n", terminator: "")
        //arrRes = [[String:String]]()
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Members")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        
        //var JSONSerializationError: NSError? = nil
        
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    print(data)
                    //let swiftyJSONVar = JSON(result.value!)
                    let swiftyJSONVar = JSON(data)
                    if let resData = swiftyJSONVar["record"].arrayObject{
                        self.arrRes = resData as! [[String: String]]
                        print("self.arrRes.count is \(self.arrRes.count)\n")
                        for var index = 0; index < self.arrRes.count; ++index{
                            //print("self.arrRes[\(index)] = \(self.arrRes[index])\n")
                        }
                    }
                    self.tableView.reloadData()

                case .Failure(_, let error):
                    print("request failed with error: \(error)")
                    
                    
                }
                
        }
    }
    
    func performCancel(){
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear()\n")
        preferredContentSize = CGSize(width: 300, height: 300)
        if (self.arrRes.count > 1)
        {
            print("if viewWillAppear and items contains : \(self.arrRes)\n", terminator: "")
            performRefresh()
            print("if performRefresh() viewWillAppear and items contains : \(self.arrRes)\n", terminator: "")
            
            self.tableView.reloadData()
        } else {
            print("else viewWillAppear and items contains : \(self.arrRes)\n", terminator: "")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return arrRes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(TableViewValues.identifier, forIndexPath: indexPath) as! BatchTableViewCell
        
        let cell : BatchTableViewCell = (self.tableView.dequeueReusableCellWithIdentifier(TableViewValues.identifier, forIndexPath:indexPath) as! BatchTableViewCell)
        let row = indexPath.row
        print(self.arrRes[row]["Name"])
        
        
        if let varMemID = self.arrRes[row]["MemberID"] as String?{
            print("varMemID \(varMemID)")
            print(cell.description)
            print(cell.lblMemberID.description)
            cell.lblMemberID.text = varMemID
            
        }
        /*cell.lblName.text = self.arrRes[row]["Name"]
        cell.lblMemberID.text = self.arrRes[row]["MemberID"]
        cell.lblAge.text = self.arrRes[row]["Age"]
        cell.lblGender.text = self.arrRes[row]["Sex"]*/
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
