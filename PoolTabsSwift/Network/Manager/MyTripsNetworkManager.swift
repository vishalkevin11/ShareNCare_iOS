//
//  MyTripsNetworkManager.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/27/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit




class MyTripsNetworkManager: NSObject {
    
    var networkManager : NetworkManager  = NetworkManager()

    override init() {
        
    }
    
    
    
   
    
    func getLoginStatusForPhoneNumber(_ phoneNumber : String, completion: @escaping (String?, NSError?) -> Void) -> Void {
        
        
        
        // let  travellerTypeValue : Int? = 0
        //  //let urlstr : String = kBaseURLString
        let urlstr1 : String = AppCacheManager.sharedInstance.baseURl!
        let urlstr : String = "\(urlstr1)check_login_exist.php?phonenumber=\(phoneNumber)"
        
        self.networkManager.getResponseForUrl(urlstr, params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                let messageStr = responseDictionary["status_code"] as! String
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    DispatchQueue.main.async(execute: {
                        completion(messageStr,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(messageStr,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
        }
        
    }
    
    
    func getProfileDetailsForEmail(_ userEmailSTr : String, completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        

        
        // let  travellerTypeValue : Int? = 0
        //  //let urlstr : String = kBaseURLString
        let urlstr1 : String = AppCacheManager.sharedInstance.baseURl!
        let urlstr : String = "\(urlstr1)fetch_profile.php?email=\(userEmailSTr)"
        
        
        
        self.networkManager.getResponseForUrl(urlstr, params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let profileDict = responseDictionary["profile"] as! NSDictionary
                   
                    
                    DispatchQueue.main.async(execute: {
                        completion(profileDict,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
            
        }
        
    }
    
    
    /*func getAllTrips(completion: (AnyObject?, NSError?) -> Void) -> Void {
        
        //"aaa@bbb.com"
        
        let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
       // cacheDefaults.setObject("aaa@bbb.com", forKey: KSAVEDEMAILLOCAL)
        
        
        let loggedInUserEmail : String? = AppCacheManager.sharedInstance.getLoggedInUserEmail()
        

        
        /***************** REMOVE THIS***************/
        
       // AppCacheManager.sharedInstance.resetFilter()
        
        /***************** REMOVE THIS***************/
//        let  tripTypeValue : Int? = (cacheDefaults.valueForKey(K_SAVED_TRIP_TYPE) != nil) ? (cacheDefaults.valueForKey(K_SAVED_TRIP_TYPE) as? Int) : nil
//        let  noOfSeatsValue : Int? = (cacheDefaults.valueForKey(K_SAVED_NUMBER_OF_SEATS) != nil) ? (cacheDefaults.valueForKey(K_SAVED_NUMBER_OF_SEATS) as? Int) : nil
//        let  travellerTypeValue : Int? = (cacheDefaults.valueForKey(K_SAVED_TRAVELLER_TYPE) != nil) ? (cacheDefaults.valueForKey(K_SAVED_TRAVELLER_TYPE) as? Int) : nil
//        let  sourceLatValue : Double? = (cacheDefaults.valueForKey(K_SAVED_SOURCE_LAT) != nil) ? (cacheDefaults.valueForKey(K_SAVED_SOURCE_LAT) as? Double) : nil
//        let  sourceLngValue : Double? =  (cacheDefaults.valueForKey(K_SAVED_SOURCE_LNG) != nil) ? (cacheDefaults.valueForKey(K_SAVED_SOURCE_LNG) as? Double) : nil
//        let  destLatValue : Double? = (cacheDefaults.valueForKey(K_SAVED_DESTINATION_LAT) != nil) ? (cacheDefaults.valueForKey(K_SAVED_DESTINATION_LAT) as? Double) : nil
//        let  destLngValue : Double? = (cacheDefaults.valueForKey(K_SAVED_DESTINATION_LNG) != nil) ? (cacheDefaults.valueForKey(K_SAVED_DESTINATION_LNG) as? Double) : nil
        
        
        
 let  tripTypeValue : Int? = (cacheDefaults.valueForKey(kCacheTripTypeName) != nil) ? (cacheDefaults.valueForKey(kCacheTripTypeName) as? Int) : 1
 let  noOfSeatsValue : Int? = (cacheDefaults.valueForKey(kCacheNumberOfSeatsName) != nil) ? (cacheDefaults.valueForKey(kCacheNumberOfSeatsName) as? Int) : 1
 let  travellerTypeValue : Int? = (cacheDefaults.valueForKey(kCacheTravellerTypeName) != nil) ? (cacheDefaults.valueForKey(kCacheTravellerTypeName) as? Int) : 1
       
 let  scheduleTypeValue : Int? = (cacheDefaults.valueForKey(kCacheScheduleTypeName) != nil) ? (cacheDefaults.valueForKey(kCacheScheduleTypeName) as? Int) : 1
 let  sourceLatValue : Double? = (cacheDefaults.valueForKey(kCacheSourceLat) != nil) ? (cacheDefaults.valueForKey(kCacheSourceLat) as? Double) : 0.0
 let  sourceLngValue : Double? =  (cacheDefaults.valueForKey(kCacheSourceLng) != nil) ? (cacheDefaults.valueForKey(kCacheSourceLng) as? Double) : 0.0
 let  destLatValue : Double? = (cacheDefaults.valueForKey(kCacheDestinationLat) != nil) ? (cacheDefaults.valueForKey(kCacheDestinationLat) as? Double) : 0.0
 let  destLngValue : Double? = (cacheDefaults.valueForKey(kCacheDestinationLng) != nil) ? (cacheDefaults.valueForKey(kCacheDestinationLng) as? Double) : 0.0
        let  tripDateValue : String? = (cacheDefaults.objectForKey(kCacheTripDate) != nil) ? (cacheDefaults.objectForKey(kCacheTripDate) as? String) : ""
 //trip_date
 
 // let  travellerTypeValue : Int? = 0
      //  //let urlstr : String = kBaseURLString
        let urlstr1 : String = AppCacheManager.sharedInstance.baseURl!
        let urlstr : String = "\(urlstr1)show_all_trips_with_filter.php?email_val=\(loggedInUserEmail!)&source_lat=\(sourceLatValue!)&source_lng=\(sourceLngValue!)&destination_lat=\(destLatValue!)&destination_lng=\(destLngValue!)&number_of_seats=\(noOfSeatsValue!)&trip_type=\(tripTypeValue!)&traveller_type=\(travellerTypeValue!)&trip_date=\(tripDateValue!)&schedule_type=\(scheduleTypeValue!)"
        
        
        
        self.networkManager.getResponseForUrl(urlstr, params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["trips"] as! NSArray
                    let myTrips = NSMutableArray()
                    
                    trips.enumerateObjectsUsingBlock({ (trip, index, stop) in
                        
                        let tripDict = trip as! NSDictionary
                        let tmpTrip = Trip(tripDict: tripDict)
                        myTrips.addObject(tmpTrip)
                        
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(myTrips,error)
                    })
                }
                else {
                    print("NO rsult")
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(nil,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil,error)
                })
                
            }
            
            
        }
        
    }*/
    
  
    
    
    
    func getAllFoodItems(lat_val : Double, long_val : Double, _ completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        //cacheDefaults.setObject("aaa@bbb.com", forKey: KSAVEDEMAILLOCAL)
        
        
       // let loggedInUserEmail : String = AppCacheManager.sharedInstance.getLoggedInUserEmail()
        
         let loggedInUserPhoneNumber : String = AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        
        ////let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.getResponseForUrl("\(urlstr)fetch_product.php?lat=\(lat_val)&lng=\(long_val)", params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["food_items"] as! NSArray
                    let myTrips = NSMutableArray()
                    
                    trips.enumerateObjects({ (trip, index, stop) in
                        
                        let tripDict = trip as! NSDictionary
                        let tmpTrip = FoodItem(tripDict: tripDict)
                        myTrips.add(tmpTrip)
                        
                    })
                    
                    DispatchQueue.main.async(execute: {
                        completion(myTrips,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
            
        }
        
    }
    
    
    
    func getFoodItemDetails(_ uniqID : Int ,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        
    //    let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
        //cacheDefaults.setObject("aaa@bbb.com", forKey: KSAVEDEMAILLOCAL)
        
        
        // let loggedInUserEmail : String = AppCacheManager.sharedInstance.getLoggedInUserEmail()
        
     //   let loggedInUserPhoneNumber : String = AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        
        ////let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.getResponseForUrl("\(urlstr)fetch_product_details.php?uniqueid=\(uniqID)", params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["food_items"] as! NSArray
                    //let myTrips = NSMutableArray()
                    
                    if trips.count > 0 {
                    
                   /// trips.enumerateObjectsUsingBlock({ (trip, index, stop) in
                        let trip = trips[0]
                        let tripDict = trip as! NSDictionary
                        let tmpTrip = FoodItem(tripDict: tripDict)
                       // myTrips.addObject(tmpTrip)
                        DispatchQueue.main.async(execute: {
                            completion(tmpTrip,error)
                        })
                        
                    }
                    
                    //})
                    
                    
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
            
        }
        
    }
    
    
    func getMyTrips(_ completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        //cacheDefaults.setObject("aaa@bbb.com", forKey: KSAVEDEMAILLOCAL)
        
        
        let loggedInUserEmail : String = AppCacheManager.sharedInstance.getLoggedInUserEmail()
        ////let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.getResponseForUrl("\(urlstr)show_my_trips.php?email_val=\(loggedInUserEmail)", params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["trips"] as! NSArray
                    let myTrips = NSMutableArray()
                    
                    trips.enumerateObjects({ (trip, index, stop) in
                        
                        let tripDict = trip as! NSDictionary
                        let tmpTrip = Trip(tripDict: tripDict)
                        myTrips.add(tmpTrip)
                        
                    })
                    
                    DispatchQueue.main.async(execute: {
                        completion(myTrips,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
                
                
               
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
            
        }

    }
    
    
    
    func createOffer(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
    
   //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)add_product.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    var return_unique_id = responseDictionary["food_item_id"] as? Double
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        completion(return_unique_id as AnyObject?,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(0.0 as AnyObject?,nil)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    
    
    func bookfooItem(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (Bool) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)book_food_item.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                   // var return_unique_id = responseDictionary["food_item_id"] as? Double
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
            
            
        }
        
    }
    
    
    
    func unbookfooItem(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (Bool) -> Void) -> Void {
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)unbook_food_item.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                if responseDictionary["status_code"] as! Int == 200 {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
        }
    }
    
    
    func acceptRequestForfoodItem(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (Bool) -> Void) -> Void {
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)approve_food_item.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                if responseDictionary["status_code"] as! Int == 200 {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
        }
    }
    
    
    func deletefoodItem(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (Bool) -> Void) -> Void {
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)delete_food_item.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                if responseDictionary["status_code"] as! Int == 200 {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
        }
    }
    
    
    func rejectRequestForfoodItem(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (Bool) -> Void) -> Void {
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)reject_food_item.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                if responseDictionary["status_code"] as! Int == 200 {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
        }
    }
    
    
    func updateTrip(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)update_trip.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    DispatchQueue.main.async(execute: {
                        completion("Trip successfully updated" as AnyObject?,error)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        completion("Failed to update trip" as AnyObject?,nil)
                    })
                }
        }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    func getLatLongs(_ forID:String, completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
//    func getLatLongs(forID:String, completion: (AnyObject?, NSError?) -> Void) -> Void {
    
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.getResponseForUrl("\(urlstr)fetchLatlongs.php?unique_value=\(forID)", params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["latlongs"] as! NSArray
                    let latlongsArray = NSMutableArray()
                    
                    trips.enumerateObjects({ (trip, index, stop) in
                        
                        let latLnDict = trip as! NSDictionary
                        let tmpTrip = LatLongs(latlongDict:latLnDict)
                        latlongsArray.add(tmpTrip)
                        
                    })
                    
                    DispatchQueue.main.async(execute: {
                        completion(latlongsArray,error)
                    })
                }
                else {
                    print("NO rsult")
                    
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    
 
    
    
    func loginToTavantPool(_ params : (Dictionary<String,String>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        
        
        let tavantlogin_url = AppCacheManager.sharedInstance.getTavantLoginUrl()
        let tavantlogin_url_node = AppCacheManager.sharedInstance.getTavantBaseUrlNode()
        
        self.networkManager.postResponseForUrlWIthHeaders("\(tavantlogin_url)\(tavantlogin_url_node)", params:params as (Dictionary<String, AnyObject>)?, headers:["Content-Type":"application/json","Accept" : "application/json"] ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                print("SUCCCCCCCCCCCESSSSS\(responseDictionary.description)")
                /*
                 {
                 authenticate = 0;
                 mailId = "<null>";
                 title = "<null>";
                 userName = "<null>";
                 userType = "<null>";
                 }
 */
                if ((responseDictionary["authenticate"] as! Int == 1 ) || !(responseDictionary["mailId"] is NSNull)){
            //      if (!(responseDictionary["mailId"] is NSNull)){
                    
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        //completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                else if responseDictionary["authenticate"] as! Int == 0 {
                    print("Failed to Sign-In")
                    DispatchQueue.main.async(execute: {
                        //completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
        }
    }
    
    
    //LOGIN :
    
    
    func loginToPool(_ params : (Dictionary<String,String>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)login.php", params:params as (Dictionary<String, AnyObject>)? ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        //completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                else if responseDictionary["status_code"] as! Int == 400 {
                    print("Failed to Sign-In")
                    DispatchQueue.main.async(execute: {
                        //completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
        }
    }
    
    
    func signUpToPool(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)signup.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                       // completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                else if responseDictionary["status_code"] as! Int == 400 {
                    print("Failed to Sign-In")
                    DispatchQueue.main.async(execute: {
                     //   completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    
    func signInToTavantPool(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)signin_tavant.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        // completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                else if responseDictionary["status_code"] as! Int == 400 {
                    print("Failed to Sign-In")
                    DispatchQueue.main.async(execute: {
                        //   completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    func forgotPasswordInPool(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)forgotpassword.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    
                    print("SUCCCCCCCCCCCESSSSS")
                    DispatchQueue.main.async(execute: {
                        //completion("Successfully LoggedIn",error)
                        completion(response,nil)
                    })
                }
                else if responseDictionary["status_code"] as! Int == 400 {
                    print("Failed to reset")
                    DispatchQueue.main.async(execute: {
                        //   completion(responseDictionary["status_message"],nil)
                        completion(response,nil)
                    })
                }
                else {
                    print("Failed to login")
                    DispatchQueue.main.async(execute: {
                        completion(nil,error)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    
    func deleteTrip(_ params : (Dictionary<String,AnyObject>)?,completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        //  func createTrip(params : (NSDictionary)?,completion: (AnyObject?, NSError?) -> Void) -> Void {
        //let urlstr : String = kBaseURLString
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.postResponseForUrl("\(urlstr)delete_trip.php", params:params ) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    DispatchQueue.main.async(execute: {
                        completion("Trip successfully deleted" as AnyObject?,error)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        completion("Failed to delete trip" as AnyObject?,nil)
                    })
                }
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
            }
            
            
        }
        
    }
    
    // MARK: Product Categories
    
    func getAllProductType(_ completion: @escaping (AnyObject?, NSError?) -> Void) -> Void {
        
        
        let urlstr : String = AppCacheManager.sharedInstance.baseURl!
        self.networkManager.getResponseForUrl("\(kBaseURLString)/json/product_type.json", params: nil) { (response : AnyObject?, error : NSError?) in
            
            if (error == nil) && (response != nil) {
                
                let responseDictionary = response as! NSDictionary
                
                if responseDictionary["status_code"] as! Int == 200 {
                    
                    let trips = responseDictionary["product_type"] as! NSArray
                    let myTrips = NSMutableArray()
                    
                    trips.enumerateObjects({ (trip, index, stop) in
                        
                        let tripDict = trip as! NSDictionary
                        let tmpTrip = ProductType(productDict: tripDict)
                        myTrips.add(tmpTrip)
                        
                    })
                    
                    DispatchQueue.main.async(execute: {
                        completion(myTrips,error)
                    })
                }
                else {
                    print("NO rsult")
                    DispatchQueue.main.async(execute: {
                        completion(nil,nil)
                    })
                }
                
                
                
            }
            else {
                // Show Alert here
                print("NO rsult")
                DispatchQueue.main.async(execute: {
                    completion(nil,error)
                })
                
            }
            
            
        }
        
    }

}
