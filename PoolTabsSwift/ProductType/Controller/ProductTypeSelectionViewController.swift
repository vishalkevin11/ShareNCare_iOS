//
//  ProductTypeSelectionViewController.swift
//  ShareNCare
//
//  Created by Kevin Vishal on 1/29/17.
//  Copyright © 2017 TuffyTiffany. All rights reserved.
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


class ProductTypeSelectionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableViewProduct: UITableView!
    @IBOutlet weak var openGooglePickerBtn: UIButton!
    @IBOutlet weak var clearPlaceSearchedBtn: UIButton!
    @IBOutlet weak var placenamesearched: UILabel!
    
    
    var createOfferFoodViewController: CreateOfferFoodViewController?
    
    var locationManager: CLLocationManager!
    var placePicker: GMSPlacePicker!
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    
    var  sourceLocation : LocationModal! = LocationModal()
    var selectedCategoryType : Int! = 0
    var arrayTrip : [ProductType]? = []
    var arrayDatasource : [ProductType]? = []
    var selectedTrip : ProductType?
    //    var allDetailsVC : TripDetailsBaseViewController?
    
    var reachability: Reachability?
    
    
   // var productIdSelected : Int?
    
    
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.fetchAllProductTypes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchAllProductTypes() -> Void {
        PoolContants.sharedInstance.show()
        myTripsNetworkManager.getAllProductType { (responseTrips : AnyObject?, error : NSError?) in
            PoolContants.sharedInstance.dismiss()
            var alertMess  = ""
            var alertTitle  = ""
            
            if (error == nil) && (responseTrips != nil) {
                
                let trips = responseTrips as! NSArray
                self.reloadTrips(trips)
                if trips.count > 0 {
                    //self.reloadTrips(trips)
                    return
                }
                else {
                    alertTitle = ""
                    alertMess = "Sorry, No items found on our server."
                }
            }
            else {
                alertTitle = ""
                alertMess = "Failed To fetch trips"
            }
            
            
            //alert.iconType = OpinionzAlertIconSuccess;
            //alert.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
            
            //            let alertPopup : OpinionzAlertView = OpinionzAlertView.init(title: alertTitle, message: alertMess, cancelButtonTitle: "OK", otherButtonTitles: nil)
            //            //alertPopup.color = UIColor.init(red: 0.61, green: 0.35, blue: 0.71, alpha: 1)
            //            alertPopup.iconType = OpinionzAlertIconWarning
            //            alertPopup.show()
            
            
            let alert = PopupViewController(title: alertTitle, message: alertMess)
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK:  Reload
    
    func reloadTrips(_ trips : NSArray?) -> Void {
        
        DispatchQueue.main.async {
            //
            //            let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
            //            let  travellerTypeValue : Int? = (cacheDefaults.valueForKey(kCacheTravellerTypeName) != nil) ? (cacheDefaults.valueForKey(kCacheTravellerTypeName) as? Int) : 1
            
            //        if ((travellerTypeValue == 1) ||  (travellerTypeValue == 0)){
            //            self.viewSegementBase.setSelectedIndex(0, animated: true)
            //
            //        }
            //        else {
            //            self.viewSegementBase.setSelectedIndex(1, animated: true)
            //
            //        }
            //
            
            
            self.arrayTrip = NSArray(array: trips!) as? [ProductType]
            
            // self.generateDatasource()
            self.tableViewProduct.reloadData();
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayTrip?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ProductTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductTypeTableViewCell", for: indexPath) as! ProductTypeTableViewCell
        let productCategory = self.arrayTrip?[indexPath.row]
        cell.labelProductType.text = productCategory!.categorytype!
        let baseImageUrl = "\(kBaseURLString)icons/\(productCategory!.imageurl!)"
        cell.imageViewProductType.sd_setImage(with: URL(string: baseImageUrl), placeholderImage:UIImage.init(named: "placeholder"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let tripStoryboard : UIStoryboard = UIStoryboard.init(name: "AllTripsStoryboard", bundle: Bundle.main)
//        
//        let allFoodItemsViewController : AllFoodItemsViewController  = tripStoryboard.instantiateViewController(withIdentifier: "AllFoodItemsViewController") as! AllFoodItemsViewController
        let productCategory = self.arrayTrip?[indexPath.row]
//        
//        allFoodItemsViewController.globalSourceLocation = self.sourceLocation!
        self.selectedCategoryType = productCategory?.typeid!
//        allFoodItemsViewController.globalCategoryType = productCategory?.typeid!
//        
//        self.navigationController?.pushViewController(allFoodItemsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: Fetch Locations
    
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
                self.placenamesearched.text = place.name
                self.latitude = place.coordinate.latitude
                self.longitude = place.coordinate.longitude
                
                //     print("Address \(place.addressComponents.)")
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
    
    
    // MARK: Button actions
    
    @IBAction func openGooglePicker(_ sender: Any) {
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
    
    @IBAction func clearPlaceSearched(_ sender: Any) {
        
        self.sourceLocation  = LocationModal.init(locationDict: [:])
        self.placenamesearched.text = "Search Globally..."
        
    }
    @IBAction func selctCatory(_ sender: Any) {
        self.dismiss(animated: true) { 
            self.createOfferFoodViewController?.productSelectedView(productID: self.selectedCategoryType!)
        }
    }
    
    @IBAction func cancelPopUp(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
}
