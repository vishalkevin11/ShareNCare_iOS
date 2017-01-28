//
//  FilterViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/18/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
//import OpinionzAlertView
//import PopupViewController

enum FilterPlaceType {
    case sourceType
    case destinationType
}

class FilterViewController: UITableViewController, CLLocationManagerDelegate {
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    var selectedRouteObj  : PXGoogleDirectionsRoute?
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    var googleMapView: GMSMapView!
    
    var selectedPlaceEntry = FilterPlaceType.sourceType
    var seatsArray = [1,2,3,4,5,6,7,8]
    
    var selectedDate :Date? = nil
    
    var  sourceLocation : LocationModal! = LocationModal()
    var  destinationLocation : LocationModal! = LocationModal()
    
    var  numberOfSeats: Int? = 0
    var  tripTypeValue: Int? = 0
    var  travellerTypeValue: Int? = 0
    var  scheduleTypeValue: Int? = 0
    
    var  strTime: String? = ""
    var  strRoute: String? = ""
    
    var  strTotalTime: String? = ""
    var  strTotalDistance: String? = ""
    var  strRouteVia: String? = ""
    
    
    var filterDictionary : NSMutableDictionary? = NSMutableDictionary()
    
    var pickerTypeForShowing : DatePickerType = datePikerType
    
    
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
        
        self.latitude = 0.0
        self.longitude = 0.0
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        initialize()
        
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTripViewController.routesSelected(_:)), name: kRouteSelected, object: nil)
//         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateTripViewController.dateandTimeReturned), name: "FilerSelecetedDateValue", object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    // MARK: Notifications
    //date
