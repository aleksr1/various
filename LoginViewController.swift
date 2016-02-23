//
//  LoginViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/11/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var txtSiteCode: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var clientcode: String = ""
    var username : String = ""
    var userpw : String = ""
    var userID: Int?
    var session: String = ""
    var encryptedPW: String?
    let headers = [
        "X-Dreamfactory-API-Key" : "a398b6985413b95ee57f9f9141e194f47eb7a0b4bdb46bc45dbd4b90ed2333be"
    ]
    
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
        test()
        self.txtSiteCode.resignFirstResponder()
        self.txtUsername.resignFirstResponder()
        self.txtPassword.resignFirstResponder()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueLogin" {
            if let dv = segue.destinationViewController as? ViewController {
                print("self.session = \(self.session)")
                dv.session = self.session
                dv.clientCode = self.clientcode
                
            }
        }
    }

    func test() {
        
        clientcode = txtSiteCode.text!
        username = txtUsername.text!
        userpw = txtPassword.text!

        let params = [ "params" : [ [ "name" : "ClientCode", "param_type" : "", "value" : "\(clientcode)", "type" : "", "length" : 0] , ["name" : "UserName", "param_type" : "", "value" : "\(username)", "type" : "", "length" : 0  ] ] ]
        
        Alamofire.request(.POST, "http:/192.5.31.198:92/api/v2/QEM/_proc/usp_QEMUser_GetOne_2015_01", parameters: params, headers: headers, encoding: .JSON)
            .validate()
            .responseJSON { (request, response, result) in
                print("login() result = \(result)")
                
                switch result{
                case .Success(let data):
                    let json = JSON(data)
                    print(json)
                    if response?.statusCode == 200 {
                        if let userID : Int = json[0]["UserID"].intValue {
                            print("userID = \(userID)")
                            if userID == 0 {
                                Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                            } else {
                                self.encryptedPW = Utils.encryption(self.userpw, userID: userID)
                                
                                self.login()
                            }
                        } else {
                            Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                        }
                    }
                case .Failure(_, _):
                    if response?.statusCode == 500 {
                        Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                    } else {
                        Utils.showAlertOnVC(self, alertType: "Offline")
                    }
                }
        }
        
    }
    
    func login(){
        
        clientcode = txtSiteCode.text!
        username = txtUsername.text!
        userpw = txtPassword.text!

        if let unwrappedPW = encryptedPW {
            let params = [ "params" : [ [ "name" : "ClientCode", "param_type" : "", "value" : "\(clientcode)", "type" : "", "length" : 0] , ["name" : "UserName", "param_type" : "", "value" : "\(username)", "type" : "", "length" : 0  ], [ "name" : "UserPW", "param_type" : "", "value" : "\(unwrappedPW)", "type" : "", "length" : 0] ] ]
            
            Alamofire.request(.POST, "http:/192.5.31.198:92/api/v2/QEM/_proc/usp_QEMSession_Create_2015_01", parameters: params, headers: headers, encoding: .JSON)
                .validate()
                .responseJSON { (request, response, result) in
                    
                    switch result{
                    case .Success(let data):
                        let json = JSON(data)
                        if response?.statusCode == 200 {
                            if let newSession : String = json[0]["Value"].stringValue{
                                self.session = newSession
                                if newSession.characters.count == 0 {
                                    Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                                } else {
                                    self.performSegueWithIdentifier("segueLogin", sender: self)
                                }
                            }
                        }
                    case .Failure(_, _):
                        Utils.showAlertOnVC(self, alertType: "Offline")
                    }
            }
            
        }
    }
    
    @IBAction func unwindLogin(segue: UIStoryboardSegue) {
        txtSiteCode.text = ""
        txtUsername.text = ""
        txtPassword.text = ""
    }
}
