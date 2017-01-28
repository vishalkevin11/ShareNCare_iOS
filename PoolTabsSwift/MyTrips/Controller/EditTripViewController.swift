//
//  EditTripViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/4/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
//import PopupViewController
//import KRProgressHUD


enum EditPlaceType {
    case sourceType
    case destinationType
}


enum EditLeaveDateType {
    case arrivingTYpe
    case departureType
}

class EditTripViewController: UITableViewController, CLLocationManagerDelegate {
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    var currentEditingTrip : FoodItem = FoodItem()
    var currentEditingLatLongsArr : [LatLongs] = []
    
    var selectedRouteObj  : PXGoogleDirectionsRoute?
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    
    var currentId: Int? = 0
    
    var googleMapView: GMSMapView!
    
    var selectedPlaceEntry = EditPlaceType.sourceType
    var seatsArray = [1,2,3,4,5,6,7,8]
    
    var selectedDate :Date? = nil
    
    var  sourceLocation : LocationModal? = LocationModal()
    var  destinationLocation : LocationModal? = LocationModal()
    
    var  numberOfSeats: Int? = 0
    var  tripTypeValue: Int? = 0
    var  travellerTypeValue: Int? = 0
    var  scheduleTypeValue: Int? = 0
    
    var  day1Value: Int? = 0
    var  day2Value: Int? = 0
    var  day3Value: Int? = 0
    var  day4Value: Int? = 0
    var  day5Value: Int? = 0
    var  day6Value: Int? = 0
    var  day7Value: Int? = 0
    
    
    var  strTime: String? = ""
    var  strRoute: String? = ""
    
    var  strTotalTime: String? = ""
    var  strTotalDistance: String? = ""
    var  strRouteVia: String? = ""
    
    var  strDepartTime: String? = ""
    var  strArrivalTime: String? = ""
    
    var pickerTypeForShowing : DatePickerType = datePikerType
    var leaveDateType : EditLeaveDateType = EditLeaveDateType.arrivingTYpe
    
    @IBOutlet weak var viewWeekDay: UIView!
    @IBOutlet weak var pickerWeekDay: WeekDaysSegmentedControl!
    @IBOutlet weak var widthDepartureConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthArrivalConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTimeOuter: UIView!
    @IBOutlet weak var lblTimeArrive: UILabel!
    @IBOutlet weak var lblTimeDepart: UILabel!
    
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var labelNumberOfSeats: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelRoute: UILabel!
    @IBOutlet weak var travellerSegment: UISegmentedControl!
    @IBOutlet weak var tripSegment: UISegmentedControl!
    @IBOutlet weak var weekDaySegment: UISegmentedControl!
    
    
    // MARK: Deinit
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
    }
    
    
    
    // MARK: View Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.pickerWeekDay.showSmallText = false
        
        self.latitude = 0.0
        self.longitude = 0.0
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //   seatsArray = [1,2,3,4,5,6,7,8]
        
        //  self.selectedDate = NSDate.init()
        
