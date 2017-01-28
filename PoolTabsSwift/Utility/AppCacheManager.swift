//
//  AppCacheManager.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import Alamofire

//let KLOGINSAVEDEMAIL = "kloginSavedEmail"
let KSAVEDEMAILLOCAL = "kSavedEmailLocal"
let KSAVEDPHONENUMBERLOCAL = "kSavedPhoneNumberLocal"
let KSAVEDUSERNAME = "kSavedUserName"
let KSAVEDUSERROLE = "kSavedUserRole"

let K_SAVED_IS_FILTER_SET = "kIsFilterSet"

let K_SAVED_NUMBER_OF_SEATS = "kNumberOfSeats"
let K_SAVED_TRIP_TYPE = "kTripType"
let K_SAVED_TRAVELLER_TYPE = "kTravellerType"
let K_SAVED_SOURCE_LAT = "kSourceLat"
let K_SAVED_SOURCE_LNG = "kSourceLng"
let K_SAVED_DESTINATION_LAT = "kDestinationLat"
let K_SAVED_DESTINATION_LNG = "kDestinationLng"
let K_SAVED_TRIP_DATE = "kTripDate"


let K_NOTIFICATION_FILTER_TRIPS = "KNotificationFilterTrips"

let K_SAVED_TAVANT_ALL_API_URL = "kSavedTavantAllApiURL"
let K_SAVED_TAVANT_LOGIN_API_URL = "kSavedTavantLoginURL"
let K_SAVED_TAVANT_BASE_API_Node = "kSavedTavantBaseApiNode"


class AppCacheManager: NSObject {
    
    static let sharedInstance = AppCacheManager()
    
    var alamoFireManager : Alamofire.SessionManager?
    let configuration = URLSessionConfiguration.default
    
    var baseURl :String?
    var baseURlNode :String?
    var tavantLoginURL :String?
    

    
    func saveBaserUrlAndNode(_ urlPrams : [String : String]) -> Void {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        
        self.tavantLoginURL = urlPrams[K_SAVED_TAVANT_LOGIN_API_URL]
        self.baseURl = urlPrams[K_SAVED_TAVANT_ALL_API_URL]
        self.baseURlNode = urlPrams[K_SAVED_TAVANT_BASE_API_Node]
        
        cacheDefaults.set(urlPrams[K_SAVED_TAVANT_ALL_API_URL], forKey: K_SAVED_TAVANT_ALL_API_URL)
        cacheDefaults.set(urlPrams[K_SAVED_TAVANT_LOGIN_API_URL], forKey: K_SAVED_TAVANT_LOGIN_API_URL)
        cacheDefaults.set(urlPrams[K_SAVED_TAVANT_BASE_API_Node], forKey: K_SAVED_TAVANT_BASE_API_Node)
        cacheDefaults.synchronize()
    }
    
    
    func getAllApiUrl() -> String {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        return cacheDefaults.string(forKey: K_SAVED_TAVANT_ALL_API_URL)!
    }

    func getTavantBaseUrlNode() -> String {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        return cacheDefaults.string(forKey: K_SAVED_TAVANT_BASE_API_Node)!
    }
    
