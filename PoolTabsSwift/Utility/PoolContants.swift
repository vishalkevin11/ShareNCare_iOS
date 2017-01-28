//
//  PoolContants.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
//import MKSpinner

//let kBaseURLString = "http://tuffytiffany347.16mb.com/TavantPoolWeekDay/"


//let kBaseURLString = "http://localhost:8888/HostGinger/TavantPoolServerWeekday_backup/"


//let kBaseURLString = "http://localhost:8888/php/TavantPoolServer/"
//let kBaseURLString = "http://192.168.1.85:8888/php/TavantPoolServer/"
let kCacheSuitName = "FoodForAllCache"


let kCacheEmail = "kCacheEmail"
let kCachePhoneNumber = "kCachePhoneNumber"
//let kCacheDestinationLng = "kCacheDestinationLng"

let kCacheSourceName = "kCacheSourceName"
let kCacheDestinationName = "kCacheDestinationName"
let kCacheTravellerTypeName = "kCacheTravellerTypeName"
let kCacheNumberOfSeatsName = "kCacheNumberOfSeatsName"
let kCacheTripTypeName = "kCacheTripTypeName"
let kCacheIsTripLive = "kCacheIsTripLive"

let kCacheSourceLat = "kCacheSourceLat"
let kCacheSourceLng = "kCacheSourceLng"
let kCacheDestinationLat = "kCacheDestinationLat"
let kCacheDestinationLng = "kCacheDestinationLng"
let kCacheTripDate = "kCacheTripDate"

let kCacheScheduleTypeName = "kCacheScheduleTypeName"



//let kPOSTDataSourceName = "kPOSTDataSourceName"
//let kPOSTDataDestinationName = "kPOSTDataDestinationName"
//let kPOSTDataTravellerTypeName = "kPOSTDataTravellerTypeName"
//let kPOSTDataNumberOfSeatsName = "kPOSTDataNumberOfSeatsName"
//let kPOSTDataTripTypeName = "kPOSTDataTripTypeName"
//let kPOSTDataIsTripLive = "kPOSTDataIsTripLive"
//let kPOSTDataTime = "kPOSTDataTime"
//let kPOSTDataUniqueID = "kPOSTDataUniqueID"
//
//let kPOSTDataSourceLat = "kPOSTDataSourceLat"
//let kPOSTDataSourceLng = "kPOSTDataSourceLng"
//let kPOSTDataDestinationLat = "kPOSTDataDestinationLat"
//let kPOSTDataDestinationLng = "kPOSTDataDestinationLng"





let kPostOfferName = "name"
let kPostOfferItemName = "itemname"
let kPostOfferUniqueID = "uniqueid"
let kPostOfferReportedabuse = "reportedabuse"
let kPostOfferPhonenumber = "phonenumber"

let kPostOfferBookiePhonenumber = "bookiePhonenumber"

let kPostOfferAlternate_phonenumber = "alternate_phonenumber"
let kPostOfferEmail = "email"
let kPostOfferDescription = "description"
let kPostOfferIsTaken = "istaken"
let kPostOfferIsBooked = "isbooked"
let kPostOfferIsPending = "ispending"



let kPostOfferPickAtDate = "pickat_date"
let kPostOfferPickByDate = "pickby_date"
let kPostOfferAddress = "address"
let kPostOfferLatitude = "lat"
let kPostOfferLongitude = "lng"
let kPostOfferServesCount = "serves_count"

let kPostExpiryDate = "expiry_date"
let kPostFoodType = "food_type"

let kPOSTTripPath = "trip_path"
let kPOSTSourceName = "source_name"
let kPOSTDestinationName = "destination_name"
let kPOSTSourceLat = "source_lat"
let kPOSTSourceLng = "source_lng"
let kPOSTDestinationLat = "destination_lat"
let kPOSTDestinationLng = "destination_lng"
let kPOSTTimeLeavingSource = "time_leaving_source"
let kPOSTTimeLeavingDestination = "time_leaving_destination"
let kPOSTNumberOfSeats = "number_of_seats"
let kPOSTTravellerType = "traveller_type"
let kPOSTTripType = "trip_type"
let kPOSTTotalTripTime = "total_trip_time"
let kPOSTTotalTripDistance = "total_trip_distance"
let kPOSTTotalTripVia = "trip_via"


let kPOSTScheduleType = "schedule_type"
let kPOSTDay1Type = "day1"
let kPOSTDay2Type = "day2"
let kPOSTDay3Type = "day3"
let kPOSTDay4Type = "day4"
let kPOSTDay5Type = "day5"
let kPOSTDay6Type = "day6"
let kPOSTDay7Type = "day7"
let kPOSTDateType = "tripDate"




let kPOSTUniqueID = "uniqueid"
let kPOSTPhoneNumber = "phone"
let kPOSTEmail = "email"
let kPOSTIsTripLive = "is_trip_live"

