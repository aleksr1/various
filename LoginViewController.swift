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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // FIX ISSUE WHERE HITTING NEXT WILL CONTINUE TO RAISE THE SCREEN FROM KEYBOARD
    //RESULTS IN BLACK BAND AT BOTTOM AFTER KEYBOARD DISMISSED
    //////////////////////////////////////////////////////////
    func keyboardWillShow(sender: NSNotification) {
        //print("keyboardWillShow Y axis before movement : \(self.view.frame.origin.y)", terminator: "")

        if (self.view.frame.origin.y == 0.0){
            self.view.frame.origin.y -= 150
        }
        
        //print("keyboardWillShow Y axis after movement : \(self.view.frame.origin.y)", terminator: "")
    }
    
    func keyboardWillHide(sender: NSNotification) {
        //print("keyboardWillHide Y axis before movement : \(self.view.frame.origin.y)", terminator: "")
        self.view.frame.origin.y += 150
        //print("keyboardWillHide Y axis after movement : \(self.view.frame.origin.y)", terminator: "")

    }
    
    //////////////////////////////////////////////////////////
    
    @IBAction func loginBtn(sender: UIButton) {
        sitecode = txtSiteCode.text!
        username = txtUsername.text!
        password = txtPassword.text!
        
       
        
        //var URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Logins?filter=sitecode%3D\(sitecode)AND%20username%3D'\(username)'%20AND%20password%3D'\(password)'")
        
        //let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        //mutableURLRequest.HTTPMethod = "GET"
        
        //var JSONSerializationError: NSError? = nil
        
        //mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        print("http://192.5.31.22:92/rest/Test/Logins?filter=sitecode%3D\(sitecode)AND%20username%3D'\(username)'%20AND%20password%3D'\(password)'")
        
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
                    
                    if var siteCode : Int = json["record"][0]["SiteCode"].intValue
                    {
                        print("SiteCode: \(siteCode)")
                        print(json)
                        if siteCode == 0 {
                            self.presentViewController(alertView, animated: true, completion: nil)

                        } else {
                             self.performSegueWithIdentifier("loggedInSegue", sender: self)
                        }
                       
                        
                    } else {
                        print("else called")
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                    }
                    
                case .Failure(_, let error):
                    print(error)
                    
                    self.presentViewController(alertView, animated: true, completion: nil)

                    
                }

                
                
                /*println(data)
                if (error != nil)
                {
                    
                    println(error)
                    
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                } else {
                    
                    let json = JSON(data!)
                    
                    if let siteCode = json["record"][0]["SiteCode"].stringValue.toInt()
                    {
                        println("SiteCode: \(siteCode)")
                        self.performSegueWithIdentifier("loggedInSegue", sender: self)
                        
                    } else {
                        
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                    }
                    
                   

                }*/
                
                
        }
        
    }
   

}