    func getTavantLoginUrl() -> String {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        return cacheDefaults.string(forKey: K_SAVED_TAVANT_LOGIN_API_URL)!
    }

    
    // MARK: Filter Value
    
    
    func resetFilter() -> Void {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        
        cacheDefaults.set("", forKey: kCacheSourceName)
        cacheDefaults.set("", forKey: kCacheDestinationName)
        cacheDefaults.set(0, forKey: kCacheNumberOfSeatsName)
        cacheDefaults.set(0, forKey: kCacheTravellerTypeName)
        cacheDefaults.set(0, forKey: kCacheScheduleTypeName)
        cacheDefaults.set(0, forKey: kCacheTripTypeName)
        cacheDefaults.set(0, forKey: kCacheIsTripLive)
        
        
        cacheDefaults.set(0.0, forKey: kCacheSourceLat)
        cacheDefaults.set(0.0, forKey: kCacheSourceLng)
        cacheDefaults.set(0.0, forKey: kCacheDestinationLat)
        cacheDefaults.set(0.0, forKey: kCacheDestinationLng)
        
        cacheDefaults.set("", forKey: kCacheTripDate)
        cacheDefaults.set(false, forKey: K_SAVED_IS_FILTER_SET)
        
       /* cacheDefaults.setBool(false, forKey: K_SAVED_IS_FILTER_SET)
        cacheDefaults.setValue(0, forKey: K_SAVED_NUMBER_OF_SEATS)
        cacheDefaults.setValue(0, forKey: K_SAVED_TRIP_TYPE)
        cacheDefaults.setValue(0, forKey: K_SAVED_TRAVELLER_TYPE)
        cacheDefaults.setValue(0.0, forKey: K_SAVED_SOURCE_LAT)
        cacheDefaults.setValue(0.0, forKey: K_SAVED_SOURCE_LNG)
        cacheDefaults.setValue(0.0, forKey: K_SAVED_DESTINATION_LAT)
        cacheDefaults.setValue(0.0, forKey: K_SAVED_DESTINATION_LNG)
        cacheDefaults.setValue("", forKey: K_SAVED_TRIP_DATE)*/
        cacheDefaults.synchronize()
    }
    
    
    
    func showLoggedInScreen() -> Void {
       // if !AppCacheManager.sharedInstance.isLoggedIn() {
        
        resetFilter()
        
        
        let mainStoryboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let loginToTavantViewController : LoginToTavantViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginToTavantViewController") as! LoginToTavantViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController =  loginToTavantViewController
        
        
       // }
    }
    
    func showHomeTabScreen() -> Void {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.initialiseTabbarController()
    
    }
    
    
    
    // MARK: Get logged in status
    func isLoggedIn() -> Bool {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        let userEmail : String? = cacheDefaults.object(forKey: KSAVEDEMAILLOCAL) as? String
        let value : Bool = ((userEmail != nil) && (userEmail?.isEmpty == false)) ? true : false
     return value
    }
    
    func logOutFormApp() -> Void {
        resetFilter()
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        cacheDefaults.set("", forKey: KSAVEDEMAILLOCAL)
        cacheDefaults.set("", forKey: KSAVEDPHONENUMBERLOCAL)
        cacheDefaults.synchronize()
    }
    
    
    // MARK: Filter Status
    
    func isFilterSet() -> Bool {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        let isfiletred : Bool = cacheDefaults.bool(forKey: K_SAVED_IS_FILTER_SET)
        return  isfiletred
    }
    
    // MARK: LoggedIn  user status
    func getLoggedInUserPhoneNumber() -> String {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        let userPhonenumberStr : String? = cacheDefaults.object(forKey: KSAVEDPHONENUMBERLOCAL) as? String
        return  ((userPhonenumberStr != nil) && (userPhonenumberStr?.isEmpty == false)) ? userPhonenumberStr! : ""
    }
    
    func getLoggedInUserEmail() -> String {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        let userEmailStr : String? = cacheDefaults.object(forKey: KSAVEDEMAILLOCAL) as? String
        return  ((userEmailStr != nil) && (userEmailStr?.isEmpty == false)) ? userEmailStr! : ""

    }
    
    func getLoggedInUserName() -> String {
        let emailStr = getLoggedInUserEmail()
        let delimiter = "@"
        let userName = emailStr.components(separatedBy: delimiter)
        return userName[0] as String
        
//        let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
//        let userNameStr : String? = cacheDefaults.objectForKey(KSAVEDUSERNAME) as? String
//        return userNameStr!
        
    }
    
    func getLoggedInUserRoleType() -> String {
        // let emailStr = getLoggedInUserEmail()
        // let delimiter = "@"
        //  let userName = emailStr.componentsSeparatedByString(delimiter)
        // return userName[0] as String
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        let userRoleStr : String? = cacheDefaults.object(forKey: KSAVEDUSERROLE) as? String
        return userRoleStr!
        
    }
    
    // MARK: Save user credentials
    
