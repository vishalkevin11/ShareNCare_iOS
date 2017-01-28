//
//  MyFoodDetailsViewController.swift
//  HungerFree
//
//  Created by Kevin Vishal on 11/12/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
//import OpinionzAlertView
//import PopupViewController
import ReachabilitySwift
//import MBPhotoPicker
//import KRProgressHUD

//enum PlaceType {
//    case sourceType
//    case destinationType
//}
//


class MyFoodDetailsViewController: UITableViewController, CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    @IBOutlet weak var placeholderImageforpic: UIImageView!
    var selectedRouteObj  : PXGoogleDirectionsRoute?
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    var reachability: Reachability?
    
    var googleMapView: GMSMapView!
    
    //  var selectedPlaceEntry = PlaceType.sourceType
    
    var leaveDateType = LeaveDateType.arrivingTYpe
    
    var seatsArray = [1,2,3,4,5,6,7,8]
    
    var selectedDate :Date? = Date()
    
    var selectedArrvivalDate :Date? = Date()
    var selectedDepartDate :Date? = Date()
    
    @IBOutlet weak var imageViewFoodType: UIImageView!
    @IBOutlet weak var labelExpiry: UILabel!
    
    var previousImageData : Data?
    
    var  sourceLocation : LocationModal! = LocationModal()
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var txtFldFood: UITextField!
    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var lblTimeArrive: UILabel!
    @IBOutlet weak var lblTimeDepart: UILabel!
    @IBOutlet weak var txtAlternatePhoneNumber: UITextField!
    @IBOutlet weak var txtServesHowMAny: UITextField!
    @IBOutlet weak var txtViewFoodDescription: UITextView!
    @IBOutlet weak var lableStatus: UILabel!
    
    var  destinationLocation : LocationModal! = LocationModal()
    
    var  numberOfSeats: Int? = 1
    var  tripTypeValue: Int? = 1
    var  travellerTypeValue: Int? = 1
    var  scheduleTypeValue: Int? = 1
    
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
    
    
    @IBOutlet weak var viewWeekDay: UIView!
    @IBOutlet weak var pickerWeekDay: WeekDaysSegmentedControl!
    @IBOutlet weak var widthDepartureConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthArrivalConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTimeOuter: UIView!
    
    
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var weekDaySegment: UISegmentedControl!
    
    @IBOutlet weak var photoButton: UIButton!
    
    var currentEditingTrip : FoodItem = FoodItem()
    
    @IBOutlet weak var labelBookieName: UILabel!
    
    // MARK: Deinit
    
    @IBAction func acceptRequest(_ sender: AnyObject) {
        
        self.acceptthefood()
    }
    
    @IBAction func rejectRequest(_ sender: AnyObject) {
        self.rejectthefood()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
    }
    
    
    // MARK: View Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  self.pickerWeekDay.showSmallText = false
       
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        DispatchQueue.main.async {
            if self.previousImageData != nil {
                self.imageViewFood.image = UIImage.init(data: self.previousImageData!)
                self.placeholderImageforpic.image = nil
            }
            else {
                self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
            }
        }
        
        
        
        //initialize()
        self.disableUserInteraction()
        //self.showTheItemStatus()
        self.fetchfoodDetails()
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateOfferFoodViewController.dateandTimeReturned), name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
        
    }
    
    
    @IBAction func deleteTheItem(_ sender: AnyObject) {
        
        self.createPOSTDictionaryForDelte()
    }
    
    
    
    func createPOSTDictionaryForDelte() -> Void {
        
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
     //   postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPostOfferPhonenumber)
        
        postDictionary.setValue(self.currentEditingTrip.uniqueid!, forKey: kPostOfferUniqueID)
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key  in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                swiftDict[stringKey] = keyValue as AnyObject??
            }
        }
        
        
        myTripsNetworkManager.deletefoodItem(swiftDict as (Dictionary<String, AnyObject>)?) { (isunBooked) in
            var alertMess  = ""
            var alertTitle  = ""
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            if (isunBooked == true) {
                
                
                var alertTitle = ""
                var alertMess = "Successfully delete the item."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                    
                    //self.currentEditingTrip.ispending = 1
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                
                //                }
            else {
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                alertTitle = ""
                alertMess = "Failed to accept the request."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func fetchfoodDetails() -> Void {
        
         self.tableView.alpha = 0.0;
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        myTripsNetworkManager.getFoodItemDetails(Int(self.currentEditingTrip.uniqueid!)) { (fooItem :AnyObject?, error :  NSError?) in
            
            
            var alertMess  = ""
            var alertTitle  = ""
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            if (error == nil) && (fooItem != nil) {
                
                
                
                DispatchQueue.main.async {
                    self.currentEditingTrip = fooItem! as! FoodItem
                    self.initialize()
                    self.showTheItemStatus()
                    self.tableView.reloadData()
                    self.tableView.alpha = 1.0;
                }
                
            }
            else {
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                alertTitle = ""
                alertMess = (error?.localizedDescription)!
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func acceptthefood() {
        
        let alert = PopupViewController(title: "", message: "Do you want to accept this request ?")
        alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
        alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
            
            // Call deelet trip
            self.createPOSTDictionaryForAccept()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func rejectthefood() {
        
        let alert = PopupViewController(title: "", message: "Do you want to reject this request ?")
        alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
        alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
            
            // Call deelet trip
            self.createPOSTDictionaryForReject()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func createPOSTDictionaryForAccept() -> Void {
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPostOfferPhonenumber as NSCopying)
        
        postDictionary.setValue(self.currentEditingTrip.uniqueid!, forKey: kPostOfferUniqueID)
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key  in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                swiftDict[stringKey] = keyValue as AnyObject??
            }
        }
        
        
        myTripsNetworkManager.acceptRequestForfoodItem(swiftDict as (Dictionary<String, AnyObject>)?) { (isunBooked) in
            var alertMess  = ""
            var alertTitle  = ""
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            if (isunBooked == true) {
                
                
                var alertTitle = ""
                var alertMess = "Successfully accepted the request."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                    
                    //self.currentEditingTrip.ispending = 1
                    self.fetchfoodDetails()
                }))
                self.present(alert, animated: true, completion: nil)
            }
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                
                //                }
            else {
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                alertTitle = ""
                alertMess = "Failed to accept the request."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    
    func createPOSTDictionaryForReject() -> Void {
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPostOfferPhonenumber as NSCopying)
        
        postDictionary.setValue(self.currentEditingTrip.uniqueid!, forKey: kPostOfferUniqueID)
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                swiftDict[stringKey] = keyValue as AnyObject??
            }
        }
        
        
        myTripsNetworkManager.rejectRequestForfoodItem(swiftDict as (Dictionary<String, AnyObject>)?) { (isunBooked) in
            var alertMess  = ""
            var alertTitle  = ""
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            if (isunBooked == true) {
                
                
                var alertTitle = ""
                var alertMess = "Successfully rejected the request."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                    
                    //self.currentEditingTrip.ispending = 1
                    self.fetchfoodDetails()
                }))
                self.present(alert, animated: true, completion: nil)
            }
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                
                //                }
            else {
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                alertTitle = ""
                alertMess = "Failed to rejecte the request"
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }

    
    
    func showTheItemStatus() -> Void {
        
        self.lableStatus.alpha = 0.0
        
         if (self.currentEditingTrip.istaken! == 1) {
            self.lableStatus.text = "Taken away"
            //self.btnBookFooter.enabled = false
        }
         if (self.currentEditingTrip.isbooked! == 1) {
           // self.lableStatus.text = "Already booked"
            //else if (self.currentEditingTrip.isbooked! == 1) {
                self.lableStatus.text = "Already booked by \(self.currentEditingTrip.bookiePhonenumber!)"
                
             self.labelBookieName.text = "\(self.currentEditingTrip.bookiePhonenumber!) is requesting \(self.currentEditingTrip.itemname!)."
            self.lableStatus.alpha = 1.0
//            self.btnBookFooter.enabled = true
//            self.btnBookFooter.setTitle("Unbook", forState: UIControlState.Normal)
        }
         if (self.currentEditingTrip.ispending! == 1) {
            
            if PoolContants.sharedInstance.checkThisTripIsMine(self.currentEditingTrip.phonenumber!) {
                self.lableStatus.alpha = 0.0
//                self.lableStatus.text = "yours"
                
                self.labelBookieName.text = "\(self.currentEditingTrip.bookiePhonenumber!) is requesting \(self.currentEditingTrip.itemname!)."
//                self.lableStatus.text = "Pending Approval"
            }
            else {
                self.lableStatus.text = "Pending Approval"
                self.lableStatus.alpha = 1.0
            }
           
//            self.btnBookFooter.enabled = false
//            self.btnBookFooter.setTitle("Pending Approval", forState: UIControlState.Normal)
        }
       // else {
//            self.lableStatus.text = "Available"
//            self.btnBookFooter.enabled = true
//            self.btnBookFooter.setTitle("Book", forState: UIControlState.Normal)
            
//            self.lableStatus.alpha = 0.0
//        }
    }
    
    func disableUserInteraction() -> Void {
        self.txtFldFood.isUserInteractionEnabled = false
        self.txtAlternatePhoneNumber.isUserInteractionEnabled = false
        self.txtServesHowMAny.isUserInteractionEnabled = false
        self.txtViewFoodDescription.isEditable = false
    }
    
    

    
    
   // var photo: MBPhotoPicker?
    
    func didTapPhotoPicker() {
    /*    photo = MBPhotoPicker()
        photo?.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photo?.alertTitle = nil
        photo?.alertMessage = nil
        photo?.resizeImage = CGSize(width: 250, height: 150)
        photo?.allowDestructive = false
        photo?.allowEditing = false
        photo?.cameraDevice = .rear
        photo?.cameraFlashMode = .auto
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            photo?.popoverTarget = self.photoButton!
            photo?.popoverDirection = .up
            photo?.popoverRect = self.photoButton.bounds // It's also default value
        }
        
        photo?.photoCompletionHandler = { (image: UIImage!) -> Void in
            self.placeholderImageforpic.image = nil
            self.imageViewFood.image = image;
        }
        photo?.cancelCompletionHandler = {
            print("Cancel Pressed")
            self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
        }
        photo?.errorCompletionHandler = { (error: MBPhotoPicker.ErrorPhotoPicker!) -> Void in
            print("Error: \(error.rawValue)")
            self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
        }
        photo?.present(self)
 */
    }
    
    
    //MARK: reachability class
    func checkNetworkStatus() -> Bool {
        /*   var isAvailable  = false;
         
         do {
         self.reachability = try Reachability.reachabilityForInternetConnection()
         
         switch reachability!.currentReachabilityStatus{
         case .reachableViaWiFi:
         isAvailable = true
         case .reachableViaWWAN:
         isAvailable = true
         case .notReachable:
         isAvailable = false
         }
         }
         catch let error as NSError{
         print(error.debugDescription)
         }
         
         return isAvailable;
         */
        var isAvailable  = false;
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                isAvailable = true
            } else  if reachability.isReachableViaWWAN {
                print("Reachable via WWAN")
                isAvailable = true
            } else {
                print("Reachable via Cellular")
                isAvailable = true
            }
        } else {
            print("Network not reachable")
            isAvailable = false
        }
        return isAvailable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    // MARK: Initializers
    
    
    func initialize() -> Void {
        
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()
        //  self.widthDepartureConstraint.constant = 0.0
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.widthDepartureConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.viewTimeOuter.layoutSubviews()
        
        //self.selectedDate = NSDate()
        
        
        
        
        
        
        
//        let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
//        self.strTime = dateValue
//        
//        self.labelTime.text = dateValue
//        
//        
//        let dateTimeValue : String =  PoolContants.sharedInstance.getFormatedTimeFromDate(self.selectedDate)
        
        // self.strTime = dateTimeValue
        
        
        //  self.strArrivalTime = dateTimeValue
        
        self.selectedArrvivalDate = PoolContants.sharedInstance.getDateFromUNIXTimeStamp(self.currentEditingTrip.pickat_date!)
        
        
        self.strArrivalTime = PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedArrvivalDate)
        self.lblTimeArrive.text = self.strArrivalTime!
        