//        self.labelSource.text = "J p nagar 2nd phase"
//        self.labelDestination.text = "koramangala 5th block"
        
        self.initialize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditTripViewController.routesSelected(_:)), name: NSNotification.Name(rawValue: kRouteSelected), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(EditTripViewController.dateandTimeReturned), name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Edit Trip"
    }
    
    // MARK: Initializers
    
    
    func initialize() -> Void {
        
        
        self.pickerWeekDay.borderColor = PoolContants.appPaleGreenColor
        self.pickerWeekDay.textColor = PoolContants.appPaleGreenColor
        
//        if (self.currentEditingTrip.schedule_type! == 1) {
//            self.viewWeekDay.hidden = true
//            self.scheduleTypeValue = 1
//        }
//        else {
//            self.viewWeekDay.hidden = false
//            self.scheduleTypeValue = 2
//        }
//        
//        
//        self.tripTypeValue = self.currentEditingTrip.trip_type!
        
        
        if (self.tripTypeValue == 2) {
            self.tripTypeValue = 2
            self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
            self.widthDepartureConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
            
        }
        else {
            self.tripTypeValue = 1
            self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()
            self.widthDepartureConstraint.constant = 0.0
            
        }
        //self.tripTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
        self.viewTimeOuter.layoutSubviews()
        
        
//        
//        if ((self.currentEditingTrip.tripDateSTR!.isEmpty == false) && (self.currentEditingTrip.tripDateSTR != nil)) {
//            let dateValue : NSDate? = PoolContants.sharedInstance.getFormatedDateFromString(self.currentEditingTrip.tripDateSTR!) //dateformatter.dateFromString(tmpTripDateValue!)
//            self.selectedDate = dateValue
//            self.strTime = self.currentEditingTrip.tripDateSTR!
//            self.labelTime.text  = self.strTime
//        }

        
       // let dateTimeValue : String =  PoolContants.sharedInstance.getFormatedTimeFromDate(self.selectedDate)
        
        
        
        
   //     self.strArrivalTime = self.currentEditingTrip.time_leaving_source!
        self.lblTimeArrive.text = self.strArrivalTime!
        
       // let calendar = NSCalendar.currentCalendar()
     //   let newDepartdate = calendar.dateByAddingUnit(.Minute, value: 30, toDate: self.selectedDate!, options: [])
        
        
       // self.strDepartTime = self.currentEditingTrip.time_leaving_destination!
        //PoolContants.sharedInstance.getFormatedTimeFromDate(newDepartdate)
        self.lblTimeDepart.text = self.strDepartTime!
        
        
        
//        
//        self.day1Value = self.currentEditingTrip.day1_str!
//        self.day2Value = self.currentEditingTrip.day2_str!
//        self.day3Value = self.currentEditingTrip.day3_str!
//        self.day4Value = self.currentEditingTrip.day4_str!
//        self.day5Value = self.currentEditingTrip.day5_str!
//        self.day6Value = self.currentEditingTrip.day6_str!
//        self.day7Value = self.currentEditingTrip.day7_str!
//        
//        self.pickerWeekDay.daysString = "\(self.day1Value!)\(self.day2Value!)\(self.day3Value!)\(self.day4Value!)\(self.day5Value!)\(self.day6Value!)\(self.day7Value!)"
//        
//        
//        print("\(self.pickerWeekDay.daysString)")
//        self.currentId = self.currentEditingTrip.uniqueid_val!
//        
//        self.labelSource.text = self.currentEditingTrip.source_name!
//        self.labelDestination.text = self.currentEditingTrip.destination_name!
//        
//        self.numberOfSeats = self.currentEditingTrip.number_of_seats!
//        self.travellerTypeValue = self.currentEditingTrip.traveller_type!
//        
//        
//        self.labelNumberOfSeats.text = "\(self.numberOfSeats!)";
//       
//        self.labelRoute.text = "Via.\(self.currentEditingTrip.trip_via!), Distance : \(self.currentEditingTrip.total_trip_distance!), Time : \(self.currentEditingTrip.total_trip_time!)"
//        
//        
        
        
//        let dateValue : NSDate? = PoolContants.sharedInstance.getFormatedDateFromString(self.currentEditingTrip.time_leaving_source!) //dateformatter.dateFromString(self.currentEditingTrip.time_leaving_source!)!
//        self.selectedDate = dateValue!
        
        
        
//        let tarvellerIndexSelected = self.currentEditingTrip.traveller_type!
//        if tarvellerIndexSelected == 1 {
//            self.travellerSegment.selectedSegmentIndex = 0
//        }
//        else {
//            self.travellerSegment.selectedSegmentIndex = 1
//        }
//        
//        let tripIndexSelected = self.currentEditingTrip.trip_type!
//        if tripIndexSelected == 1 {
//            self.tripSegment.selectedSegmentIndex = 0
//        }
//        else {
//            self.tripSegment.selectedSegmentIndex = 1
//        }
        
        
//        let weekdaySelected = self.currentEditingTrip.schedule_type!
//        if weekdaySelected == 1 {
//            self.weekDaySegment.selectedSegmentIndex = 0
//        }
//        else {
//            self.weekDaySegment.selectedSegmentIndex = 1
//        }
//        
      
//        self.sourceLocation!.formatedAddress = self.currentEditingTrip.source_name!
//        self.destinationLocation!.formatedAddress = self.currentEditingTrip.destination_name!
//        self.sourceLocation!.latitude_val = self.currentEditingTrip.source_lat!
//        self.sourceLocation!.longitude_val = self.currentEditingTrip.source_lng!
//        self.destinationLocation!.latitude_val = self.currentEditingTrip.destination_lat!
//        self.destinationLocation!.longitude_val = self.currentEditingTrip.destination_lng!
//        
//        self.strTime = self.currentEditingTrip.tripDateSTR!
//        
//        self.numberOfSeats = self.currentEditingTrip.number_of_seats!
//        self.tripTypeValue = self.currentEditingTrip.trip_type!
//        self.travellerTypeValue = self.currentEditingTrip.traveller_type!
//        self.strTotalTime = self.currentEditingTrip.total_trip_time!
//        self.strTotalDistance = self.currentEditingTrip.total_trip_distance!
//        self.strRouteVia = self.currentEditingTrip.trip_via!
//        
//        self.strArrivalTime = self.currentEditingTrip.time_leaving_source!
//        self.strDepartTime = self.currentEditingTrip.time_leaving_destination!
    }
    

    
    func generateTheLatLongsDictionary(_ latlong : LatLongs) -> NSMutableDictionary {
        
       
            
            
            let placeDict : NSMutableDictionary = NSMutableDictionary()
            
       //     let polyline = GMSPolyline(path: step.path)
            
            
            
            placeDict.setObject(latlong.htmlImstructionValue!, forKey: "rawInstructions" as NSCopying)
            placeDict.setObject(latlong.distanceValue!, forKey: "distance" as NSCopying)
            placeDict.setObject(latlong.durationValue!, forKey: "duration" as NSCopying)
            
            placeDict.setValue(latlong.latValue!, forKey: "latitude")
            placeDict.setValue(latlong.longValue!, forKey: "longitude")
            placeDict.setValue(latlong.routeIdValue!, forKey: "routeId")
            
            
            // Delete the latloongs corresponding to this unique ID and upadet the trip
            
            
            placeDict.setObject(latlong.polylineValue!, forKey: "polyline" as NSCopying)
            
            return placeDict
      //  }
    }
    
    // MARK: POST Data
    
    
    func createPOSTDictionary() -> Void {
        
        
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
        postDictionary.setObject(self.sourceLocation!.formatedAddress!, forKey: kPOSTSourceName as NSCopying)
        postDictionary.setObject(self.destinationLocation!.formatedAddress!, forKey: kPOSTDestinationName as NSCopying)
        
        postDictionary.setValue(self.sourceLocation!.latitude_val!, forKey: kPOSTSourceLat)
        postDictionary.setValue(self.sourceLocation!.longitude_val!, forKey: kPOSTSourceLng)
        postDictionary.setValue(self.destinationLocation!.latitude_val!, forKey: kPOSTDestinationLat)
        postDictionary.setValue(self.destinationLocation!.longitude_val!, forKey: kPOSTDestinationLng)
        
//        postDictionary.setObject(self.strTime!, forKey: kPOSTTimeLeavingSource)
//        postDictionary.setObject(self.strTime!, forKey: kPOSTTimeLeavingDestination)
//        

        postDictionary.setObject("\(self.strArrivalTime!)", forKey: kPOSTTimeLeavingSource as NSCopying)
        postDictionary.setObject("\(self.strDepartTime!)", forKey: kPOSTTimeLeavingDestination as NSCopying)
        postDictionary.setObject("\(self.strTime!)", forKey: kPOSTDateType as NSCopying)

        
        postDictionary.setValue(self.numberOfSeats!, forKey: kPOSTNumberOfSeats)
        postDictionary.setValue(self.tripTypeValue!, forKey: kPOSTTripType)
        postDictionary.setValue(self.travellerTypeValue!, forKey: kPOSTTravellerType)
        
        
        
        
        
        postDictionary.setObject("\(self.strTotalTime!)", forKey: kPOSTTotalTripTime as NSCopying)
        postDictionary.setObject("\(self.strTotalDistance!)", forKey: kPOSTTotalTripDistance as NSCopying)
        postDictionary.setObject("\(self.strRouteVia!)", forKey: kPOSTTotalTripVia as NSCopying)
        
        
        //let unixTimeStamp = NSDate().timeIntervalSince1970
        
        
        //Main Gobbu upini mul,
        postDictionary.setValue(self.currentId!, forKey: kPOSTUniqueID)
       
        
        postDictionary.setValue(1, forKey: kPOSTIsTripLive)
        
        
        
        postDictionary.setValue(self.scheduleTypeValue!, forKey: kPOSTScheduleType)
        postDictionary.setValue(self.day1Value!, forKey: kPOSTDay1Type)
        postDictionary.setValue(self.day2Value!, forKey: kPOSTDay2Type)
        postDictionary.setValue(self.day3Value!, forKey: kPOSTDay3Type)
        postDictionary.setValue(self.day4Value!, forKey: kPOSTDay4Type)
        postDictionary.setValue(self.day5Value!, forKey: kPOSTDay5Type)
        postDictionary.setValue(self.day6Value!, forKey: kPOSTDay6Type)
        postDictionary.setValue(self.day7Value!, forKey: kPOSTDay7Type)

        
      
      //  let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
        
    
        
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserEmail(), forKey: kPOSTEmail as NSCopying)
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPOSTPhoneNumber as NSCopying)
        
     
        
        //routes
        
        
        
        //check if user edited to use new route, or use our existing route pushed from dB
         let stepsArray : NSMutableArray = NSMutableArray()
        
        if  stepsArray.count > 0 {
            stepsArray.removeAllObjects()
        }
        
        if selectedRouteObj != nil {
            
            if selectedRouteObj!.legs.count > 0 {
                let leg = selectedRouteObj!.legs[0]
                
                for  step in leg.steps {
                    
                    
                    let placeDict : NSMutableDictionary = NSMutableDictionary()
                    
                    let polyline = GMSPolyline(path: step.path)
                    
                    let dist = step.distance?.description, dur = step.duration?.description
                    
                    
                    placeDict.setObject(step.rawInstructions!, forKey: "rawInstructions" as NSCopying)
                    placeDict.setObject("\(dist!)", forKey: "distance" as NSCopying)
                    placeDict.setObject("\(dur!)", forKey: "duration" as NSCopying)
                    
                    placeDict.setValue(step.startLocation?.latitude, forKey: "latitude")
                    placeDict.setValue(step.startLocation?.longitude, forKey: "longitude")
                    placeDict.setValue(self.currentId!, forKey: "routeId")
                    
                    
                    // Delete the latloongs corresponding to this unique ID and upadet the trip
                    
                    
                    let pathPoly : String? = polyline.path?.encodedPath()
                    placeDict.setObject("\(pathPoly!)", forKey: "polyline" as NSCopying)
                    
                    //Since they give two value, we take only one
                    
                    //                placeDict.setValue(step.startLocation?.latitude, forKey: "startLat")
                    //                placeDict.setValue(step.startLocation?.longitude, forKey: "startLng")
                    //   placeDict.setValue(step.endLocation?.latitude, forKey: "EndLat")
                    //   placeDict.setValue(step.endLocation?.longitude, forKey: "EndLng")
                    
                    
                    print("\(step.rawInstructions!)")
                    
                    stepsArray.add(placeDict)
                    
                }
                //  print("\(stepsArray.description)")
            }

        }
        else {
            
            
             for  latlong : LatLongs in self.currentEditingLatLongsArr {
                
                let placeDict1  = self.generateTheLatLongsDictionary(latlong)
                 stepsArray.add(placeDict1)
            }
            
        }
        
        
        
        postDictionary.setObject(stepsArray, forKey: kPOSTStepRecords as NSCopying)
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key  in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                swiftDict[stringKey] = keyValue as AnyObject??
            }
        }
        
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        
        myTripsNetworkManager.updateTrip(swiftDict as (Dictionary<String, AnyObject>)?) { (responseTrips : AnyObject?, error : NSError?) in
            
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
          
            var alertMess  = ""
            var alertTitle  = ""
            
            if (error == nil) && (responseTrips != nil) {
                
                 PoolContants.sharedInstance.dismiss()
                
                let tripscreted = responseTrips as! String
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                alertTitle = ""
                alertMess = tripscreted
                //                }
            }
            else {
                alertTitle = ""
                alertMess = (error?.localizedDescription)!
            }
            
            let alert = PopupViewController(title: alertTitle, message: alertMess)
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    

    
        // MARK: Notifications
    //date
    func dateandTimeReturned(_ notif : Notification) -> Void {
        
        let userInfoDictionary : NSDictionary? = notif.object as? NSDictionary
        let pickerSelectedDate : Date?  = (userInfoDictionary!["selectedDate"] as? Date)!
        let pickerSelectedDisplayValue : String?  = (userInfoDictionary!["selectedDisplayValue"] as? String)!
        let pickerSelectedValue : String?  = (userInfoDictionary!["selectedValue"] as? String)!
        
        self.selectedDate = pickerSelectedDate
        
        if (pickerTypeForShowing == datePikerType) {
            
            let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
            self.strTime = dateValue
            self.labelTime.text = dateValue
            
        }
        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .arrivingTYpe)) {
            self.lblTimeArrive.text = pickerSelectedDisplayValue
            self.strArrivalTime = pickerSelectedValue
        }
        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .departureType)) {
            self.lblTimeDepart.text = pickerSelectedDisplayValue
            self.strDepartTime = pickerSelectedValue
        }
    }
    //route
    func routesSelected(_ notification:Notification) -> Void {
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.dismiss()
        }
        
        let userInfoDictionary : NSDictionary = notification.userInfo as! NSDictionary
        
        //        var selectedRouteObj  =  ((userInfoDictionary[kRouteSelectedDict]!) != nil ) ? userInfoDictionary[kRouteSelectedDict]! as! PXGoogleDirectionsRoute : nil
        //
        selectedRouteObj  =   userInfoDictionary[kRouteSelectedDict]! as? PXGoogleDirectionsRoute
        
        // self.sel
        
        
        var summaryStr : String? = ""
        
        
        if selectedRouteObj!.legs.count > 0 {
            let leg = selectedRouteObj!.legs[0]
            if let dist = leg.distance?.description, let dur = leg.duration?.description {
                
                self.strTotalDistance = dist
                self.strTotalTime = dur
                self.strRouteVia = selectedRouteObj!.summary!
                
                summaryStr =  "via .\(selectedRouteObj!.summary!), (\(dist), \(dur))"
            }
            
            
            self.labelRoute.text = summaryStr!
            
            
            
            //add addfress for nil
            
            if (leg.startAddress) != nil {
                
                if (self.sourceLocation!.formatedAddress?.isEmpty == true) {
                    self.sourceLocation!.formatedAddress = leg.startAddress
                    self.labelSource.text = leg.startAddress
                }
            }
            
            if (leg.endAddress) != nil {
                
                if (self.destinationLocation!.formatedAddress?.isEmpty == true) {
                    self.destinationLocation!.formatedAddress = leg.endAddress
                    self.labelDestination.text = leg.endAddress
                }
            }

        }
    
        
    }
    
    
    // MARK: tableView Methods
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1) {
            if (indexPath.row == 3) {
                return 114.0
            }
            else if (indexPath.row == 4) {
                return 80.0
            }
            return 60.0
        }
        else if (indexPath.section == 0) {
            return 74.0
        }
     
        return 0.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section==1 {
            return self.footerView
        }
        return super.tableView(tableView, viewForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section==1 {
            return 60.0
        }
        return 0.0
    }
    
    // MARK: TableView Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.searchSource()
                break
            case 1:
                self.searchDesination()
                break
            case 2:
                self.searchRoute()
                break
            default: break
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.showSeatsPicker()
                break