//    func dateandTimeReturned(notif : NSNotification) -> Void {
//        
//        let userInfoDictionary : NSDictionary? = notif.object as? NSDictionary
//        let pickerSelectedDate : NSDate?  = (userInfoDictionary!["selectedDate"] as? NSDate)!
//        let pickerSelectedDisplayValue : String?  = (userInfoDictionary!["selectedDisplayValue"] as? String)!
//        let pickerSelectedValue : String?  = (userInfoDictionary!["selectedValue"] as? String)!
//        
//        self.selectedDate = pickerSelectedDate
//        
//        self.strTime = dateValue
//        
//        self.labelTime.text = dateValue
//        
//        
//        if (pickerTypeForShowing == datePikerType) {
//            
//            let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
//            self.strTime = dateValue
//            self
//            self.labelTime.text = dateValue
//            
//        }
////        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .arrivingTYpe)) {
////            self.lblTimeArrive.text = pickerSelectedDisplayValue
////            self.strArrivalTime = pickerSelectedValue
////        }
////        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .departureType)) {
////            self.lblTimeDepart.text = pickerSelectedDisplayValue
////            self.strDepartTime = pickerSelectedValue
////        }
//    }
//    
    
    // MARK: Initializers
    
    
    func initialize() -> Void {
        
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
        
        
        let tmpsourceName : String  = (cacheDefaults.object(forKey: kCacheSourceName) != nil) ? cacheDefaults.object(forKey: kCacheSourceName) as! String : ""
        filterDictionary?.setObject(tmpsourceName, forKey: "source_name" as NSCopying)
        
        let tmpsourceLat  = (cacheDefaults.value(forKey: kCacheSourceLat) != nil) ? cacheDefaults.value(forKey: kCacheSourceLat) : 0.0
        filterDictionary?.setValue(tmpsourceLat!, forKey: "sourceLat")
        
        let tmpsourceLng  = (cacheDefaults.value(forKey: kCacheSourceLat) != nil) ? cacheDefaults.value(forKey: kCacheSourceLat) : 0.0
        filterDictionary?.setValue(tmpsourceLng!, forKey: "sourceLng")
        
        let tmpdestinationLat  = (cacheDefaults.value(forKey: kCacheDestinationLat) != nil) ? cacheDefaults.value(forKey: kCacheDestinationLat) : 0.0
        filterDictionary?.setValue(tmpdestinationLat!, forKey: "destinationLat")
        
        let tmpdestinationLng  = (cacheDefaults.value(forKey: kCacheDestinationLng) != nil) ? cacheDefaults.value(forKey: kCacheDestinationLng) : 0.0
        filterDictionary?.setValue(tmpdestinationLng!, forKey: "destinationLng")
        
        let tmpdestinationName  : String = (cacheDefaults.object(forKey: kCacheDestinationName) != nil) ? cacheDefaults.object(forKey: kCacheDestinationName) as! String : ""
        filterDictionary?.setObject(tmpdestinationName, forKey: "destination_name" as NSCopying)
        
        let tmpnumberOfSeatsValue  = (cacheDefaults.value(forKey: kCacheNumberOfSeatsName) != nil) ? cacheDefaults.value(forKey: kCacheNumberOfSeatsName) : 1
        filterDictionary?.setValue(tmpnumberOfSeatsValue!, forKey: "number_of_seats")
        
        let tmptravellerTypeValue  = (cacheDefaults.value(forKey: kCacheTravellerTypeName) != nil) ? cacheDefaults.value(forKey: kCacheTravellerTypeName) : 1
        filterDictionary?.setValue(tmptravellerTypeValue!, forKey: "traveller_type")
        
        let tmpScheduleTypeValue  = (cacheDefaults.value(forKey: kCacheScheduleTypeName) != nil) ? cacheDefaults.value(forKey: kCacheScheduleTypeName) : 1
        filterDictionary?.setValue(tmptravellerTypeValue!, forKey: "schedule_type")
        
        
        let tmpTripDateValue : String? = (cacheDefaults.object(forKey: kCacheTripDate) != nil) ? cacheDefaults.object(forKey: kCacheTripDate) as? String : ""
        filterDictionary?.setValue(tmpTripDateValue, forKey: "trip_date")
        
        let tmptripTypeValue  = (cacheDefaults.value(forKey: kCacheTripTypeName) != nil) ? cacheDefaults.value(forKey: kCacheTripTypeName) : 1
        filterDictionary?.setValue(tmptripTypeValue!, forKey: "trip_type")
        
        let tmpistripLiveValue  = (cacheDefaults.value(forKey: kCacheIsTripLive) != nil) ? cacheDefaults.value(forKey: kCacheIsTripLive) : 1
        filterDictionary?.setValue(tmpistripLiveValue!, forKey: "is_trip_live")
        
        
        self.numberOfSeats = tmpnumberOfSeatsValue as? Int
        self.travellerTypeValue = tmptravellerTypeValue as? Int
        self.tripTypeValue = tmptripTypeValue as? Int
        self.scheduleTypeValue = tmpScheduleTypeValue as? Int
        
        
        if ((tmpTripDateValue!.isEmpty == false) && (tmpTripDateValue != nil)) {
            let dateValue : Date? = PoolContants.sharedInstance.getFormatedDateFromString(tmpTripDateValue!) //dateformatter.dateFromString(tmpTripDateValue!)
            self.selectedDate = dateValue
        }
      
       
        
        
        
        
        self.labelSource.text = (tmpsourceName != "") ? tmpsourceName : "Enter a Origin"
        self.labelDestination.text = (tmpdestinationName != "") ? tmpdestinationName : "Enter a destination"
        
        self.labelTime.text = (tmpTripDateValue! != "") ? tmpTripDateValue : ""
        self.labelNumberOfSeats.text = "\(tmpnumberOfSeatsValue!)"
        
        
        let tarvellerIndexSelected = tmptravellerTypeValue! as! Int
        if tarvellerIndexSelected == 1 {
            self.travellerSegment.selectedSegmentIndex = 0
        }
        else {
            self.travellerSegment.selectedSegmentIndex = 1
        }
        
        let tripIndexSelected = tmptripTypeValue! as! Int
        if tripIndexSelected == 1 {
            self.tripSegment.selectedSegmentIndex = 0
        }
        else {
            self.tripSegment.selectedSegmentIndex = 1
        }
        
        
        let tripScheduleIndexSelected = tmpScheduleTypeValue! as! Int
        if tripScheduleIndexSelected == 1 {
            self.weekDaySegment.selectedSegmentIndex = 0
        }
        else {
            self.weekDaySegment.selectedSegmentIndex = 1
        }

    }
    
    
    //    func scrollToVisibleView() -> Void {
    //        // 60 - > row height
    //        // 8 - > rows
    //
    //        let fullScreenHeight : CGFloat  = UIScreen.mainScreen().bounds.size.height - (2.0 * 44.0)
    //        if fullScreenHeight >= (60.0 * 8.0) {
    //
    //            let heightDiff = fullScreenHeight - (60.0 * 8.0)
    //            self.tableView.setContentOffset(CGPointMake(0.0, -(heightDiff/2.0)), animated: true)
    //           // self.tableView.setContentOffset(CGPointMake(0.0, -44.0), animated: false)
    //           // self.tableView.setconte
    //
    //        }
    //        else {
    //            self.tableView.setContentOffset(CGPointMake(0.0, -44.0), animated: true)
    //        }
    //    }
    
    // MARK: POST Data
    
    
    func createPOSTDictionary() -> Void {
        
        
        
        filterDictionary?.setObject(self.sourceLocation.formatedAddress!, forKey: "source_name" as NSCopying)
        filterDictionary?.setValue(self.sourceLocation.latitude_val!, forKey: "sourceLat")
        filterDictionary?.setValue(self.sourceLocation.longitude_val!, forKey: "sourceLng")
        filterDictionary?.setValue(self.destinationLocation.latitude_val!, forKey: "destinationLat")
        filterDictionary?.setValue(self.destinationLocation.longitude_val!, forKey: "destinationLng")
        
        filterDictionary?.setObject(self.destinationLocation.formatedAddress!, forKey: "destination_name" as NSCopying)
        
        filterDictionary?.setValue(self.numberOfSeats!, forKey: "number_of_seats")
        filterDictionary?.setValue(self.travellerTypeValue!, forKey: "traveller_type")
        filterDictionary?.setValue(self.tripTypeValue!, forKey: "trip_type")
        filterDictionary?.setValue(self.scheduleTypeValue!, forKey: "schedule_type")
        
        
  
        var dateValue = ""
        if  self.selectedDate != nil {
            dateValue  = PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate!)//dateformatter.stringFromDate(self.selectedDate!)
        }
        else {
            dateValue =  ""
        }
       
        
        filterDictionary?.setObject(dateValue, forKey: "trip_date" as NSCopying)
        
        AppCacheManager.sharedInstance.saveFilterDetails(filterDictionary!)
        
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
//        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .arrivingTYpe)) {
//            self.lblTimeArrive.text = pickerSelectedDisplayValue
//            self.strArrivalTime = pickerSelectedValue
//        }
//        else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == .departureType)) {
//            self.lblTimeDepart.text = pickerSelectedDisplayValue
//            self.strDepartTime = pickerSelectedValue
//        }
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
            default: break
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.showSeatsPicker()
                break
            case 3:
                self.showDatePicker()
                break
            default: break
            }
        }
        
        
        
    }
    
    // MARK:  Actions
    
    
    
    
    func searchSource() -> Void {
        selectedPlaceEntry = FilterPlaceType.sourceType
        self.openLocationPicker()
    }
    
    func searchDesination() -> Void {
        selectedPlaceEntry = FilterPlaceType.destinationType
        self.openLocationPicker()
    }
    
   
    
    func showDatePicker() -> Void {
        
//        let hsdpvc : HSDatePickerViewController = HSDatePickerViewController.init()
//        hsdpvc.delegate = self
//        if self.selectedDate != nil {
//            hsdpvc.date = self.selectedDate;
//        }
//        
//         let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        //appDelegate.window?.rootViewController!.presentViewController(hsdpvc, animated: true, completion: nil)
//        self.present(hsdpvc, animated: true, completion: nil)
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = datePikerType
        DispatchQueue.main.async {
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: datePikerType, with: Date())
        }
    }
    
    func showSeatsPicker() -> Void {
        
        let picker = CZPickerView(headerTitle: "Number of seats", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    
    
    @IBAction func showWeedayPicker(_ sender: AnyObject) {
        let segment : UISegmentedControl = sender as! UISegmentedControl
        if (segment.selectedSegmentIndex == 0) {
//            self.viewWeekDay.hidden = true
            self.scheduleTypeValue = 1
        }
        else {
         //   self.viewWeekDay.hidden = false
            self.scheduleTypeValue = 2
        }
    }
    
    @IBAction func filter(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
        self.createPOSTDictionary()
        let cacheDefaults : UserDefaults = UserDefaults.init(suiteName: kCacheSuitName)!
         cacheDefaults.set(true, forKey: K_SAVED_IS_FILTER_SET)
       // AppCacheManager.sharedInstance.saveFilterDetails(filterDictionary!)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: K_NOTIFICATION_FILTER_TRIPS), object: nil)
        }
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
       // self.createPOSTDictionary()
        
        AppCacheManager.sharedInstance.resetFilter()
        initialize()
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: K_NOTIFICATION_FILTER_TRIPS), object: nil)
        }
    }
    
    @IBAction func tripTypeSelected(_ sender: AnyObject) {
        
        let segment : UISegmentedControl = sender as! UISegmentedControl
        self.tripTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
        
    }
    
    
    @IBAction func travellerTypeSelected(_ sender: AnyObject) {
        
        let segment : UISegmentedControl = sender as! UISegmentedControl
        self.travellerTypeValue = (segment.selectedSegmentIndex == 1) ? 2 : 1
    }
    
    
    // MARK: Functions for fetching location
    func openLocationPicker() -> Void {
        
        let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
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
                
                
                if fullPlace == "" {
                    placeDict.setValue(0.0, forKey: "latitude")
                    placeDict.setValue(0.0, forKey: "longitude")
                }
                else {
                placeDict.setValue(place.coordinate.latitude, forKey: "latitude")
                placeDict.setValue(place.coordinate.longitude, forKey: "longitude")
                }
                
                if self.selectedPlaceEntry == FilterPlaceType.sourceType {
                    
                    self.sourceLocation  = LocationModal.init(locationDict: placeDict)
                    self.labelSource.text = fullPlace
                }
                else {
                    self.destinationLocation  = LocationModal.init(locationDict: placeDict)
                    self.labelDestination.text = fullPlace
                }
                
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

    
}



extension FilterViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    
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

//extension FilterViewController : HSDatePickerViewControllerDelegate {
//    
//    func hsDatePickerPickedDate(date: NSDate!) {
//        
//        let dateValue : String = PoolContants.sharedInstance.getFormatedStringFromDate(date)//dateformatter.stringFromDate(date)
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