    //AppCacheManager.sharedInstance.saveUserLoggedInstatus([KSAVEDPHONENUMBERLOCAL : profileDict["phonenumber"]!, KSAVEDEMAILLOCAL : profileDict["email"]!,KSAVEDUSERNAME : profileDict["username"]!,KSAVEDUSERROLE : profileDict["jobtitle"]!])
    func saveUserLoggedInstatus(_ loginDictionary : NSDictionary) -> Void {
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
       // cacheDefaults.setObject(loginDictionary[KSAVEDEMAILLOCAL], forKey: KSAVEDEMAILLOCAL)
      
         cacheDefaults.set(loginDictionary[KSAVEDPHONENUMBERLOCAL], forKey: KSAVEDPHONENUMBERLOCAL)
         cacheDefaults.set(loginDictionary[KSAVEDUSERNAME], forKey: KSAVEDUSERNAME)
         cacheDefaults.set(loginDictionary[KSAVEDEMAILLOCAL], forKey: KSAVEDEMAILLOCAL)
         cacheDefaults.set(loginDictionary[KSAVEDUSERROLE], forKey: KSAVEDUSERROLE)
        
        cacheDefaults.synchronize()
        //save login tooo
     //   cacheDefaults.setObject(loginDictionary[KLOGINSAVEDEMAIL], forKey: KLOGINSAVEDEMAIL)
        
       // print("name : \(getLoggedInUserEmail()) number \(getLoggedInUserPhoneNumber())")
    }
    
    func saveFilterDetails(_ filterDict : NSDictionary) -> Void {
        
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        
       
        
        let source_name =  ((filterDict["source_name"]) != nil ) ? filterDict["source_name"]! as? String : ""
        let destination_name =  ((filterDict["destination_name"]) != nil ) ? filterDict["destination_name"]! as? String : ""
        let trip_date =  ((filterDict["trip_date"]) != nil ) ? filterDict["trip_date"]! as? String : ""
        
        //        let trip_path =  ((filterDict["trip_path"]) != nil ) ? filterDict["trip_path"]! as? String : "NA"
        //        let time_leaving_source =  ((filterDict["time_leaving_source"]) != nil ) ? filterDict["time_leaving_source"]! as? String : "NA"
        //        let time_leaving_destination =  ((filterDict["time_leaving_destination"]) != nil ) ? filterDict["time_leaving_destination"]! as? String : "NA"
        
        
        //        let total_trip_time =  ((filterDict["total_trip_time"]) != nil ) ? filterDict["total_trip_time"]! as? String : "NA"
        let number_of_seats =  ((filterDict["number_of_seats"]) != nil ) ? (filterDict["number_of_seats"]! as AnyObject).intValue : 1
        let traveller_type =  ((filterDict["traveller_type"]) != nil ) ? (filterDict["traveller_type"]! as AnyObject).intValue : 1
        let schedule_type =  ((filterDict["schedule_type"]) != nil ) ? (filterDict["schedule_type"]! as AnyObject).intValue : 1
        let trip_type =  ((filterDict["trip_type"]) != nil ) ? (filterDict["trip_type"]! as AnyObject).intValue : 1
        
        //        let uniqueid_val =  ((filterDict["uniqueid_val"]) != nil ) ? filterDict["uniqueid_val"]!.doubleValue : 0.0
        //        let phonenumber_val =  ((filterDict["phonenumber_val"]) != nil ) ? filterDict["phonenumber_val"]! as? String : "NA"
        //        let email_val =  ((filterDict["email_val"]) != nil ) ? filterDict["email_val"]! as? String : "NA"
        let is_trip_live =  ((filterDict["is_trip_live"]) != nil ) ? (filterDict["is_trip_live"]! as AnyObject).intValue : 1
        

        let sourceLat =  ((filterDict["sourceLat"]) != nil ) ? (filterDict["sourceLat"]! as AnyObject).doubleValue : 0.0
        let sourceLng =  ((filterDict["sourceLng"]) != nil ) ? (filterDict["sourceLng"]! as AnyObject).doubleValue : 0.0
        let destinationLat =  ((filterDict["destinationLat"]) != nil ) ? (filterDict["destinationLat"]! as AnyObject).doubleValue : 0.0
        let destinationLng =  ((filterDict["destinationLng"]) != nil ) ? (filterDict["destinationLng"]! as AnyObject).doubleValue : 0.0
        
        
        cacheDefaults.set(source_name, forKey: kCacheSourceName)
        cacheDefaults.set(destination_name, forKey: kCacheDestinationName)
        cacheDefaults.set(number_of_seats, forKey: kCacheNumberOfSeatsName)
        cacheDefaults.set(traveller_type, forKey: kCacheTravellerTypeName)
        cacheDefaults.set(schedule_type, forKey: kCacheScheduleTypeName)
        cacheDefaults.set(trip_type, forKey: kCacheTripTypeName)
        cacheDefaults.set(is_trip_live, forKey: kCacheIsTripLive)
        
        
        cacheDefaults.set(sourceLat, forKey: kCacheSourceLat)
        cacheDefaults.set(sourceLng, forKey: kCacheSourceLng)
        cacheDefaults.set(destinationLat, forKey: kCacheDestinationLat)
        cacheDefaults.set(destinationLng, forKey: kCacheDestinationLng)
        
        cacheDefaults.set(trip_date, forKey: kCacheTripDate)
        
        cacheDefaults.synchronize()
        
    }
    
    
 
    
    
