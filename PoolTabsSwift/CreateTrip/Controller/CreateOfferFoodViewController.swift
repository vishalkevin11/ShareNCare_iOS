//
//  CreateOfferFoodViewController.swift
//  HungerFree
//
//  Created by Kevin Vishal on 11/8/16.
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
import Alamofire
//import KRProgressHUD

//enum PlaceType {
//    case sourceType
//    case destinationType
//}
//
enum LeaveDateType {
    case arrivingTYpe
    case departureType
    case expiryType
}

enum FoodType : Int {
    case vegType
    case nonvegType
}

class CreateOfferFoodViewController: UITableViewController, CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    var selectedRouteObj  : PXGoogleDirectionsRoute?
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    var reachability: Reachability?
    
    var activeTextfld : UITextField?
    var activeTextView : UITextView?
    
    var googleMapView: GMSMapView!
    
  //  var selectedPlaceEntry = PlaceType.sourceType
    
    var leaveDateType = LeaveDateType.arrivingTYpe
    //var foodType = FoodType.vegType
    
    var foodType = 0
    
    var seatsArray = [1,2,3,4,5,6,7,8]
    
    var selectedDate :Date? = Date()
    
    var selectedArrvivalDate :Date? = Date()
    var selectedDepartDate :Date? = Date()
    var selectedexpiryDate :Date? = Date()
    
    var  sourceLocation : LocationModal! = LocationModal()
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var txtFldFood: UITextField!
    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var lblTimeArrive: UILabel!
    @IBOutlet weak var lblTimeDepart: UILabel!
    @IBOutlet weak var txtAlternatePhoneNumber: UITextField!
    @IBOutlet weak var txtServesHowMAny: UITextField!
    @IBOutlet weak var txtViewFoodDescription: UITextView!
    @IBOutlet weak var labelExpiryDate: UILabel!
    @IBOutlet weak var foodTypeSegment: UISegmentedControl!
    
    
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
    
    
    var  strExpiryTime: String? = ""
    var  strDepartTime: String? = ""
    var  strArrivalTime: String? = ""
    
    var pickerTypeForShowing : DatePickerType = datePikerType
    
    
    @IBOutlet weak var viewWeekDay: UIView!
    @IBOutlet weak var pickerWeekDay: WeekDaysSegmentedControl!
    @IBOutlet weak var widthDepartureConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthArrivalConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTimeOuter: UIView!
    
    @IBOutlet weak var placeholderImageforpic: UIImageView!
    

    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var weekDaySegment: UISegmentedControl!
    
    @IBOutlet weak var photoButton: UIButton!
    
    // MARK: Deinit
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
    }
    
    
    // MARK: View Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create Offer"
        
        //  self.pickerWeekDay.showSmallText = false
        self.latitude = 0.0
        self.longitude = 0.0
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        initialize()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateOfferFoodViewController.dateandTimeReturned), name: NSNotification.Name(rawValue: "FilerSelecetedDateValue"), object: nil)
        
    }
    

    
 //   var photo: MBPhotoPicker?
    
     func didTapPhotoPicker() {
      /*  photo = MBPhotoPicker()
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
            self.imageViewFood.image = image;
            self.placeholderImageforpic.image = nil
        }
        photo?.cancelCompletionHandler = {
            print("Cancel Pressed")
            self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
            
        }
        photo?.errorCompletionHandler = { (error: MBPhotoPicker.ErrorPhotoPicker!) -> Void in
            print("Error: \(error.rawValue)")
            self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
        }
        photo?.present(self)*/
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activeTextView?.resignFirstResponder()
        self.activeTextfld?.resignFirstResponder()
    }
    

    
    // MARK: Initializers
    
    
    
    func initialize() -> Void {
        
        self.foodTypeSegment.selectedSegmentIndex = 0
        self.foodType = 0
        self.pickerWeekDay.daysString = "1111100"
        self.pickerWeekDay.borderColor = PoolContants.appPaleGreenColor
        self.pickerWeekDay.textColor = PoolContants.appPaleGreenColor
        self.viewWeekDay.isHidden = true
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()
      //  self.widthDepartureConstraint.constant = 0.0
        self.widthArrivalConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.widthDepartureConstraint.constant = PoolContants.sharedInstance.getMainScreenWidth()/2.0
        self.viewTimeOuter.layoutSubviews()
        
      //  self.numberOfSeats = 1
      //  self.travellerTypeValue = 1
        self.tripTypeValue = 1
       // self.scheduleTypeValue = 1
        
        self.selectedDate = Date()
        
        
        let dateValue : String =  PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDate)
        self.strTime = dateValue
        
        self.labelTime.text = dateValue
        
        
        //let dateTimeValue : String =  PoolContants.sharedInstance.getFormatedTimeFromDate(self.selectedDate)
        
        // self.strTime = dateTimeValue
        
        
        //  self.strArrivalTime = dateTimeValue
        
        
        self.selectedArrvivalDate = Date()
        
        
        self.strArrivalTime = PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedArrvivalDate)
        self.lblTimeArrive.text = self.strArrivalTime!
        
                let calendar = Calendar.current
                let newDepartdate = (calendar as NSCalendar).date(byAdding: .minute, value: 30, to: self.selectedArrvivalDate!, options: [])
        //
        
        self.selectedDepartDate =  newDepartdate // PoolContants.sharedInstance.getDateFromUNIXTimeStamp(self.currentEditingTrip.pickby_date!)
        
        self.strDepartTime = PoolContants.sharedInstance.getFormatedStringFromDate(self.selectedDepartDate)
        self.lblTimeDepart.text = self.strDepartTime!
        
        
        
