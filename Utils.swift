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
        
        if alertType == "Duplicate" {
            buildAlert(targetVC, title: "Duplicate Entry", message: "This member has already been entered")
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
    
    class func encryption(passed: String, userID: Int) -> String
    {
        var loopIt:Int?
        loopIt = 1
        
        var encryptedPassword = ""
        var s = passed.lowercaseString
        
        if s.characters.count < 20 {
            let padding = 20 - s.characters.count
            for _ in 1 ... padding {
                s.insert(" ", atIndex: s.endIndex)
            }
        }
        
        for codeUnit in s.utf8 {
            let placeHolder = Int(codeUnit) * 2 - loopIt! - userID%11
            ++loopIt!
            let u = UnicodeScalar(placeHolder)
            encryptedPassword.append(u)
            if encryptedPassword.characters.count == 20 {
                break
            }
        }
        
        return encryptedPassword
    }
    
    class func decryption(passed: String, userID: Int) -> String
    {
        var loopIt:Int?
        loopIt = 1
        var decryptedPassword = ""
        let s = passed
        
        for var i = 0; i < s.characters.count; ++i
        {
            let a = [Character](s.characters)
            if i < a.count {
                let b = a[i]
                let d = String(b).unicodeScalars
                let e = d[d.startIndex].value
                var placeHolder = Int(e) + userID%11 + loopIt!
                placeHolder = placeHolder / 2
                ++loopIt!
                let f = UnicodeScalar(placeHolder)
                decryptedPassword.append(f)
            }
        }
        
        return decryptedPassword
    }

}