//        let calendar = NSCalendar.currentCalendar()
//        let newDepartdate = calendar.dateByAddingUnit(.Minute, value: 30, toDate: self.selectedArrvivalDate!, options: [])
//        
        
        self.selectedDepartDate = PoolContants.sharedInstance.getDateFromUNIXTimeStamp(self.currentEditingTrip.pickby_date!)
        
        self.strDepartTime = PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDepartDate)
        self.lblTimeDepart.text = self.strDepartTime!
        
        
        // self.strDepartTime = PoolContants.sharedInstance.getFormatedTimeFromDate(newDepartdate)
        
       
        
        
        self.labelSource.text = self.currentEditingTrip.address!
        self.txtAlternatePhoneNumber.text = self.currentEditingTrip.alternate_phonenumber!
        self.txtServesHowMAny.text = "\(self.currentEditingTrip.serves_count!)"
        self.txtViewFoodDescription.text = self.currentEditingTrip.food_description!
        
        //   self.labelDestination.text = "Enter Trip Destination"
        //   self.labelRoute.text = ""
        
        
        
        // self.labelNumberOfSeats.text = "\(self.numberOfSeats!)";
        
        
//        
//        let tarvellerIndexSelected = self.travellerTypeValue
//        if tarvellerIndexSelected == 1 {
//            //   self.travellerSegment.selectedSegmentIndex = 0
//        }
//        else {
//            //  self.travellerSegment.selectedSegmentIndex = 1
//        }
//        
//        let tripIndexSelected = self.tripTypeValue
//        if tripIndexSelected == 1 {
//            // self.tripSegment.selectedSegmentIndex = 0
//        }
//        else {
//            // self.tripSegment.selectedSegmentIndex = 1
//        }
        
        
        
        let foodType = self.currentEditingTrip.foodType!
        
        if foodType == 0 {
            self.imageViewFoodType.image = UIImage.init(named: "veg_icon.png")
        }
        else {
            self.imageViewFoodType.image = UIImage.init(named: "nonveg_icon.png")
        }
        
        
        var expiryDate = PoolContants.sharedInstance.getDateFromUNIXTimeStamp(self.currentEditingTrip.expiry_date!)
        let dateformatter : DateFormatter = DateFormatter.init()
        //dateformatter.dateFormat = "yyyy-MMM-dd HH:mm"
        //    dateformatter.dateFormat = "yyyy-MMM-dd"
        dateformatter.dateFormat = "MMM dd yyyy"
        let dateValue : String? = dateformatter.string(from: expiryDate)
        
        
        self.sourceLocation.formatedAddress = self.currentEditingTrip.address!

        self.sourceLocation.latitude_val = self.currentEditingTrip.lat!
        self.sourceLocation.longitude_val = self.currentEditingTrip.lng!
        
        self.txtFldFood.text = self.currentEditingTrip.itemname!
    
        
