//
//  FilterPopupViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/28/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class FilterPopupViewController: UIViewController {
    
    var filterDictionary : NSMutableDictionary?
    
    var sourceLat       : Double? = 0.0
    var sourceLng       : Double? = 0.0
    var destinationLat  : Double? = 0.0
    var destinationLng  : Double? = 0.0
    
    var sourceName      : String? = ""
    var destinationName : String? = ""
    
    var numberOfSeats   : Int? = 0
    var travellerType   : Int? = 0
    var tripType        : Int? = 0
    

    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var btnDestination: UIButton!
    
    @IBOutlet weak var btnNoOFSeats: UIButton!
    @IBOutlet weak var segmentTripType: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        
        filterDictionary?.setObject(cacheDefaults.object(forKey: kCacheSourceName)!, forKey: "source_name" as NSCopying)
        filterDictionary?.setValue(self.sourceLat!, forKey: "sourceLat")
        filterDictionary?.setValue(self.sourceLng!, forKey: "sourceLng")
        
        filterDictionary?.setObject(cacheDefaults.object(forKey: kCacheDestinationName)!, forKey: "destination_name" as NSCopying)
        
        filterDictionary?.setValue(cacheDefaults.value(forKey: kCacheNumberOfSeatsName)!, forKey: "number_of_seats")
        filterDictionary?.setValue(cacheDefaults.value(forKey: kCacheTravellerTypeName)!, forKey: "traveller_type")
        filterDictionary?.setValue(cacheDefaults.value(forKey: kCacheTripTypeName)!, forKey: "trip_type")
        filterDictionary?.setValue(cacheDefaults.value(forKey: kCacheIsTripLive)!, forKey: "is_trip_live")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     
     
     var filterDictionary : NSMutableDictionary?
     
     let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
     
     filterDictionary?.setObject(cacheDefaults.objectForKey(kCacheSourceName)!, forKey: "source_name")
     filterDictionary?.setObject(cacheDefaults.objectForKey(kCacheSourceName)!, forKey: "destination_name")
     
     filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "number_of_seats")
     filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "traveller_type")
     filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "trip_type")
     filterDictionary?.setValue(cacheDefaults.valueForKey(kCacheSourceName)!, forKey: "is_trip_live")
     
     return filterDictionary!
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK:  Button & Segment Action
    @IBAction func changeSource(_ sender: AnyObject) {
        filterDictionary?.setObject(self.sourceName!, forKey: "source_name" as NSCopying)
        filterDictionary?.setValue(self.sourceLat!, forKey: "sourceLat")
        filterDictionary?.setValue(self.sourceLng!, forKey: "sourceLng")
        
    }
    
    @IBAction func changeDestinatiom(_ sender: AnyObject) {
        filterDictionary?.setObject(self.destinationName!, forKey: "destination_name" as NSCopying)
        filterDictionary?.setValue(self.destinationLat!, forKey: "destinationLat")
        filterDictionary?.setValue(self.destinationLng!, forKey: "destinationLng")
    }
    
    @IBAction func changeNumberOfSeats(_ sender: AnyObject) {
        filterDictionary?.setValue(self.numberOfSeats!, forKey: "number_of_seats")
    }
    
    @IBAction func routeTypeChaged(_ sender: AnyObject) {
        filterDictionary?.setValue(self.tripType!, forKey: "trip_type")
    }
    
    @IBAction func filter(_ sender: AnyObject) {
        
        
        AppCacheManager.sharedInstance.saveFilterDetails(filterDictionary!)
        
        //send request to server to refetch
    }
    
    
    @IBAction func resetFilter(_ sender: AnyObject) {
        
        AppCacheManager.sharedInstance.resetFilter()
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
