//
//  Utils.swift
//  QEM
//
//  Created by Justin Owens on 12/22/15.
//  Copyright © 2015 VisionCPS. All rights reserved.
//

import Foundation
import UIKit

class Utils
{
    static let sharedUtils = Utils()
    
    class func showAlertOnVC(targetVC: UIViewController, alertType: String){
        
        if alertType == "404" {
            buildAlert(targetVC, title: "Site Not Found", message: "Server is unavailable at this time")
        }
        
        if alertType == "Offline" {
            buildAlert(targetVC, title: "Offline", message: "Your devices appears to be offline")
        }
        
        if alertType == "NoMember" {
            buildAlert(targetVC, title: "No Member", message: "Unable to find member")
        }
        
        if alertType == "NoUnit" {
            buildAlert(targetVC, title: "No Unit", message: "Please select the Unit")
        }
        
        if alertType == "NoTime" {
            buildAlert(targetVC, title: "No Date or Time", message: "Please select the desired date and time")
        }
        
        if alertType == "NoActivity" {
            buildAlert(targetVC, title: "No Activity", message: "Please select the Activity")
        }
        
        if alertType == "NoStatus" {
            buildAlert(targetVC, title: "No Status", message: "Please select the In or Out")
        }
        
        if alertType == "NoResult" {
            buildAlert(targetVC, title: "No Member", message: "Please enter a Member ID number")
        }
        
        if alertType == "ExcessPrefix"{
            buildAlert(targetVC, title: "Error", message: "Prefix cannot exceed two characters")
        }
        
        if alertType == "FailedLoggin"{
            buildAlert(targetVC, title: "Login Failed", message: "Login information is incorrect")
        }


    }
    
    class func buildAlert(targetVC: UIViewController, var title: String,var message: String){
        title = NSLocalizedString(title, comment: "")
        message = NSLocalizedString(message, comment: "")
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(
            title:"OK",
            style: UIAlertActionStyle.Default,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        alert.addAction(okButton)
        targetVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func printTimestamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
    }
}