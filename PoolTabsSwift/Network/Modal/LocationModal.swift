//
//  LocationModal.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/30/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class LocationModal: NSObject {
    
    var placeName : String? = ""
    var formatedAddress : String? = ""
    var longitude_val : Double? = 0.0
    var latitude_val : Double? = 0.0
    var placeID : String? = ""

    
    override init() {
        
    }
    
    convenience init(locationDict : NSDictionary){
        
        self.init()
        self.placeName =  ((locationDict["name"]) != nil ) ? locationDict["name"]! as? String : ""
        self.formatedAddress =  ((locationDict["formattedAddress"]) != nil ) ? locationDict["formattedAddress"]! as? String : ""
        
        self.placeID =  ((locationDict["placeID"]) != nil ) ? locationDict["placeID"]! as? String : ""
        
        
        self.longitude_val =  ((locationDict["longitude"]) != nil ) ? (locationDict["longitude"]! as AnyObject).doubleValue : 0.0
        self.latitude_val =  ((locationDict["latitude"]) != nil ) ? (locationDict["latitude"]! as AnyObject).doubleValue : 0.0
        
    }
    deinit{
        
        
    }

}