//        self.destinationLocation.latitude_val = 0.0
//        self.destinationLocation.longitude_val = 0.0
//        self.strTotalTime = ""
//        self.strTotalDistance = ""
//        self.strRouteVia = ""
    }
    
    
    
  /*
    func initialize() -> Void {
        
        self.pickerWeekDay.daysString = "1111100"
        self.pickerWeekDay.borderColor = PoolContants.appPaleGreenColor
        self.pickerWeekDay.textColor = PoolContants.appPaleGreenColor
        self.viewWeekDay.hidden = true
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()
        //  self.widthDepartureConstraint.constant = 0.0
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.widthDepartureConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.viewTimeOuter.layoutSubviews()
        
        //  self.numberOfSeats = 1
        //  self.travellerTypeValue = 1
        self.tripTypeValue = 1
        // self.scheduleTypeValue = 1
        
        self.selectedDate = NSDate()
        
        
        let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
        self.strTime = dateValue
        
        self.labelTime.text = dateValue
        
        
        let dateTimeValue : String =  PoolContants.sharedInstance.getFormatedTimeFromDate(self.selectedDate)
        
        // self.strTime = dateTimeValue
        
        
        //  self.strArrivalTime = dateTimeValue
        self.strArrivalTime = self.getIntialArrivalTime()
        self.lblTimeArrive.text = self.strArrivalTime!
        
        let calendar = NSCalendar.currentCalendar()
        let newDepartdate = calendar.dateByAddingUnit(.Minute, value: 30, toDate: self.selectedDate!, options: [])
        
        
        // self.strDepartTime = PoolContants.sharedInstance.getFormatedTimeFromDate(newDepartdate)
        
        self.strDepartTime = self.getIntialDepatTime()
        self.lblTimeDepart.text = self.strDepartTime!
        
        
        self.labelSource.text = "Enter Trip Origin"
        //   self.labelDestination.text = "Enter Trip Destination"
        //   self.labelRoute.text = ""
        
        
        
        // self.labelNumberOfSeats.text = "\(self.numberOfSeats!)";
        
        
        
        let tarvellerIndexSelected = self.travellerTypeValue
        if tarvellerIndexSelected == 1 {
            //   self.travellerSegment.selectedSegmentIndex = 0
        }
        else {
            //  self.travellerSegment.selectedSegmentIndex = 1
        }
        
        let tripIndexSelected = self.tripTypeValue
        if tripIndexSelected == 1 {
            // self.tripSegment.selectedSegmentIndex = 0
        }
        else {
            // self.tripSegment.selectedSegmentIndex = 1
        }
        
        
        self.sourceLocation.formatedAddress = ""
        self.destinationLocation.formatedAddress = ""
        self.sourceLocation.latitude_val = 0.0
        self.sourceLocation.longitude_val = 0.0
        self.destinationLocation.latitude_val = 0.0
        self.destinationLocation.longitude_val = 0.0
        self.strTotalTime = ""
        self.strTotalDistance = ""
        self.strRouteVia = ""
    }
   */
    
    
    func getIntialArrivalTime() -> String {
        let dateString = "09:00" // change to your date format
        
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
        
                var date = dateFormatter.date(from: dateString)
        return dateString
        
    }
    
    
    func getIntialDepatTime() -> String {
        let dateString = "18:30" // change to your date format
        
        //        var dateFormatter = NSDateFormatter()
        //        dateFormatter.dateFormat = "HH:mm"
        //
        //        var date = dateFormatter.dateFromString(dateString)
        return dateString
        
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
    
    
    func createOfferPOSTDictionary() -> Void {
        
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserName(), forKey: kPostOfferName as NSCopying)
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserEmail(), forKey: kPostOfferEmail as NSCopying)
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPostOfferPhonenumber as NSCopying)
        
        postDictionary.setObject(self.txtFldFood.text!, forKey: kPostOfferItemName as NSCopying)
        
        let unixTimeStamp = Date().timeIntervalSince1970
        
        postDictionary.setValue(Int(unixTimeStamp), forKey: kPostOfferUniqueID)
        postDictionary.setValue(0, forKey: kPostOfferReportedabuse)
        postDictionary.setObject(self.txtAlternatePhoneNumber.text!, forKey: kPostOfferAlternate_phonenumber as NSCopying)
        
        if ((self.txtViewFoodDescription.text != nil) || (self.txtViewFoodDescription.text!.isEmpty == false)) {
            postDictionary.setObject(self.txtViewFoodDescription.text!, forKey: kPostOfferDescription as NSCopying)
        }
        else {
            postDictionary.setObject("", forKey: kPostOfferDescription as NSCopying)
        }
        postDictionary.setValue(0, forKey: kPostOfferIsTaken)
        postDictionary.setValue(0, forKey: kPostOfferIsBooked)
        postDictionary.setValue(0, forKey: kPostOfferIsPending)
        postDictionary.setValue("\(self.selectedArrvivalDate!.timeIntervalSince1970)", forKey: kPostOfferPickAtDate)
        postDictionary.setValue("\(self.selectedDepartDate!.timeIntervalSince1970)", forKey: kPostOfferPickByDate)
        postDictionary.setObject(self.sourceLocation.formatedAddress!, forKey: kPostOfferAddress as NSCopying)
        postDictionary.setObject(self.txtServesHowMAny.text!, forKey: kPostOfferServesCount as NSCopying)
        
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key  in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                 swiftDict[stringKey] = keyValue as AnyObject
            }
        }
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        
        myTripsNetworkManager.createOffer(swiftDict as (Dictionary<String, AnyObject>)?) { (responseTrips : AnyObject?, error : NSError?) in
            var alertMess  = ""
            var alertTitle  = ""
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            if (error == nil) && (responseTrips != nil) {
                
                let tripscreted = responseTrips as! String
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                alertTitle = ""
                alertMess = tripscreted
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                    
                    self.initialize()
                }))
                self.present(alert, animated: true, completion: nil)
                //                }
            }
            else {
                alertTitle = ""
                alertMess = (error?.localizedDescription)!
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createPOSTDictionary() -> Void {
        
        
        /*      let postDictionary : NSMutableDictionary = NSMutableDictionary()
         
         
         //        self.sourceLocation.placeName = "J p nagar 2nd phase"
         //        self.destinationLocation.placeName = "koramangala 5th block"
         //
         //        self.sourceLocation.latitude_val = 12.75
         //        self.sourceLocation.longitude_val = 12.75
         //        self.destinationLocation.latitude_val = 12.75
         //        self.destinationLocation.longitude_val = 12.75
         //
         
         postDictionary.setObject(self.sourceLocation.formatedAddress!, forKey: kPOSTSourceName)
         postDictionary.setObject(self.destinationLocation.formatedAddress!, forKey: kPOSTDestinationName)
         
         postDictionary.setValue(self.sourceLocation.latitude_val!, forKey: kPOSTSourceLat)
         postDictionary.setValue(self.sourceLocation.longitude_val!, forKey: kPOSTSourceLng)
         postDictionary.setValue(self.destinationLocation.latitude_val!, forKey: kPOSTDestinationLat)
         postDictionary.setValue(self.destinationLocation.longitude_val!, forKey: kPOSTDestinationLng)
         
         postDictionary.setObject("\(self.strArrivalTime!)", forKey: kPOSTTimeLeavingSource)
         postDictionary.setObject("\(self.strDepartTime!)", forKey: kPOSTTimeLeavingDestination)
         postDictionary.setObject("\(self.strTime!)", forKey: kPOSTDateType)
         
         postDictionary.setValue(self.numberOfSeats!, forKey: kPOSTNumberOfSeats)
         postDictionary.setValue(self.tripTypeValue!, forKey: kPOSTTripType)
         postDictionary.setValue(self.travellerTypeValue!, forKey: kPOSTTravellerType)
         
         
         //        var strr = self.strTotalDistance!
         //        print("\(self.strTotalDistance, strr)")
         
         postDictionary.setObject("\(self.strTotalTime!)", forKey: kPOSTTotalTripTime)
         postDictionary.setObject("\(self.strTotalDistance!)", forKey: kPOSTTotalTripDistance)
         postDictionary.setObject(self.strRouteVia!, forKey: kPOSTTotalTripVia)
         
         
         let unixTimeStamp = NSDate().timeIntervalSince1970
         
         postDictionary.setValue(unixTimeStamp, forKey: kPOSTUniqueID)
         postDictionary.setValue(1, forKey: kPOSTIsTripLive)
         
         
         
         
         postDictionary.setValue(self.scheduleTypeValue!, forKey: kPOSTScheduleType)
         postDictionary.setValue(self.day1Value!, forKey: kPOSTDay1Type)
         postDictionary.setValue(self.day2Value!, forKey: kPOSTDay2Type)
         postDictionary.setValue(self.day3Value!, forKey: kPOSTDay3Type)
         postDictionary.setValue(self.day4Value!, forKey: kPOSTDay4Type)
         postDictionary.setValue(self.day5Value!, forKey: kPOSTDay5Type)
         postDictionary.setValue(self.day6Value!, forKey: kPOSTDay6Type)
         postDictionary.setValue(self.day7Value!, forKey: kPOSTDay7Type)
         
         
         
         
         // let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
         
         
         
         postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserEmail(), forKey: kPOSTEmail)
         postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPOSTPhoneNumber)
         
         //        postDictionary.setObject("aaa@bbb.com", forKey: kPOSTEmail)
         //            postDictionary.setObject("", forKey: kPOSTPhoneNumber)
         
         //routes
         
         
         
         let stepsArray : NSMutableArray = NSMutableArray()
         if selectedRouteObj!.legs.count > 0 {
         let leg = selectedRouteObj!.legs[0]
         
         for  step in leg.steps {
         
         
         let placeDict : NSMutableDictionary = NSMutableDictionary()
         
         let polyline = GMSPolyline(path: step.path)
         
         let dist = step.distance?.description, dur = step.duration?.description
         
         
         placeDict.setObject(step.rawInstructions!, forKey: "rawInstructions")
         placeDict.setObject("\(dist!)", forKey: "distance")
         placeDict.setObject("\(dur!)", forKey: "duration")
         
         placeDict.setValue(step.startLocation?.latitude, forKey: "latitude")
         placeDict.setValue(step.startLocation?.longitude, forKey: "longitude")
         placeDict.setValue(unixTimeStamp, forKey: "routeId")
         
         
         let pathPoly : String? = polyline.path?.encodedPath()
         placeDict.setObject("\(pathPoly!)", forKey: "polyline")
         
         //Since they give two value, we take only one
         
         //                placeDict.setValue(step.startLocation?.latitude, forKey: "startLat")
         //                placeDict.setValue(step.startLocation?.longitude, forKey: "startLng")
         //   placeDict.setValue(step.endLocation?.latitude, forKey: "EndLat")
         //   placeDict.setValue(step.endLocation?.longitude, forKey: "EndLng")
         
         
         print("\(step.rawInstructions!)")
         
         stepsArray.addObject(placeDict)
         
         }
         }
         
         
         
         postDictionary.setObject(stepsArray, forKey: kPOSTStepRecords)
         
         // POST TO SERVER
         
         var swiftDict : Dictionary<String,AnyObject!> = Dictionary<String,AnyObject!>()
         for key  in postDictionary.allKeys {
         let stringKey = key as! String
         if let keyValue = postDictionary.objectForKey(stringKey){
         swiftDict[stringKey] = keyValue
         }
         }
         dispatch_async(dispatch_get_main_queue()) {
         PoolContants.sharedInstance.show()
         }
         
         
         myTripsNetworkManager.createTrip(swiftDict) { (responseTrips : AnyObject?, error : NSError?) in
         var alertMess  = ""
         var alertTitle  = ""
         dispatch_async(dispatch_get_main_queue()) {
         PoolContants.sharedInstance.dismiss()
         }
         if (error == nil) && (responseTrips != nil) {
         
         let tripscreted = responseTrips as! String
         //
         //                if trips.count > 0 {
         //                    self.reloadTrips(trips)
         //                }
         //                else {
         alertTitle = ""
         alertMess = tripscreted
         let alert = PopupViewController(title: alertTitle, message: alertMess)
         alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
         
         self.initialize()
         }))
         self.present(alert, animated: true, completion: nil)
         //                }
         }
         else {
         alertTitle = ""
         alertMess = (error?.localizedDescription)!
         let alert = PopupViewController(title: alertTitle, message: alertMess)
         alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
         
         //alert.iconType = OpinionzAlertIconSuccess;
         //alert.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
         
         //            let alertPopup : OpinionzAlertView = OpinionzAlertView.init(title: alertTitle, message: alertMess, cancelButtonTitle: "OK", otherButtonTitles: nil)
         //            //alertPopup.color = UIColor.init(red: 0.61, green: 0.35, blue: 0.71, alpha: 1)
         //            //alertPopup.iconType = OpinionzAlertIconWarning
         //            alertPopup.show()
         
         
         
         }
         
         */
        
    }
    
    
    // MARK: Notifications
    
    //Date
    /*
     
     
     -(void)selcetedPickerDateOptions:(NSNotification *)notification {
     NSDictionary *userInfoDictionary = notification.userInfo;
     
     if (pickerTypeForShowing == datePikerType) {
     self.labelTripDate.text = userInfoDictionary[@"selectedDisplayValue"];
     self.dateStrServer = userInfoDictionary[@"selectedValue"];
     self.slectedDate = userInfoDictionary[@"selectedDate"];
     }
     else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == leaveToDestinationType)) {
     self.labelArrivalAtDestination.text = userInfoDictionary[@"selectedDisplayValue"];
     self.serverArrivalAtDestination = userInfoDictionary[@"selectedValue"];
     }
     else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == leaveAtDestinationType)) {
     self.labelDepartAtDestination.text = userInfoDictionary[@"selectedDisplayValue"];
     self.serverDepartAtDestination = userInfoDictionary[@"selectedValue"];
     }
     }
     
     
     
     */
    func dateandTimeReturned(_ notif : Notification) -> Void {
        
        let userInfoDictionary : NSDictionary? = notif.object as? NSDictionary
        let pickerSelectedDate : Date?  = (userInfoDictionary!["selectedDate"] as? Date)!
        let pickerSelectedDisplayValue : String?  = (userInfoDictionary!["selectedDisplayValue"] as? String)!
        let pickerSelectedValue : String?  = (userInfoDictionary!["selectedValue"] as? String)!
        
        self.selectedDate = pickerSelectedDate
        
        //        if (pickerTypeForShowing == datePikerType) {
        //
        //            let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
        //            self.strTime = dateValue
        //            self.labelTime.text = dateValue
        //
        //        }
        if((pickerTypeForShowing == dateTimePickerType) && (self.leaveDateType == .arrivingTYpe)) {
            self.selectedArrvivalDate = pickerSelectedDate
            self.lblTimeArrive.text = pickerSelectedDisplayValue
            self.strArrivalTime = pickerSelectedValue
        }
        else if((pickerTypeForShowing == dateTimePickerType) && (self.leaveDateType == .departureType)) {
            self.selectedDepartDate = pickerSelectedDate
            self.lblTimeDepart.text = pickerSelectedDisplayValue
            self.strDepartTime = pickerSelectedValue
        }
    }
    
    
    //Routes
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
            if let dist = leg.distance?.description!, let dur = leg.duration?.description! {
                
                
                
                self.strTotalDistance = dist
                self.strTotalTime = dur
                self.strRouteVia = selectedRouteObj!.summary!
                
                summaryStr =  "via .\(selectedRouteObj!.summary!), (\(dist), \(dur))"
            }
            
            
            //   self.labelRoute.text = summaryStr!
            
            
            //add addfress for nil
            
            if (leg.startAddress) != nil {
                
                if (self.sourceLocation.formatedAddress?.isEmpty == true) {
                    self.sourceLocation.formatedAddress = leg.startAddress
                    self.labelSource.text = leg.startAddress
                }
            }
            
            if (leg.endAddress) != nil {
                
                if (self.destinationLocation.formatedAddress?.isEmpty == true) {
                    self.destinationLocation.formatedAddress = leg.endAddress
                    //  self.labelDestination.text = leg.endAddress
                }
            }
        }
        
        
    }
    
    
    // MARK: TextFiled Delegates / TextView Delegates
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: TableView Methods & TableView Delegates
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section==2 {
            return self.footerView
        }
        return super.tableView(tableView, viewForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section==2 {
            return 47.0
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
            if (self.currentEditingTrip.ispending! == 1) {
                return 80.0
            }
            else {
                return 0.0
                }
            }
            else {
                return 180.0
            }
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 60.0
            }
            else if (indexPath.row == 1) {
                return 74.0
            }
        }
        else
            if (indexPath.section == 2) {
                if ((indexPath.row == 0) || (indexPath.row == 3)) {
                    return 80.0
                }
                else if ((indexPath.row == 1) || (indexPath.row == 2) ) {
                    return 60.0
                }
                
                return 0.0
        }
        
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //self.didTapPhotoPicker()
                break
            default: break
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
             //   self.searchSource()
                break
                //            case 3:
                //                self.showDatePicker()
            //                break
            default: break
            }
        }
        //        else if indexPath.section == 2 {
        //            switch indexPath.row {
        //            case 0,1:
        //                self.show()
        //                break
        //                //            case 3:
        //                //                self.showDatePicker()
        //            //                break
        //            default: break
        //            }
        //        }
        
        
        
    }
    
    
    
    
    // MARK: Validate
    
    
    func validatePhone(_ value: String) -> Bool {
        //  let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        //        let PHONE_REGEX =   "^((\\+)|(00))[0-9]{6,14}$"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //        let result =  phoneTest.evaluateWithObject(value)
        //        return result
        
        
        /*
         NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
         
         NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
         
         return [string isEqualToString:filtered];
         */
        let charcter  = CharacterSet(charactersIn: "0123456789").inverted
        var filtered:String = ""
        let inputString:[String] = value.components(separatedBy: charcter)
        //filtered = inputString.componentsJoined(by: "") as NSString!
        filtered = inputString.joined(separator: "")
        
        if ((value == filtered) && (value.characters.count == 10)) {
            return true
        }
        return false
    }
    
    
    
    
    func validateservesCount(_ value: String) -> Bool {
        
        let charcter  = CharacterSet(charactersIn: "0123456789").inverted
        var filtered:String = ""
        let inputString:[String] = value.components(separatedBy: charcter)
        //filtered = inputString.componentsJoined(by: "") as NSString!
        filtered = inputString.joined(separator: "")
        
        if (value == filtered) {
            return true
        }
        return false
    }
    
    
    
    func isValidEmail(_ testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validateAllEntries() -> Bool {
        
        
        //source
        
        if ((self.txtFldFood.text == nil) || (self.txtFldFood.text?.isEmpty == true)) {
            let alert = PopupViewController(title: "Missing Food name", message: "Please Enter a valid food name.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if ((self.labelSource.text?.isEmpty == true) || (self.labelSource.text == "Address :") || (self.labelSource.text == "")) {
            let alert = PopupViewController(title: "Missing Origin", message: "Please Enter a valid origin.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.validatePhone(self.txtAlternatePhoneNumber.text!) == false) {
            
            let alert = PopupViewController(title: "", message: "Please provide valid Phone number.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if (self.validatePhone(self.txtAlternatePhoneNumber.text!) == false) {
            
            let alert = PopupViewController(title: "", message: "Please provide valid Phone number.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else  if (self.validateservesCount(self.txtServesHowMAny.text!) == false) {
            
            let alert = PopupViewController(title: "", message: "Please provide valid serves count.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // MARK:  Actions
    
    func searchSource() -> Void {
        
        if (self.checkNetworkStatus() == true) {
            //       selectedPlaceEntry = PlaceType.sourceType
            self.openLocationPicker()
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func searchDesination() -> Void {
        
        if (self.checkNetworkStatus() == true) {
            //   selectedPlaceEntry = PlaceType.destinationType
            self.openLocationPicker()
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchRoute() -> Void {
        
        if ((self.labelSource.text?.isEmpty == true) || (self.labelSource.text == "Address :") || (self.labelSource.text == "")) {
            let alert = PopupViewController(title: "Missing Origin", message: "Please Enter a valid origin.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
            //        else if ((self.labelDestination.text?.isEmpty == true) || (self.labelDestination.text == "Enter Trip Destination") || (self.labelDestination.text == "")) {
            //            let alert = PopupViewController(title: "Missing Destination", message: "Please Enter a valid destination.")
            //            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
            //
            //
            //            }))
            //            self.present(alert, animated: true, completion: nil)
            //        }
        else {
            
            
            
            self.fetchRoutes()
        }
        
    }
    /*
     
     -(void)selcetedPickerDateOptions:(NSNotification *)notification {
     NSDictionary *userInfoDictionary = notification.userInfo;
     
     if (pickerTypeForShowing == datePikerType) {
     self.labelTripDate.text = userInfoDictionary[@"selectedDisplayValue"];
     self.dateStrServer = userInfoDictionary[@"selectedValue"];
     self.slectedDate = userInfoDictionary[@"selectedDate"];
     }
     else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == leaveToDestinationType)) {
     self.labelArrivalAtDestination.text = userInfoDictionary[@"selectedDisplayValue"];
     self.serverArrivalAtDestination = userInfoDictionary[@"selectedValue"];
     }
     else if((pickerTypeForShowing == timePikerType) && (self.leaveDateType == leaveAtDestinationType)) {
     self.labelDepartAtDestination.text = userInfoDictionary[@"selectedDisplayValue"];
     self.serverDepartAtDestination = userInfoDictionary[@"selectedValue"];
     }
     }
     
     */
    
    
    
    @IBAction func showDatePicker(_ sender: AnyObject) {
        
        self.showDate()
    }
    
    
    func showDate() -> Void {
        
        //
        //        let hsdpvc : HSDatePickerViewController = HSDatePickerViewController.init()
        //
        //        hsdpvc.dateFormatter.dateFormat = "dd MMM yyyy"
        //
        //        hsdpvc.delegate = self
        //        if self.selectedDate != nil {
        //            hsdpvc.date = self.selectedDate;
        //        }
        //
        //        dispatch_async(dispatch_get_main_queue()) {
        //           UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(hsdpvc, animated: true, completion: nil)
        //        }
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = datePikerType
        DispatchQueue.main.async {
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: datePikerType, with: Date())
        }
        
        //self.present(hsdpvc, animated: true, completion: nil)
    }
    
    func showSeatsPicker() -> Void {
        
        let picker = CZPickerView(headerTitle: "Number of seats", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    
    
    @IBAction func showArrivingTime(_ sender: AnyObject) {
        
//        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: NSBundle.mainBundle())
//        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewControllerWithIdentifier("DatePickerPopViewController") as! DatePickerPopViewController
//        self.pickerTypeForShowing = dateTimePickerType
//        self.leaveDateType = .arrivingTYpe
//        dispatch_async(dispatch_get_main_queue()) {
//            
//            datePickerPopViewController.showInView(PoolContants.sharedInstance.getMainScreenView(), inController: self, withPickerType: dateTimePickerType, withDate: NSDate())
//        }
        
    }
    
    @IBAction func showDepartingTime(_ sender: AnyObject) {
//        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: NSBundle.mainBundle())
//        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewControllerWithIdentifier("DatePickerPopViewController") as! DatePickerPopViewController
//        self.pickerTypeForShowing = dateTimePickerType
//        self.leaveDateType = .departureType
//        dispatch_async(dispatch_get_main_queue()) {
//            if self.selectedArrvivalDate == nil {
//                self.selectedArrvivalDate = NSDate()
//            }
//            datePickerPopViewController.showInView(PoolContants.sharedInstance.getMainScreenView(), inController: self, withPickerType: dateTimePickerType, withDate: self.selectedArrvivalDate)
//        }
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
    @IBAction func createTrip(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
        
        
        if (self.checkNetworkStatus() == true) {
            if (self.validateAllEntries()) {
                self.createOfferPOSTDictionary()
            }
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tripTypeSelected(_ sender: AnyObject) {
        
        let segment : UISegmentedControl = sender as! UISegmentedControl
        
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
        
        let center = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        self.placePicker = GMSPlacePicker(config: config)
        
        let filter = GMSAutocompleteFilter.init()
        filter.country = "IN"
        filter.type = .city
        
        
        let fetcher = GMSAutocompleteFetcher.init(bounds: GMSCoordinateBounds.init(region: GMSVisibleRegion.init()), filter: filter)
        
        
        // 2
       // placePicker.pickPlace { (place: GMSPlace?, error: NSError?) -> Void in
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
                
                
                //  if self.selectedPlaceEntry == PlaceType.sourceType {
                
                self.sourceLocation  = LocationModal.init(locationDict: placeDict)
                self.labelSource.text = place.name
                //  self.labelRoute.text = ""
                //                }
                //                else {
                //                    self.destinationLocation  = LocationModal.init(locationDict: placeDict)
                //                    self.labelDestination.text = place.name
                //                    self.labelRoute.text = ""
                //                }
                //
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
        if (self.checkNetworkStatus() == true) {
            
            directionsAPI.delegate = self
            
            if self.sourceLocation.formatedAddress!.isEmpty {
                directionsAPI.from = PXLocation.coordinateLocation(CLLocationCoordinate2D.init(latitude: self.sourceLocation.latitude_val!, longitude: self.sourceLocation.longitude_val!))
            }
            else {
                directionsAPI.from = PXLocation.namedLocation(self.sourceLocation.formatedAddress!)
            }
            
            if self.destinationLocation.formatedAddress!.isEmpty {
                directionsAPI.to = PXLocation.coordinateLocation(CLLocationCoordinate2D.init(latitude: self.destinationLocation.latitude_val!, longitude: self.destinationLocation.longitude_val!))
            }
            else {
                directionsAPI.to = PXLocation.namedLocation(self.destinationLocation.formatedAddress!)
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
        else {
            
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MyFoodDetailsViewController: PXGoogleDirectionsDelegate {
    func googleDirectionsWillSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
        //NSLog("\(requestURL.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)")
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



extension MyFoodDetailsViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return seatsArray.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return String("\(seatsArray[row])")
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        print("PRINT THUS\(seatsArray[row])")
        self.numberOfSeats = seatsArray[row]
        //self.labelNumberOfSeats.text = "\(seatsArray[row])"
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(seatsArray[row])
            }
        }
    }
}

//extension CreateTripViewController : HSDatePickerViewControllerDelegate {
//
//    func hsDatePickerPickedDate(date: NSDate!) {
//
//        let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(date)
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



