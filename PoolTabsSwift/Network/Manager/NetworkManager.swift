//
//  NetworkManager.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/27/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftHTTP
import Alamofire

class NetworkManager: NSObject {
    
    
    
    override init() {
        
    }
    
    
    func responsehandler(_ response : AnyObject? ,error : NSError?)->(Void) {
    
    }
    
    func getResponseForUrl(_ urlString : String, params : (Dictionary<String,String>)?,responsehandler:@escaping (AnyObject?,NSError?)->Void) -> (Void) {
    /*    print("URL \(urlString)")
        print("Params \(params)")
        
        let afManager = AFHTTPRequestOperationManager()
        
        var consetSet : Set = afManager.responseSerializer.acceptableContentTypes!
        
        consetSet.insert("text/html")
        
        //afManager.responseSerializer.acceptableContentTypes = afManager.responseSerializer.acceptableContentTypes?. ("text/html")

        afManager.responseSerializer.acceptableContentTypes = consetSet as Set<NSObject>
        let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        afManager.get(encodeString!, parameters: params, success: {  (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!)  in
            
            
            
            responsehandler(responseObject,nil)
            print("Response \(responseObject)")
            
            },failure: { (operation: AFHTTPRequestOperation?,
                error: NSError!) in
                
                responsehandler(nil,error)
                print("Error sssssss:  " + error.localizedDescription)
        })*/
        
        let manager = AFHTTPSessionManager()
        manager.get(
            urlString,
            parameters:nil ,
            success:
            {
                (operation, responseObject) in
                
                //  if let dic = responseObject as? [String: Any], let matches = dic["matches"] as? [[String: Any]] {
                //    print(matches)
                // }
                DispatchQueue.main.async {
                    // self.tollBothPlazaTableView.reloadData()
                    responsehandler(responseObject as AnyObject?,nil)
                }
        },
            failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                responsehandler(nil,error as NSError?)
        })
    }
    
    
    
    func postResponseForUrl(_ urlString : String, params : (Dictionary<String,AnyObject>)?,responsehandler:@escaping (AnyObject?,NSError?)->Void) -> (Void) {
        
        // func postResponseForUrl(urlString : String, params : (NSDictionary)?,responsehandler:(AnyObject?,NSError?)->Void) -> (Void) {
        //print("URL \(urlString)")
        //print("Params \(params)")
        print("GET URL \(urlString)")
        print("GET Params \(params)")
        /*
         Alamofire.request(.POST, urlString, parameters: params!, encoding: ParameterEncoding.JSON, headers: nil)
         .responseJSON { (response) in
         
         let json: NSDictionary?
         do {
         json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableLeaves) as? NSDictionary
         // //print("JSON: '\(json!.description)'")
         responsehandler(json,nil)
         } catch let dataError {
         // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
         //  print(dataError)
         let jsonStr = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
         //print("Error could not parse JSON: '\(jsonStr?.description)'")
         // return or throw?
         let userInfo: [AnyHashable: Any] =
         [
         NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: ""),
         NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: "")
         ]
         let err = NSError(domain: "ShipHttpResponseErrorDomain", code: 200, userInfo: userInfo)
         //   println("Error in Post: \(err.localizedDescription)")
         
         responsehandler(nil,err)
         return
         }
         
         }
         */
        
        
        Alamofire.request(urlString, method: .post, parameters: params!, encoding: JSONEncoding.default)
            
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                let json: NSDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableLeaves) as? NSDictionary
                    // //print("JSON: '\(json!.description)'")
                    responsehandler(json,nil)
                } catch let dataError {
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    //  print(dataError)
                    let jsonStr = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    //print("Error could not parse JSON: '\(jsonStr?.description)'")
                    // return or throw?
                    let userInfo: [AnyHashable: Any] =
                        [
                            NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: "")
                    ]
                    let err = NSError(domain: "ShipHttpResponseErrorDomain", code: 200, userInfo: userInfo)
                    //   println("Error in Post: \(err.localizedDescription)")
                    
                    responsehandler(nil,err)
                    return
                }
                
        }
        
        
    }

    
    
    func postResponseForUrlWIthHeaders(_ urlString : String, params : (Dictionary<String,AnyObject>)?, headers : (Dictionary<String,String>)?,responsehandler:@escaping (AnyObject?,NSError?)->Void) -> (Void) {
        
        // func postResponseForUrl(urlString : String, params : (NSDictionary)?,responsehandler:(AnyObject?,NSError?)->Void) -> (Void) {
        print("URL \(urlString)")
        print("Params \(params)")
        
        /*    Alamofire.request(urlString, method:HTTPMethod.post, parameters: params!, encoding: ParameterEncoding.JSON, headers: headers).responseJSON { (response) in
         //Alamofire.request(.POST, urlString, parameters: params!, encoding: ParameterEncoding.JSON, headers: headers)
         //  .responseJSON { (response) in
         
         let json: NSDictionary?
         do {
         json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableLeaves) as? NSDictionary
         // //print("JSON: '\(json!.description)'")
         responsehandler(json,nil)
         } catch let dataError {
         // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
         //  print(dataError)
         let jsonStr = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
         //print("Error could not parse JSON: '\(jsonStr?.description)'")
         // return or throw?
         let userInfo: [AnyHashable: Any] =
         [
         NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: ""),
         NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: "")
         ]
         let err = NSError(domain: "ShipHttpResponseErrorDomain", code: 200, userInfo: userInfo)
         //   println("Error in Post: \(err.localizedDescription)")
         
         responsehandler(nil,err)
         return
         }
         
         }*/
        
        
        Alamofire.request(urlString, method: .post, parameters: params!, encoding: JSONEncoding.default)
            
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                let json: NSDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableLeaves) as? NSDictionary
                    // //print("JSON: '\(json!.description)'")
                    responsehandler(json,nil)
                } catch let dataError {
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    //  print(dataError)
                    let jsonStr = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    //print("Error could not parse JSON: '\(jsonStr?.description)'")
                    // return or throw?
                    let userInfo: [AnyHashable: Any] =
                        [
                            NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: ""),
                            NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Failed to fetch response from server.", comment: "")
                    ]
                    let err = NSError(domain: "ShipHttpResponseErrorDomain", code: 200, userInfo: userInfo)
                    //   println("Error in Post: \(err.localizedDescription)")
                    
                    responsehandler(nil,err)
                    return
                }
        }
    }

}
