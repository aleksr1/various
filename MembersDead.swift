//
//  Child.swift
//  QEMobile
//
//  Created by Justin Owens on 8/18/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//


/*import Alamofire
import SwiftyJSON
import Foundation

enum MembersFields: String {
    case MemberID = "member_id"
    case SiteCode = "site_code"
    case PersonSC = "person_sc"
    case UnitCode = "unit_code"
    case Name = "name"
}

class MembersWrapper {
    var members: Array<Members>?
    var count: Int?
    private var next: String?
    private var previous: String?
}

class Members {
    var memberID: String
    var siteCode: String
    var personSC: String
    var unitCode: String
    var name: String
    
        //(memberID: String, siteCode: String, personSC: String, unitCode: String, name: String)
    required init(json: JSON, id: String?){
        print(json)
        self.memberID = id!
        self.siteCode = json[MembersFields.SiteCode.rawValue].stringValue
        self.personSC = json[MembersFields.PersonSC.rawValue].stringValue
        self.unitCode = json[MembersFields.UnitCode.rawValue].stringValue
        self.name = json[MembersFields.Name.rawValue].stringValue
        //super.init()
        
    }
    
    
    class func endpointForMembers() -> String {
        return "http://192.5.31.22:92/rest/Test/Members"
    }
    
    private class func getMembersAtPath(path: String, completionHandler: (MembersWrapper?, NSError?) -> Void) {
        let header = [
            "X-Dreamfactory-Application-Name" : "QEMobile"
        ]
        
        Alamofire.request(.GET, path, headers: header)
            .responseMembersArray { (request, response, membersWrapper, error) in
                if let anError = error
                {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(membersWrapper, nil)
        }
    }
    
    class func getMembers(completionHandler: (MembersWrapper?, NSError?) -> Void) {
        getMembersAtPath(Members.endpointForMembers(), completionHandler: completionHandler)
    }
    
    class func getMoreMembers(wrapper: MembersWrapper?, completionHandler: (MembersWrapper?, NSError?) -> Void) {
        if wrapper == nil || wrapper?.next == nil
        {
            completionHandler(nil, nil)
            return
        }
        getMembersAtPath(wrapper!.next!, completionHandler: completionHandler)
    }
}

extension Alamofire.Request {
    // single species
    class func membersResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            var jsonError: NSError?
            let jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
            let json = JSON(jsonData!)
            if json.error != nil
            {
                print(json.error)
                return (nil, json.error)
            }
            if json == nil
            {
                return (nil, nil)
            }
            let members = Members(json: json, id: nil)
            return (members, nil)
        }
    }
    
    func responseMembers(completionHandler: (NSURLRequest, NSHTTPURLResponse?, Members?, NSError?) -> Void) -> Self {
        return response(serializer: Request.membersResponseSerializer(), completionHandler: { (request, response, members, error) in
            completionHandler(request, response, members as? Members, error)
        })
    }
    
    // all species
    class func membersArrayResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            var jsonError: NSError?
            let jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
            if jsonData == nil || jsonError != nil
            {
                return (nil, jsonError)
            }
            let json = JSON(jsonData!)
            if json.error != nil || json == nil
            {
                return (nil, json.error)
            }
            
            var wrapper:MembersWrapper = MembersWrapper()
            wrapper.next = json["next"].stringValue
            wrapper.previous = json["previous"].stringValue
            wrapper.count = json["count"].intValue
            
            var allMembers:Array = Array<Members>()
            let results = json["results"]
            for (index, jsonMembers) in results
            {
                let members = Members(json: jsonMembers, id: index.toInt())
                allMembers.append(members)
            }
            wrapper.members = allMembers
            return (wrapper, nil)
        }
    }
    
    func responseMembersArray(completionHandler: (NSURLRequest, NSHTTPURLResponse?, Members?, NSError?) -> Void) -> Self {
        return response(serializer: Request.membersArrayResponseSerializer(), completionHandler: { (request, response, membersWrapper, error) in
            completionHandler(request, response, membersWrapper as? MembersWrapper, error)
        })
    }
    
}
   
/*extension Alamofire.Request {
    func responseMembersArray(completionHandler: (NSURLRequest, NSHTTPURLResponse?, MembersWrapper?, NSError?) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<MembersWrapper> { request, response, data in
            if let responseData = data
            {
                var jsonError: NSError?
                let jsonData:AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                if jsonData == nil || jsonError != nil
                {
                    return (nil, jsonError)
                }
                let json = JSON(jsonData!)
                if json.error != nil || json == nil
                {
                    return (nil, json.error)
                }
                
                var wrapper:MembersWrapper = MembersWrapper()
                wrapper.next = json["next"].stringValue
                wrapper.previous = json["previous"].stringValue
                wrapper.count = json["count"].intValue
                
                var allMembers:Array = Array<StarWarsMembers>()
                print(json)
                let results = json["results"]
                print(results)
                for jsonMembers in results
                {
                    print(jsonMembers.1)
                    let members = Members(json: jsonMembers.1, id: jsonMembers.0.toInt())
                    allMembers.append(members)
                }
                wrapper.members = allMembers
                return (wrapper, nil)
            }
            return (nil, nil)
        }
        
        return response(responseSerializer: responseSerializer,
            completionHandler: completionHandler)
    }
}*/


/*class Kids {
    var name : String
    
    var status : String
    
    init(name: String, status: String) { self.name = name ; self.status = status }
    
    
}*/*/