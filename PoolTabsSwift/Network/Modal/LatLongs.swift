//
//  LatLongs.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/1/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class LatLongs: NSObject {
    
    
    var latValue : Double?
    var longValue : Double?
    var routeIdValue : Int?
    var distanceValue : String?
    var durationValue : String?
    var htmlImstructionValue : String?
    var polylineValue : String?
    
    override init() {
        
    }
    
    convenience init(latlongDict : NSDictionary){
        
        self.init()
        self.durationValue =  ((latlongDict["duration"]) != nil ) ? latlongDict["duration"]! as? String : "NA"
        self.htmlImstructionValue =  ((latlongDict["htmlImstruction"]) != nil ) ? latlongDict["htmlImstruction"]! as? String : "NA"
        
        self.distanceValue =  ((latlongDict["distance"]) != nil ) ? latlongDict["distance"]! as? String : "NA"
        
        self.routeIdValue =  ((latlongDict["routeId"]) != nil ) ? (latlongDict["routeId"]! as AnyObject).intValue : 0
        self.latValue =  ((latlongDict["latitude"]) != nil ) ? (latlongDict["latitude"]! as AnyObject).doubleValue : 0.0
        self.longValue =  ((latlongDict["longitude"]) != nil ) ? (latlongDict["longitude"]! as AnyObject).doubleValue : 0.0
        
        self.polylineValue =  ((latlongDict["polyline"]) != nil ) ? latlongDict["polyline"]! as? String : "NA"
    }
    deinit{
        
        
    }

    
//    distance = "0.3 km";
//    duration = "2 mins";
//    htmlImstruction = "Head west on 20th Main Rd toward 3rd Cross Rd";
//    latitude = "12.9148937";
//    longitude = "77.5882616";
//    polyline = "amymAs}pxM?D?D?B@BBB@BB?@@@?B?F?F?XCj@EE`@EP?PA?`A@~A?|@?~@Bv@?";
//    routeId = 1470225228
}
