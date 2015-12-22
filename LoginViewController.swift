//
//  LoginViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/11/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var txtSiteCode: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var sitecode: String = ""
    var username : String = ""
    var password : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        }

    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
    txtPassword.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        txtSiteCode.resignFirstResponder()
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
    }
    
    @IBAction func textFieldShouldReturn(sender: UITextField){
        if (sender == txtSiteCode) {
            txtUsername.becomeFirstResponder()
        } else if ( sender == txtUsername){
            txtPassword.becomeFirstResponder()
        }
    
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if (self.view.frame.origin.y == 0.0){
            self.view.frame.origin.y -= 150
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
       }
    
    @IBAction func loginBtn(sender: UIButton) {
        /*sitecode = txtSiteCode.text!
        username = txtUsername.text!
        password = txtPassword.text!
        
        let header = [
            "X-Dreamfactory-Application-Name" : "QEMobile"
        ]
        
        Alamofire.request(.GET, "http://192.5.31.22:92/rest/Test/Logins?filter=sitecode%3D\(sitecode)AND%20username%3D'\(username)'%20AND%20password%3D'\(password)'", headers: header)                                                                                         //(mutableURLRequest)
            .responseJSON { (request, response, result) in
                let alertView = UIAlertController(title: "Error", message: "Login failed", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                
                switch result{
                case .Success(let data):
                    let json = JSON(data)
                    if let siteCode : Int = json["record"][0]["SiteCode"].intValue {
                        if siteCode == 0 {
                            self.presentViewController(alertView, animated: true, completion: nil)
                        } else {
                            self.performSegueWithIdentifier("loggedInSegue", sender: self)
                        }
                    } else {
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                    }case .Failure(_, _):
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
        }*/
        login()
    }
    
    func login(){
        let alertView = UIAlertController(title: "Error", message: "Login failed", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))

        sitecode = txtSiteCode.text!
        username = txtUsername.text!
        password = txtPassword.text!
        
        let header = [
            "X-Dreamfactory-Application-Name" : "QEMobile"
        ]
        
        Alamofire.request(.GET, "http://192.5.31.22:92/rest/Test/Logins?filter=sitecode%3D\(sitecode)AND%20username%3D'\(username)'%20AND%20password%3D'\(password)'", headers: header)
            .validate()
            .responseJSON { (request, response, result) in
                print(response)
        
                switch result{
                case .Success(let data):
                    let json = JSON(data)
                    if response?.statusCode == 200 {
                        if let siteCode : Int = json["record"][0]["SiteCode"].intValue {
                            if siteCode == 0 {
                                self.buildAlert("FailedLoggin")
                            } else {
                                self.performSegueWithIdentifier("loggedInSegue", sender: self)
                            }
                        } else {
                            self.buildAlert("FailedLoggin")

                    }
                    
                    }case .Failure(_, _):
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
        
        if alertype == "FailedLoggin"{
            let alertView = UIAlertController(title: "Error", message: "Login failed", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if alertype == "Offline" {
            let alertView = UIAlertController(title: "Offline", message: "Your devices appears to be offline", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
       
    }
}
