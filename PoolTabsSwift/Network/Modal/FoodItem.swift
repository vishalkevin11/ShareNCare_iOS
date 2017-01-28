//
//  FoodItem.swift
//  HungerFree
//
//  Created by Kevin Vishal on 11/8/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//


    import UIKit
    
    class FoodItem: NSObject {
        
        
//        name,
//        itemname,
//        uniqueid,
//        reportedabuse,
//        phonenumber,
//        alternate_phonenumber,
//        email,
//        description,
//        istaken,
//        isbooked,
//        isbooked,
//        pickat_date,
//        pickby_date,
//        address,
//        lat,
//        lng ,
//        serves_count
        
        
        var name : String?
        var itemname : String?
        var uniqueid : Double?
        var reportedabuse : Int?
        var phonenumber : String?
        var email : String?
        var food_description : String?
        var istaken : Int?
        var uploaddate : String?
        var address : String?
        var lat : Double?
        var lng : Double?
        var is_regular : Int?
        var mon : Int?
        var tue : Int?
        var wed : Int?
        var thur : Int?
        var fri : Int?
        var sat : Int?
        var sun : Int?
        var is_needy : Int?
        
        var alternate_phonenumber : String?
        var bookiePhonenumber : String?
        var image_name : String?
        
        
        var pickat_date : Double?
        var pickby_date : Double?
        
        
        
        var isbooked : Int?
        var ispending : Int?
        
        var serves_count : Int?
        
        
        var expiry_date : Double?
        var foodType : Int?
        
        
        override init() {
            
        }
        
        convenience init(tripDict : NSDictionary){
            
            self.init()
            
            self.name =  ((tripDict["name"]) != nil ) ? tripDict["name"]! as? String : "NA"
            self.itemname =  ((tripDict["itemname"]) != nil ) ? tripDict["itemname"]! as? String : "NA"
            self.uniqueid =  ((tripDict["uniqueid"]) != nil ) ? (tripDict["uniqueid"]! as AnyObject).doubleValue : 0.0
            self.reportedabuse =  ((tripDict["reportedabuse"]) != nil ) ? (tripDict["reportedabuse"]! as AnyObject).intValue : 0
            self.phonenumber =  ((tripDict["phonenumber"]) != nil ) ? tripDict["phonenumber"]! as? String : "NA"
            self.email =  ((tripDict["email"]) != nil ) ? tripDict["email"]! as? String : "NA"
            self.food_description =  ((tripDict["description"]) != nil ) ? tripDict["description"]! as? String : "NA"
            self.istaken =  ((tripDict["istaken"]) != nil ) ? (tripDict["istaken"]! as AnyObject).intValue : 0
            self.uploaddate =  ((tripDict["uploaddate"]) != nil ) ? tripDict["uploaddate"]! as? String : "NA"
            self.address =  ((tripDict["address"]) != nil ) ? tripDict["address"]! as? String : "NA"
            self.lat =  ((tripDict["lat"]) != nil ) ? (tripDict["lat"]! as AnyObject).doubleValue : 0.0
            self.lng =  ((tripDict["lng"]) != nil ) ? (tripDict["lng"]! as AnyObject).doubleValue : 0.0
            self.is_regular =  ((tripDict["is_regular"]) != nil ) ? (tripDict["is_regular"]! as AnyObject).intValue : 0
            self.mon =  ((tripDict["mon"]) != nil ) ? (tripDict["mon"]! as AnyObject).intValue : 0
            self.tue =  ((tripDict["tue"]) != nil ) ? (tripDict["tue"]! as AnyObject).intValue : 0
            self.wed =  ((tripDict["wed"]) != nil ) ? (tripDict["wed"]! as AnyObject).intValue : 0
            self.thur =  ((tripDict["thur"]) != nil ) ? (tripDict["thur"]! as AnyObject).intValue : 0
            self.fri =  ((tripDict["fri"]) != nil ) ? (tripDict["fri"]! as AnyObject).intValue : 0
            self.sat =  ((tripDict["sat"]) != nil ) ? (tripDict["sat"]! as AnyObject).intValue : 0
            self.sun =  ((tripDict["sun"]) != nil ) ? (tripDict["sun"]! as AnyObject).intValue : 0
            self.is_needy = ((tripDict["is_needy"]) != nil ) ? (tripDict["is_needy"]! as AnyObject).intValue : 0
            
            
            
            self.alternate_phonenumber =  ((tripDict["alternate_phonenumber"]) != nil ) ? tripDict["alternate_phonenumber"]! as? String : "NA"
            
            self.bookiePhonenumber =  ((tripDict["bookiePhonenumber"]) != nil ) ? tripDict["bookiePhonenumber"]! as? String : "NA"
            
            
            self.image_name =  ((tripDict["image_name"]) != nil ) ? tripDict["image_name"]! as? String : "NA"
            
            
            self.pickat_date =  ((tripDict["pickat_date"]) != nil ) ? (tripDict["pickat_date"]! as AnyObject).doubleValue : 0.0
            self.pickby_date =  ((tripDict["pickby_date"]) != nil ) ? (tripDict["pickby_date"]! as AnyObject).doubleValue : 0.0
            
            self.serves_count = ((tripDict["serves_count"]) != nil ) ? (tripDict["serves_count"]! as AnyObject).intValue : 0
            self.isbooked = ((tripDict["isbooked"]) != nil ) ? (tripDict["isbooked"]! as AnyObject).intValue : 0
            self.ispending = ((tripDict["ispending"]) != nil ) ? (tripDict["ispending"]! as AnyObject).intValue : 0
            
            self.expiry_date =  ((tripDict["expiry_date"]) != nil ) ? (tripDict["expiry_date"]! as AnyObject).doubleValue : 0.0
            self.foodType = ((tripDict["food_type"]) != nil ) ? (tripDict["food_type"]! as AnyObject).intValue : 0
        }
        deinit{
            
            
        }
        
}