//            case 3:
//                self.showDatePicker()
//                break
            default: break
            }
        }
        
        
        
    }
    // MARK: Validate
    
    func validateAllEntries() -> Bool {
        
        //source
        
        if ((self.labelSource.text?.isEmpty == true) || (self.labelSource.text == "Address :") || (self.labelSource.text == "")) {
            let alert = PopupViewController(title: "Missing Origin", message: "Please Enter a valid origin.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if ((self.labelDestination.text?.isEmpty == true) || (self.labelDestination.text == "Enter Trip Destination") || (self.labelDestination.text == "")) {
            let alert = PopupViewController(title: "Missing Destination", message: "Please Enter a valid destination.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if ((self.labelRoute.text?.isEmpty == true) || (self.labelRoute.text == "")) {
            let alert = PopupViewController(title: "", message: "Please select a valid route.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // MARK:  Actions
    
    func searchSource() -> Void {
        selectedPlaceEntry = EditPlaceType.sourceType
        self.openLocationPicker()
    }
    
    func searchDesination() -> Void {
        selectedPlaceEntry = EditPlaceType.destinationType
        self.openLocationPicker()
    }
    
    func searchRoute() -> Void {
        
        self.fetchRoutes()
    }
    
    @IBAction func showDatePicker(_ sender: AnyObject) {
        
        self.showDate()
    }
    
    
    func showDate() -> Void {
        
//        let hsdpvc : HSDatePickerViewController = HSDatePickerViewController.init()
//        hsdpvc.delegate = self
//        if self.selectedDate != nil {
//            hsdpvc.date = self.selectedDate;
//        }
//        dispatch_async(dispatch_get_main_queue()) {
//            UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(hsdpvc, animated: true, completion: nil)
//        }
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = datePikerType
        DispatchQueue.main.async {
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: datePikerType, with: Date())
        }

    }
    
    
    @IBAction func showArrivingTime(_ sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = timePikerType
        self.leaveDateType = .arrivingTYpe
        DispatchQueue.main.async {
            
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: timePikerType, with: Date())
        }
        
    }
    
    @IBAction func showDepartingTime(_ sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = timePikerType
        self.leaveDateType = .departureType
        DispatchQueue.main.async {
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: timePikerType, with: Date())
        }
    }
    
    @IBAction func showWeedayPicker(_ sender: AnyObject) {
        let segment : UISegmentedControl = sender as! UISegmentedControl
        if (segment.selectedSegmentIndex == 0) {
            self.viewWeekDay.isHidden = true
            self.scheduleTypeValue = 1
        }
        else {
            self.viewWeekDay.isHidden = false
            self.scheduleTypeValue = 2
        }
    }
    
    func showSeatsPicker() -> Void {
        
        let picker = CZPickerView(headerTitle: "Number of seats", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    
    @IBAction func EditTrip(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
        for (index, element) in pickerWeekDay.daysString.characters.enumerated() {
            //if element == "1" {
            // indexes.append(index)
            print("index \(index) value \(element)")
            
            switch index {
            case 0:
                self.day1Value = Int("\(element)")
            case 1:
                self.day2Value = Int("\(element)")
            case 2:
                self.day3Value = Int("\(element)")
            case 3:
                self.day4Value = Int("\(element)")
            case 4:
                self.day5Value = Int("\(element)")
            case 5:
                self.day6Value = Int("\(element)")
            case 6:
                self.day7Value = Int("\(element)")
            default:
                break
            }
            //}
        }
        
        if (self.validateAllEntries()) {
            self.createPOSTDictionary()
        }
    }
    
   
    @IBAction func tripTypeSelected(_ sender: AnyObject) {
        
        let segment : UISegmentedControl = sender as! UISegmentedControl
        //self.tripTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
        if (segment.selectedSegmentIndex == 1) {
            self.tripTypeValue = 2
            self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
            self.widthDepartureConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
            
        }
        else {
            self.tripTypeValue = 1
            self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()
            self.widthDepartureConstraint.constant = 0.0
            
        }
        //self.tripTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
        self.viewTimeOuter.layoutIfNeeded()
        
    }
    
    
    @IBAction func travellerTypeSelected(_ sender: AnyObject) {
        
        let segment : UISegmentedControl = sender as! UISegmentedControl
        self.travellerTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
    }
    
    
    // MARK: Functions for fetching location
    func openLocationPicker() -> Void {
        
        let center = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        self.placePicker = GMSPlacePicker(config: config)
        
        // 2
         //placePicker.pickPlace { (place: GMSPlace?, error: NSError?) -> Void in
          self.placePicker.pickPlace { (place: GMSPlace?, error: Error?) -> Void in  
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            // 3
            if let place = place {
                //let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
                //let marker = GMSMarker(position: coordinates)
                //ENter the place you selected
                
                let placeDict : NSMutableDictionary = NSMutableDictionary()
                
                
                let fullPlace : String? = ((place.formattedAddress) != nil) ? place.formattedAddress! : ""
                placeDict.setObject(place.name, forKey: "name" as NSCopying)
                placeDict.setObject(fullPlace!, forKey: "formattedAddress" as NSCopying)
                placeDict.setObject(place.placeID, forKey: "placeID" as NSCopying)
                
                
                
                
                placeDict.setValue(place.coordinate.latitude, forKey: "latitude")
                placeDict.setValue(place.coordinate.longitude, forKey: "longitude")
                
                
                //if self.selectedPlaceEntry == PlaceType.sourceType {
                    
                    self.sourceLocation  = LocationModal.init(locationDict: placeDict)
                    self.labelSource.text = place.name
                    self.labelRoute.text = ""
//                }
//                else {
//                    self.destinationLocation  = LocationModal.init(locationDict: placeDict)
//                    self.labelDestination.text = place.name
//                    self.labelRoute.text = ""
//                }
                
            } else {
                print("No place was selected")
            }
        }
    }
    
    //MARK: Location protocol
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        // 1
        let location:CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        
        print("An error occurred while tracking location changes : \(error.localizedDescription)")
    }
    
    // MARK: Show Routes
    
    fileprivate var directionsAPI: PXGoogleDirections {
        return (UIApplication.shared.delegate as! AppDelegate).directionsAPI
    }
    
    
    func fetchRoutes() -> Void {
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        directionsAPI.delegate = self
//        directionsAPI.from = PXLocation.NamedLocation(self.sourceLocation.formatedAddress!)
//        directionsAPI.to = PXLocation.NamedLocation(self.destinationLocation.formatedAddress!)
        if self.sourceLocation!.formatedAddress!.isEmpty {
            directionsAPI.from = PXLocation.coordinateLocation(CLLocationCoordinate2D.init(latitude: self.sourceLocation!.latitude_val!, longitude: self.sourceLocation!.longitude_val!))
        }
        else {
            directionsAPI.from = PXLocation.namedLocation(self.sourceLocation!.formatedAddress!)
        }
        
        if self.destinationLocation!.formatedAddress!.isEmpty {
            directionsAPI.to = PXLocation.coordinateLocation(CLLocationCoordinate2D.init(latitude: self.destinationLocation!.latitude_val!, longitude: self.destinationLocation!.longitude_val!))
        }
        else {
            directionsAPI.to = PXLocation.namedLocation(self.destinationLocation!.formatedAddress!)
        }

        
        directionsAPI.transitRoutingPreference = nil
        //directionsAPI.transitRoutingPreference = transitRoutingPreferenceFromField()
        directionsAPI.units = nil
        directionsAPI.alternatives = true
        directionsAPI.transitModes = Set()
        directionsAPI.featuresToAvoid = Set()
        directionsAPI.departureTime = nil
        directionsAPI.arrivalTime = nil
        directionsAPI.waypoints = [PXLocation]()
        directionsAPI.optimizeWaypoints = nil
        directionsAPI.language = nil
        /*
         directionsAPI.mode = modeFromField()
         if advancedSwitch.on {
         directionsAPI.transitRoutingPreference = transitRoutingPreferenceFromField()
         directionsAPI.units = unitFromField()
         directionsAPI.alternatives = true
         directionsAPI.transitModes = Set()
         if busSwitch.on {
         directionsAPI.transitModes.insert(.Bus)
         }
         if subwaySwitch.on {
         directionsAPI.transitModes.insert(.Subway)
         }
         if trainSwitch.on {
         directionsAPI.transitModes.insert(.Train)
         }
         if tramSwitch.on {
         directionsAPI.transitModes.insert(.Tram)
         }
         if railSwitch.on {
         directionsAPI.transitModes.insert(.Rail)
         }
         directionsAPI.featuresToAvoid = Set()
         if avoidTollsSwitch.on {
         directionsAPI.featuresToAvoid.insert(.Tolls)
         }
         if avoidHighwaysSwitch.on {
         directionsAPI.featuresToAvoid.insert(.Highways)
         }
         if avoidFerriesSwitch.on {
         directionsAPI.featuresToAvoid.insert(.Ferries)
         }
         switch startArriveField.selectedSegmentIndex {
         case 0:
         directionsAPI.departureTime = .Now
         directionsAPI.arrivalTime = nil
         case 1:
         if let saDate = startArriveDate {
         directionsAPI.departureTime = PXTime.timeFromDate(saDate)
         directionsAPI.arrivalTime = nil
         } else {
         return
         }
         case 2:
         if let saDate = startArriveDate {
         directionsAPI.departureTime = nil
         directionsAPI.arrivalTime = PXTime.timeFromDate(saDate)
         } else {
         return
         }
         default:
         break
         }
         directionsAPI.waypoints = waypoints
         directionsAPI.optimizeWaypoints = optimizeWaypointsSwitch.on
         directionsAPI.language = languageFromField()
         } else {
         directionsAPI.transitRoutingPreference = nil
         directionsAPI.units = nil
         directionsAPI.alternatives = nil
         directionsAPI.transitModes = Set()
         directionsAPI.featuresToAvoid = Set()
         directionsAPI.departureTime = nil
         directionsAPI.arrivalTime = nil
         directionsAPI.waypoints = [PXLocation]()
         directionsAPI.optimizeWaypoints = nil
         directionsAPI.language = nil
         }
         */
        // directionsAPI.region = "fr" // Feature not demonstrated in this sample app
        directionsAPI.calculateDirections { (response) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                switch response {
                case let .error(_, error):
                    DispatchQueue.main.async {
                        PoolContants.sharedInstance.dismiss()
                    }
                    
                    let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case let .success(request, routes):
                    
                    DispatchQueue.main.async {
                        PoolContants.sharedInstance.dismiss()
                    }
                    
                    let routesStoryBoard = UIStoryboard.init(name: "RoutesStoryboard", bundle: Bundle.main)
                    
                    if let rvc = routesStoryBoard.instantiateViewController(withIdentifier: "PoolRoutesViewController") as? PoolRoutesViewController {
                        rvc.request = request
                        rvc.results = routes
                        //self.navigationController?.pushViewController(rvc, animated: true)
                        self.present(rvc, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
}

extension EditTripViewController: PXGoogleDirectionsDelegate {
    func googleDirectionsWillSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
      //  NSLog("\(requestURL.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: Data) {
        NSLog("googleDirections:didReceiveRawDataFromAPI:")
        NSLog(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String)
    }
    
    func googleDirectionsRequestDidFail(_ googleDirections: PXGoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
        NSLog("googleDirections:didReceiveResponseFromAPI:")
        NSLog("Got \(apiResponse.count) routes")
        for i in 0 ..< apiResponse.count {
            NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
        }
    }
}



extension EditTripViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return seatsArray.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return String("\(seatsArray[row])")
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print("PRINT THUS\(seatsArray[row])")
        self.numberOfSeats = seatsArray[row]
        self.labelNumberOfSeats.text = "\(seatsArray[row])"
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(seatsArray[row])
            }
        }
    }
}

//extension EditTripViewController : HSDatePickerViewControllerDelegate {
//    
//    func hsDatePickerPickedDate(date: NSDate!) {
//        
//        let dateValue : String = PoolContants.sharedInstance.getFormatedStringFromDate(date)
//        self.selectedDate = date
//        self.strTime = dateValue
//        
//        self.labelTime.text = dateValue
//        print("PRINT THUS\(NSDate(),date)")
//    }
//    
//    func hsDatePickerDidDismissWithQuitMethod(method: HSDatePickerQuitMethod) {
//        NSLog("Picker did dismiss with \(method)");
//    }
//    
//    func hsDatePickerWillDismissWithQuitMethod(method: HSDatePickerQuitMethod) {
//        NSLog("Picker will dismiss with\(method)")
//    }
//    
//}