//        self.strArrivalTime = self.getIntialArrivalTime()
//        self.lblTimeArrive.text = self.strArrivalTime!
//        
//        let calendar = NSCalendar.currentCalendar()
//        let newDepartdate = calendar.dateByAddingUnit(.Minute, value: 30, toDate: self.selectedDate!, options: [])
//        
//        
//        // self.strDepartTime = PoolContants.sharedInstance.getFormatedTimeFromDate(newDepartdate)
//        
//        self.strDepartTime = self.getIntialDepatTime()
//        self.lblTimeDepart.text = self.strDepartTime!
//        
        
        self.labelSource.text = "Address :"
        self.imageViewFood.image = nil
        self.txtFldFood.text = ""
        self.txtViewFoodDescription.text = ""
        self.txtServesHowMAny.text = "1"
        self.txtAlternatePhoneNumber.text = AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        
        self.placeholderImageforpic.image = UIImage.init(named: "placeholder_camera_icon")
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
      //  self.destinationLocation.formatedAddress = ""
        self.sourceLocation.latitude_val = 0.0
        self.sourceLocation.longitude_val = 0.0
//        self.destinationLocation.latitude_val = 0.0
//        self.destinationLocation.longitude_val = 0.0
//        self.strTotalTime = ""
//        self.strTotalDistance = ""
//        self.strRouteVia = ""
    }
    
    
    
    func getIntialArrivalTime() -> String {
        let dateString = "09:00" // change to your date format
        
        //        var dateFormatter = NSDateFormatter()
        //        dateFormatter.dateFormat = "HH:mm"
        //
        //        var date = dateFormatter.dateFromString(dateString)
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
    
    
    // MARK: Upload Image
    
    func uploadImageToServer(_ foodId : Double ,completion: @escaping (Bool) -> Void)->Void {
        
        
        if  imageViewFood.image != nil {
        
//            //            / upload(
//            _ fileURL: URL,
//            to url: URLConvertible,
//            method: HTTPMethod = .post,
//            headers: HTTPHeaders? = nil)
//            -> UploadRequest
            
            
            
            
            
            
            
            Alamofire.upload(multipartFormData: { (MultipartFormData) in
          
            let firstPhoto : UIImage = self.imageViewFood.image!
            //   if (firstPhoto != nil) {
            if  let firstImageData = UIImagePNGRepresentation(firstPhoto) {
            print("uploading image");
            
                
                MultipartFormData.append(firstImageData, withName: "file", mimeType: "image/png")
//            MultipartFormData.appendBodyPart(data: firstImageData, name: "file", fileName: "\(Int(foodId))_file.png", mimeType: "image/png")
            
            }
            
            }, to: "\(kBaseURLString)upload_image.php", method: .post, headers: nil, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                print("Запрос отправлен")
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if var JSON = response.result.value as? NSDictionary {
                        print("JSON: \(JSON)")
                        if (JSON["status_code"] as? Int)!  == 200 {
                            completion(true)
                            return
                        }
                        else {
                            completion(false)
                            return
                        }
                    }
                    
                }
                
            case .failure(let encodingError):
                print("fffff \(encodingError)")
                completion(false)
            }
            
            
       /*     Alamofire.upload(.POST, "\(kBaseURLString)upload_image.php", multipartFormData: {
                multipartFormData in
                //let firstPhoto : UIImage = UIImage.init(named: "unnamed-3.png")!
                let firstPhoto : UIImage = self.imageViewFood.image!
                //   if (firstPhoto != nil) {
                if  let firstImageData = UIImagePNGRepresentation(firstPhoto) {
                    print("uploading image");
                    //multipartFormData.appendBodyPart(data: firstImageData, name: "unnamed-3.png", fileName: "unnamed-3", mimeType: "image/png")
                    
                    multipartFormData.appendBodyPart(data: firstImageData, name: "file", fileName: "\(Int(foodId))_file.png", mimeType: "image/png")
                    
                    //multipartFormData.appendBodyPart(fileURL: <#T##NSURL#>, name: <#T##String#>, fileName: <#T##String#>, mimeType: <#T##String#>)
                }
                
//                let secondPhoto : UIImage = UIImage.init(named: "unnamed-4.png")!
//                if  let secondImageData = UIImagePNGRepresentation(secondPhoto) {
//                    print("uploading image");
//                    multipartFormData.appendBodyPart(data: secondImageData, name: "file", fileName: "file.png", mimeType: "image/png")
//                    
//                }
                
                }, encodingCompletion: {
                    encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        print("Запрос отправлен")
                        upload.responseJSON { response in
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            
                            if var JSON = response.result.value as? NSDictionary {
                                print("JSON: \(JSON)")
                                if (JSON["status_code"] as? Int)!  == 200 {
                                     completion(true)
                                    return
                                }
                                else {
                                     completion(false)
                                    return
                                }
                            }
                           
                        }
                        
                    case .Failure(let encodingError):
                        print("fffff \(encodingError)")
                        completion(false)
                    }
            })*/
                })
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
    
    
    func uploadFoodImage(_ food_id : Double) -> Void {
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        
        self.uploadImageToServer(food_id) { (isdone) in
            if isdone {
                
             //   self.uploadRestDetailsToserver()
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                
                var alertTitle = ""
                var alertMess = "Successfully created offer."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                    
                    self.initialize()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                
                var alertTitle = ""
                var alertMess = "Failed to upload image, Please try again."
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
/*    func uploadRestDetailsToserver() -> Void {
        let postDictionary : NSMutableDictionary = NSMutableDictionary()
        
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserName(), forKey: kPostOfferName)
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserEmail(), forKey: kPostOfferEmail)
        postDictionary.setObject(AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber(), forKey: kPostOfferPhonenumber)
        
        postDictionary.setObject(self.txtFldFood.text!, forKey: kPostOfferItemName)
        
        let unixTimeStamp = NSDate().timeIntervalSince1970
        
        postDictionary.setValue(Int(unixTimeStamp), forKey: kPostOfferUniqueID)
        postDictionary.setValue(0, forKey: kPostOfferReportedabuse)
        postDictionary.setObject(self.txtAlternatePhoneNumber.text!, forKey: kPostOfferAlternate_phonenumber)
        
        if ((self.txtViewFoodDescription.text != nil) || (self.txtViewFoodDescription.text!.isEmpty == false)) {
            postDictionary.setObject(self.txtViewFoodDescription.text!, forKey: kPostOfferDescription)
        }
        else {
            postDictionary.setObject("", forKey: kPostOfferDescription)
        }
        postDictionary.setValue(0, forKey: kPostOfferIsTaken)
        postDictionary.setValue(0, forKey: kPostOfferIsBooked)
        postDictionary.setValue("\(self.selectedArrvivalDate!.timeIntervalSince1970)", forKey: kPostOfferPickAtDate)
        postDictionary.setValue("\(self.selectedDepartDate!.timeIntervalSince1970)", forKey: kPostOfferPickByDate)
        postDictionary.setObject(self.sourceLocation.formatedAddress!, forKey: kPostOfferAddress)
        postDictionary.setObject(self.txtServesHowMAny.text!, forKey: kPostOfferServesCount)
        
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject!> = Dictionary<String,AnyObject!>()
        for key  in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.objectForKey(stringKey){
                swiftDict[stringKey] = keyValue
            }
        }
        
        
        myTripsNetworkManager.createOffer(swiftDict) { (responseTrips : AnyObject?, error : NSError?) in
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
                dispatch_async(dispatch_get_main_queue()) {
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
 */
    func createPOSTDictionary() -> Void {
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
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
        postDictionary.setValue(self.sourceLocation.latitude_val!, forKey: kPostOfferLatitude)
        postDictionary.setValue(self.sourceLocation.longitude_val!, forKey: kPostOfferLongitude)
        postDictionary.setValue("\(self.selectedArrvivalDate!.timeIntervalSince1970)", forKey: kPostOfferPickAtDate)
        postDictionary.setValue("\(self.selectedDepartDate!.timeIntervalSince1970)", forKey: kPostOfferPickByDate)
        postDictionary.setObject(self.sourceLocation.formatedAddress!, forKey: kPostOfferAddress as NSCopying)
        postDictionary.setObject(self.txtServesHowMAny.text!, forKey: kPostOfferServesCount as NSCopying)
        
        postDictionary.setValue("\(self.selectedexpiryDate!.timeIntervalSince1970)", forKey: kPostExpiryDate)
        postDictionary.setValue(self.foodType, forKey: kPostFoodType)
        
        
        // POST TO SERVER
        
        var swiftDict : Dictionary<String,AnyObject?> = Dictionary<String,AnyObject!>()
        for key in postDictionary.allKeys {
            let stringKey = key as! String
            if let keyValue = postDictionary.object(forKey: stringKey){
                swiftDict[stringKey] = keyValue as AnyObject??
            }
        }
        
        
        myTripsNetworkManager.createOffer(swiftDict as (Dictionary<String, AnyObject>)?) { (food_id : AnyObject?, error : NSError?) in
            var alertMess  = ""
            var alertTitle  = ""
           
            if (error == nil) && (food_id != nil) {
                
                let food_returne_id = food_id as! Double
                DispatchQueue.main.async {
                    PoolContants.sharedInstance.dismiss()
                }
                
                if (self.imageViewFood.image != nil) {
                self.uploadFoodImage(food_returne_id)
                }
                else {
                    var alertTitle = ""
                    var alertMess = "Successfully created offer."
                    let alert = PopupViewController(title: alertTitle, message: alertMess)
                    alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(actionaa : PopupAction) in
                        
                        self.initialize()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
               
                //                }
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
         else if((pickerTypeForShowing == datePikerType) && (self.leaveDateType == .expiryType)) {
            self.selectedexpiryDate = pickerSelectedDate
            self.labelExpiryDate.text = pickerSelectedDisplayValue
            self.strExpiryTime = pickerSelectedValue
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
     self.activeTextView = textView
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView?.resignFirstResponder()
     textView.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextfld = textField
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activeTextfld?.resignFirstResponder()
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
            return 60.0
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 180.0
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 60.0
            }
            else if (indexPath.row == 1) {
                return 74.0
            }
            else if (indexPath.row == 2) {
                return 74.0
            }
        }
        else
            if (indexPath.section == 2) {
                if ((indexPath.row == 0) || (indexPath.row == 3) || (indexPath.row == 5)) {
                    return 80.0
                }
                else if ((indexPath.row == 1) || (indexPath.row == 2)  || (indexPath.row == 4) ) {
                    return 60.0
                }
                return 0.0
        }
        
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.activeTextfld?.resignFirstResponder()
        self.activeTextView?.resignFirstResponder()
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.didTapPhotoPicker()
                break
            default: break
            }
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                self.openCategoryPicker()
                break
            case 2:
                self.searchSource()
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
         else   if ((self.labelExpiryDate.text == nil) || (self.labelExpiryDate.text?.isEmpty == true)) {
            
            let alert = PopupViewController(title: "", message: "Please provide valid expiry date.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }

        return true
    }
    
    
    // MARK: Prepare For Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showCategoryPicker" {
            
            var productTypeSelectionVC : ProductTypeSelectionViewController = segue.destination as! ProductTypeSelectionViewController
            productTypeSelectionVC.createOfferFoodViewController = self
        }
    }
    
    // MARK: Delegate from Product Selction View
    
    func productSelectedView(productID : Int?) -> Void {
        print("productID \(productID!)")
        self.labelProductType.text = "Product Type : \(PoolContants.sharedInstance.getProductTypeId(prodId: productID!))"
        self.foodType = productID!
    }
    
    // MARK:  Actions
    
    @IBAction func foodTypeChanged(_ sender: AnyObject) {
        
//        let segment = sender as! UISegmentedControl
//        if  segment.selectedSegmentIndex == 0 {
//            self.foodType = .vegType
//            print("VEG")
//        }
//        else {
//            self.foodType = .nonvegType
//            print("NON-VEG")
//        }
    }
    
    func  openCategoryPicker() -> Void {
        self.performSegue(withIdentifier: "showCategoryPicker", sender: self)
    }
    
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
    
    @IBAction func showExpiryPicker(_ sender: AnyObject) {
        self.activeTextView?.resignFirstResponder()
        self.activeTextfld?.resignFirstResponder()
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = datePikerType
        self.leaveDateType = .expiryType
        DispatchQueue.main.async {
            
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: datePikerType, with: Date())
        }
    }
    
    @IBAction func showArrivingTime(_ sender: AnyObject) {
        self.activeTextView?.resignFirstResponder()
        self.activeTextfld?.resignFirstResponder()
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = dateTimePickerType
        self.leaveDateType = .arrivingTYpe
        DispatchQueue.main.async {
            
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: dateTimePickerType, with: Date())
        }
        
    }
    
    @IBAction func showDepartingTime(_ sender: AnyObject) {
        self.activeTextView?.resignFirstResponder()
        self.activeTextfld?.resignFirstResponder()
        let storyboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        let datePickerPopViewController : DatePickerPopViewController = storyboard.instantiateViewController(withIdentifier: "DatePickerPopViewController") as! DatePickerPopViewController
        self.pickerTypeForShowing = dateTimePickerType
        self.leaveDateType = .departureType
        DispatchQueue.main.async {
            if self.selectedArrvivalDate == nil {
                self.selectedArrvivalDate = Date()
            }
            datePickerPopViewController.show(in: PoolContants.sharedInstance.getMainScreenView(), in: self, with: dateTimePickerType, with: self.selectedArrvivalDate)
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
    @IBAction func createTrip(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
        

        if (self.checkNetworkStatus() == true) {
            if (self.validateAllEntries()) {
                self.createPOSTDictionary()
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
       //  placePicker.pickPlace { (place: GMSPlace?, error: NSError?) -> Void in
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
                    self.labelSource.text = place.formattedAddress
                self.latitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
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
        
        self.activeTextView?.resignFirstResponder()
        self.activeTextfld?.resignFirstResponder()
        
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

extension CreateOfferFoodViewController: PXGoogleDirectionsDelegate {
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



extension CreateOfferFoodViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    
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



