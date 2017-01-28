//
//  Trip.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/27/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class Trip: NSObject {
    
    var trip_path : String?
    var source_name : String?
    var destination_name : String?
    //change this to date
    var time_leaving_source : String?
    var time_leaving_destination : String?
    var total_trip_time : String?
    
    
    var number_of_seats : Int?
    var traveller_type : Int?
    var trip_type : Int?
    
    var uniqueid_val : Int?
    var phonenumber_val : String?
    var email_val : String?
    var is_trip_live : Int?
    
    var source_lat : Double?
    var source_lng : Double?
    var destination_lat : Double?
    var destination_lng : Double?

    var total_trip_distance : String?
    var trip_via : String?
    
    var tripDateSTR : String?
    var day1_str : Int?
    var day2_str : Int?
    var day3_str : Int?
    var day4_str : Int?
    var day5_str : Int?
    var day6_str : Int?
    var day7_str : Int?
    var schedule_type : Int?
    
  //  var latLongsArray : [LatLongs]?
    
    
    
    
    override init() {
        
    }
    
    convenience init(tripDict : NSDictionary){
       
        self.init()
        self.source_name =  ((tripDict["source_name"]) != nil ) ? tripDict["source_name"]! as? String : "NA"
        self.destination_name =  ((tripDict["destination_name"]) != nil ) ? tripDict["destination_name"]! as? String : "NA"
        
        self.trip_path =  ((tripDict["trip_path"]) != nil ) ? tripDict["trip_path"]! as? String : "NA"
        self.time_leaving_source =  ((tripDict["time_leaving_source"]) != nil ) ? tripDict["time_leaving_source"]! as? String : "NA"
        self.time_leaving_destination =  ((tripDict["time_leaving_destination"]) != nil ) ? tripDict["time_leaving_destination"]! as? String : "NA"
        
     //   print("\(tripDict["is_trip_live"])")
        
        self.total_trip_time =  ((tripDict["total_trip_time"]) != nil ) ? tripDict["total_trip_time"]! as? String : "NA"
        self.number_of_seats =  ((tripDict["number_of_seats"]) != nil ) ? (tripDict["number_of_seats"]! as AnyObject).intValue : 0
        self.traveller_type =  ((tripDict["traveller_type"]) != nil ) ? (tripDict["traveller_type"]! as AnyObject).intValue : 0
        self.trip_type =  ((tripDict["trip_type"]) != nil ) ? (tripDict["trip_type"]! as AnyObject).intValue : 0
        
        self.uniqueid_val =  ((tripDict["uniqueid_val"]) != nil ) ? (tripDict["uniqueid_val"]! as AnyObject).intValue : 0
        self.phonenumber_val =  ((tripDict["phonenumber_val"]) != nil ) ? tripDict["phonenumber_val"]! as? String : "NA"
        self.email_val =  ((tripDict["email_val"]) != nil ) ? tripDict["email_val"]! as? String : "NA"
        self.is_trip_live =  ((tripDict["is_trip_live"]) != nil ) ? (tripDict["is_trip_live"]! as AnyObject).intValue : 0
        
        self.source_lat =  ((tripDict["source_lat"]) != nil ) ? (tripDict["source_lat"]! as AnyObject).doubleValue : 0.0
        self.source_lng =  ((tripDict["source_lng"]) != nil ) ? (tripDict["source_lng"]! as AnyObject).doubleValue : 0.0
        self.destination_lat =  ((tripDict["destination_lat"]) != nil ) ? (tripDict["destination_lat"]! as AnyObject).doubleValue : 0.0
        self.destination_lng =  ((tripDict["destination_lng"]) != nil ) ? (tripDict["destination_lng"]! as AnyObject).doubleValue : 0.0
        
        self.total_trip_distance =  ((tripDict["total_trip_distance"]) != nil ) ? tripDict["total_trip_distance"]! as? String : "NA"
        self.trip_via =  ((tripDict["trip_via"]) != nil ) ? tripDict["trip_via"]! as? String : "NA"
        
        self.schedule_type =  ((tripDict["schedule_type"]) != nil ) ? (tripDict["schedule_type"]! as AnyObject).intValue : 0
        self.day1_str =  ((tripDict["day1"]) != nil ) ? (tripDict["day1"]! as AnyObject).intValue : 0
        self.day2_str =  ((tripDict["day2"]) != nil ) ? (tripDict["day2"]! as AnyObject).intValue : 0
        self.day3_str =  ((tripDict["day3"]) != nil ) ? (tripDict["day3"]! as AnyObject).intValue : 0
        self.day4_str =  ((tripDict["day4"]) != nil ) ? (tripDict["day4"]! as AnyObject).intValue : 0
        self.day5_str =  ((tripDict["day5"]) != nil ) ? (tripDict["day5"]! as AnyObject).intValue : 0
        self.day6_str =  ((tripDict["day6"]) != nil ) ? (tripDict["day6"]! as AnyObject).intValue : 0
        self.day7_str =  ((tripDict["day7"]) != nil ) ? (tripDict["day7"]! as AnyObject).intValue : 0
        
        self.tripDateSTR =  ((tripDict["tripDate"]) != nil ) ? tripDict["tripDate"]! as? String : "NA"
        
    }
    deinit{
       
        
    }

}
