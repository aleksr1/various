//
//  LoadingViewController.swift
//  QEM
//
//  Created by Justin Owens on 1/27/16.
//  Copyright © 2016 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoadingViewController: UIViewController {
    
    var clientcode: String = ""
    var username: String = ""
    var userpw: String = ""
    var encryptedPW: String?
    var decryptedPW: String?
    var userID: Int = 0
    var session : String = ""
    let header = [
        "X-Dreamfactory-Application-Name" : "QEMobile"
    ]
    let headers = [
        "X-Dreamfactory-API-Key" : "a398b6985413b95ee57f9f9141e194f47eb7a0b4bdb46bc45dbd4b90ed2333be"
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        encryptedPW = Utils.encryption(userpw, userID: userID)
        
        if let unwrappedPW = encryptedPW {
            
            login()
            decryptedPW = Utils.decryption(unwrappedPW, userID: userID)
            
            if let unwrappedDecrypted = decryptedPW {
                print("unwrappedDecrypted = \(unwrappedDecrypted)\n")
            }
        }
        
        
        

        
    }
    
    
    
    func login(){
        
        
        if let unwrappedPW = encryptedPW {
            let params = [ "params" : [ [ "name" : "ClientCode", "param_type" : "", "value" : "\(clientcode)", "type" : "", "length" : 0] , ["name" : "UserName", "param_type" : "", "value" : "\(username)", "type" : "", "length" : 0  ], [ "name" : "UserPW", "param_type" : "", "value" : "\(unwrappedPW)", "type" : "", "length" : 0] ] ]

            Alamofire.request(.POST, "http:/192.5.31.198:92/api/v2/QEM/_proc/usp_QEMSession_Create_2015_01", parameters: params, headers: headers, encoding: .JSON)
                .validate()
                .responseJSON { (request, response, result) in
                    print("login() result = \(result)")
                    
                    switch result{
                    case .Success(let data):
                        let json = JSON(data)
                        
                        if response?.statusCode == 200 {
                            print(json)
                            if let newSession : String = json[0]["Value"].stringValue{
                                print("newSession = \(newSession)")
                                self.session = newSession
                                print("session = \(self.session)")
                                
                            } else {
                                print("if let failed")
                            }
                            
                            
                            /*if let session : String = json["Value"].arrayObject {
                                print("session = \(session)")
                                if session == 0 {
                                    Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                                } else {
                                    self.performSegueWithIdentifier("segueloggedIn", sender: self)
                                }
                            } else {
                                Utils.showAlertOnVC(self, alertType: "FailedLoggin")
                            }*/
                        }
                    case .Failure(_, _):
                        Utils.showAlertOnVC(self, alertType: "Offline")
                    }
            }

        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