  //  static let sharedInstance = HTTPClient()
    
 
    
    func getTheBaseURL(_ responsehandler:@escaping (Bool)->Void) -> (Void) {

        
        DispatchQueue.main.async(execute: {
            let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
            
            self.baseURl = kBaseURLString
            
            cacheDefaults.set(self.baseURl, forKey: K_SAVED_TAVANT_ALL_API_URL)
            cacheDefaults.synchronize()
            responsehandler(true)
        })
        
        /*
        
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        var cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        configuration.HTTPCookieStorage = cookies
        configuration.HTTPShouldSetCookies = false
        configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Never
        
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)
        
        self.alamoFireManager!.request(.GET,
            kDropboxJSONLink,
            parameters: nil
            )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error!)")
                    dispatch_async(dispatch_get_main_queue(), {
                        responsehandler(false)
                    })

                    return
                }
                
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("Invalid tag information received from service")
                    dispatch_async(dispatch_get_main_queue(), {
                        responsehandler(false)
                    })
                    return
                }
                //print(responseJSON)
                dispatch_async(dispatch_get_main_queue(), {
                    let responseDictionary = response.result.value as? [String: AnyObject]
                    
                    let baseURLStr = responseDictionary!["base_url"] as! String
                    let loginURLStr = responseDictionary!["tavant_login_api"] as! String
                    let baseURLNodeStr = responseDictionary!["tavant_login_api_node"] as! String
                    
                    dispatch_async(dispatch_get_main_queue(), {
                       // self.baseURl = baseURLStr
                        
                        let loginparams = [K_SAVED_TAVANT_LOGIN_API_URL :loginURLStr,K_SAVED_TAVANT_ALL_API_URL :baseURLStr,K_SAVED_TAVANT_BASE_API_Node:baseURLNodeStr]
                        self.saveBaserUrlAndNode(loginparams)
                        responsehandler(true)
                    })
                    
                })
        }
        */
          }
    

    
//    func getFilterValues() -> NSMutableDictionary {
//        
//        var filterDictionary : NSMutableDictionary?
//        
//        let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
//        
//        filterDictionary?.setObject(cacheDefaults.objectForKey(kCacheSourceName)!, forKey: "source_name")
//        filterDictionary?.setObject(cacheDefaults.objectForKey(kCacheSourceName)!, forKey: "destination_name")
//        
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "number_of_seats")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "traveller_type")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "schedule_type")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "trip_type")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "is_trip_live")
//        
//        
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceLat)!, forKey: "sourceLat")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceLng)!, forKey: "sourceLng")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheDestinationLat)!, forKey: "destinationLat")
//        filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheDestinationLng)!, forKey: "destinationLng")
//        
//        filterDictionary?.setObject(cacheDefaults.objectForKey(kCacheTripDate)!, forKey: "trip_date")
//        return filterDictionary!
//        
//    }
    
}