let kPOSTStepRecords = "records"


let kRouteSelected = "kRouteSelected"
let kRouteSelectedDict = "kRouteSelectedDict"

//let kDropboxJSONLink = "https://dl.dropboxusercontent.com/u/35813053/TavantPool/Json/AppConfig.json"
let kDropboxJSONLink = "https://dl.dropboxusercontent.com/u/35813053/StarveNoMore/Json/AppConfig.json"
let kBaseURLString = "http://localhost:8888/HostGinger/sharecare_ideastrom/"
//http://localhost:8888/HostGinger/sharecare_ideastrom/json/product_type.json
//let kBaseURLString = "http://tuffytiffany347.16mb.com/StarveNoMore/"

//let K_TAVANT_BASE_API_URL = "http://engageapp.tavant.com/"
//let K_TAVANT_BASE_API_URL = "http://10.129.146.139/"
//let K_ENGAGE_TAVANT_LOGIN_API_NODE = "login"


class PoolContants: NSObject {
    
    static let sharedInstance = PoolContants()
    var loader = MKNSpinner()
//    static let appPaleGreenColor = UIColor.init(red: (81.0/255.0), green: (229.0/255.0), blue: (199.0/255.0), alpha: 1.0)
static let appPaleGreenColor = UIColor.init(red: (22.0/255.0), green: (157.0/255.0), blue: (118.0/255.0), alpha: 1.0)
    
    func getMainScreenView() -> UIView {
        return  UIApplication.shared.keyWindow!
    }
    
    
    func getMainScreenWidth() -> CGFloat {
        return  UIScreen.main.bounds.size.width
    }
    
    func getFormatedDateFromString(_ tmpTripDateValue : String?) -> Date? {
        let dateformatter : DateFormatter = DateFormatter.init()
       // dateformatter.dateFormat = "yyyy-MMM-dd"
        dateformatter.dateFormat = "MMM dd yyyy HH:mm"
       // dateformatter.dateStyle = .FullStyle
        //if tmpTripDateValue?.isEmpty == false {
            let dateValue : Date? = dateformatter.date(from: tmpTripDateValue!)
            return dateValue!
      //  }
        //return nil
    }
    
    func checkThisTripIsMine(_ tripPhone : String) -> Bool {
       
        let loggedPhNumber = AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        
        if loggedPhNumber == tripPhone {
            return true
            print("\(tripPhone)--\(loggedPhNumber)")
        }
        return false
    }
    
    func getFormatedStringFromDate(_ tmpTripDateValue :Date?) -> String {
        let dateformatter : DateFormatter = DateFormatter.init()
        //dateformatter.dateFormat = "yyyy-MMM-dd HH:mm"
    //    dateformatter.dateFormat = "yyyy-MMM-dd"
        dateformatter.dateFormat = "MMM dd yyyy HH:mm"
        let dateValue : String? = dateformatter.string(from: tmpTripDateValue!)
        return dateValue!
    }
    
//    func getFormatedTimeFromDate(tmpTripDateValue :NSDate?) -> String {
//        let dateformatter : NSDateFormatter = NSDateFormatter.init()
//        //dateformatter.dateFormat = "yyyy-MMM-dd HH:mm"
//        dateformatter.dateFormat = "HH:mm"
//        //dateformatter.dateStyle = .
//        let dateValue : String? = dateformatter.stringFromDate(tmpTripDateValue!)
//        return dateValue!
//    }
    
    func getNameFromEmailStr(_ emailStr : String) -> String {
        var nmes = emailStr.components(separatedBy: ".")
        if nmes.count > 1 {
            return "\(nmes[0]) \(nmes[1])"
        }
        return "\(nmes[0])"
    }
    
    
    func getDateFromUNIXTimeStamp(_ unixtime : Double) -> Date {
        let date = Date(timeIntervalSince1970: unixtime)
        return date
//        let dayTimePeriodFormatter = NSDateFormatter()
//        dayTimePeriodFormatter.dateFormat = "MMM dd yyyy HH:mm"
//        
//        let dateString = dayTimePeriodFormatter.stringFromDate(date)
    }
    
    func show() {
        
        self.loader.outerFillColor = UIColor.red
        self.loader.backgroundColor = UIColor.red
        self.loader.innerFillColor = UIColor.red
        self.loader.innerStrokeColor = UIColor.red
        self.loader.show("Loading...")
        ///MKNSpinner.show("Loading...")
//        self.loader = Loader(frame: CGRectMake(0.0, 0.0, 80.0, 40.0))
//        self.loader!.center = self.getMainScreenView().center
//        
//        self.getMainScreenView().addSubview(self.loader!)
    }
    
    func dismiss() {
        //self.loader!.stopAnimating()
        //self.loader!.removeFromSuperview()
        self.loader.hide()
    }
}
