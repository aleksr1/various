//
//  Members.swift
//  QEM
//
//  Created by Justin Owens on 10/22/15.
//  Copyright © 2015 VisionCPS. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class Members {
    let Age : String
    let FirstName : String
    let LastName : String
    let MemberID : String
    let PersonSC : String
    let Sex : String
    let SiteCode : String
    let UnitCode : String
    
    init(Age: String, FirstName: String, LastName: String, MemberID: String, PersonSC: String, Sex: String, SiteCode: String, UnitCode: String){
        self.Age = Age
        self.FirstName = FirstName
        self.LastName = LastName
        self.MemberID = MemberID
        self.PersonSC = PersonSC
        self.Sex = Sex
        self.SiteCode = SiteCode
        self.UnitCode = UnitCode
    }
    
    func performRefresh(){
        let URL = NSURL(string:"http://192.5.31.22:92/rest/Test/Members")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("QEMobile", forHTTPHeaderField: "X-Dreamfactory-Application-Name")
        
        Alamofire.request(mutableURLRequest)
            .responseJSON { (request, response, result) in
                switch result {
                case .Success(let data):
                    let swiftyJSONVar = JSON(data)
                    if let resData = swiftyJSONVar["record"].arrayObject{
                        //Members = resData as! [[String: String]]
                    }
                
                case .Failure(_, let error):
                    print("request failed with error: \(error)")
                    
                    //DO Error Alert
                }
        }
    }

}
