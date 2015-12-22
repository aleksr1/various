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
    
    func performRefresh(){
        items = []
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Units")!
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
                            let indvItem = json["record"][indexValue]["Unitname"].stringValue
                            self.items.insert(indvItem, atIndex: indexValue)
                            indexValue++
                        }
                        self.tableView.reloadData()
                    } else {
                        Utils.showAlertOnVC(self, alertType: "404")
                    }
                    
                  
                case .Failure(_, _):
                    Utils.showAlertOnVC(self, alertType: "Offline")
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
            performRefresh()
            self.tableView.reloadData()
        } else {
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.items = ["disappear"]
        self.tableView.reloadData()
        
        
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
    }

}
