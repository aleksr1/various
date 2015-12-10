//
//  UnitTableViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/11/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Array {
    subscript(path: NSIndexPath) -> Element{
        return self[path.row];
    }
}

extension NSIndexPath {
    class func firstIndexPath() -> NSIndexPath{
        return NSIndexPath(forRow: 0, inSection: 0)
    }
}

class UnitTableViewController: UITableViewController {

    struct TableViewValues {
        static let identifier = "Cell"
    }
    
    /*lazy var items: [String] = {
        var returnValue = [String]()
        for counter in 1...100{
            returnValue.append("Unit \(counter)")
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
    
    func performRefresh(){
        print("performRefresh", terminator: "")
        items = []
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Units")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        
        //var JSONSerializationError: NSError? = nil
        
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    let json = JSON(data)
                    //let record = json["record"].string
                    var indexValue = 0
                    //print(json)
                    
                    
                    for (_, _) in json["record"] {
                        let indvItem = json["record"][indexValue]["Unitname"].stringValue
                        //print(indvItem)
                        self.items.insert(indvItem, atIndex: indexValue)
                        indexValue++
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
        preferredContentSize = CGSize(width: 300, height: 300)
        if (self.items.count > 1)
        {
            //print("if viewWillAppear and items contains : \(self.items)", terminator: "")
            performRefresh()
            //print("if performRefresh() viewWillAppear and items contains : \(self.items)", terminator: "")
            
            self.tableView.reloadData()
        } else {
            //print("else viewWillAppear and items contains : \(self.items)", terminator: "")
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.items = ["disappear"]
        self.tableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewValues.identifier, forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = self.items[indexPath.row]
       
        //println("cellForRowAtIndexPath: \(self.items[indexPath.row])")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = items[indexPath]
        selectionHandler?(selectedItem: selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
        //self
        print("didSelect \(self.items[indexPath.row])")
    }

}
