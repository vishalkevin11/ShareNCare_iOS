//
//  AllFoodItemsViewController.swift
//  HungerFree
//
//  Created by Kevin Vishal on 11/8/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

//import DGRunkeeperSwitch
//import Presentr
//import OpinionzAlertView
//import PopupViewController
import ReachabilitySwift
//import KRProgressHUD
import SDWebImage

class AllFoodItemsViewController: UIViewController {
    
    
    var arrayTrip : [FoodItem]? = []
    var arrayDatasource : [FoodItem]? = []
    var selectedTrip : FoodItem?
    var allDetailsVC : TripDetailsBaseViewController?
    
    var reachability: Reachability?
    
    var selectedImageData : Data?
    
    @IBOutlet weak var travellerSegment: UISegmentedControl!
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    @IBOutlet weak var tableViewAllTrips: UITableView!
    //@IBOutlet weak var viewSegementBase: DGRunkeeperSwitch!
    @IBOutlet weak var btnFilterTheResults: UIBarButtonItem!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var labelNoTrips: UILabel!
    
    
    
    var isMyTripsTab = false
    
    
//    let presenter: Presentr = {
//        let presenter = Presentr(presentationType: .Alert)
//        presenter.transitionType = TransitionType.CoverHorizontalFromRight
//        return presenter
//    }()
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController : UITabBarController = appDelegate.window?.rootViewController as! UITabBarController
        
        
        if tabBarController.selectedIndex == 0 {
            self.isMyTripsTab = false
        }
        else {
            self.isMyTripsTab = true
        }
        
        
        self.tableViewAllTrips.alpha = 1.0
        self.labelNoTrips.alpha = 0.0
        
        //        arrayTrip = [Trip]
        //        arrayDatasource = NSArray()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AllFoodItemsViewController.fetchAllFoodItems), name: NSNotification.Name(rawValue: K_NOTIFICATION_FILTER_TRIPS), object: nil)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        //        self.viewSegementBase.titles = ["OFFERER", "SEEKER"]
        //        //self.viewSegementBase.rightTitle = "SEEKER"
        //        self.viewSegementBase.selectedBackgroundColor = .whiteColor()
        //        self.viewSegementBase.titleColor = .whiteColor()
        //        self.viewSegementBase.selectedTitleColor =  UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        //        self.viewSegementBase.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        //        //self.viewSegementBase.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        //        self.viewSegementBase.addTarget(self, action: #selector(AllTripsViewController.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        //
        //       // self.view?.backgroundColor = UIColor(red: 252.0/255.0, green: 182.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        //        self.viewSegementBase.backgroundColor = UIColor.clearColor()// UIColor(red: 252.0/255.0, green: 182.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        
        // self.viewSegementBase.setSelectedIndex(0, animated: true)
    }
    
    
    //    func reachabiltyInitializatin() -> Void {
    //        do {
    //            reachability = try Reachability.reachabilityForInternetConnection()
    //        } catch {
    //            print("Unable to create Reachability")
    //            return
    //        }
    //
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeTabbBarController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
    //        do{
    //            try reachability?.startNotifier()
    //        }catch{
    //            print("could not start reachability notifier")
    //        }
    //    }
    //
    
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController : UITabBarController = appDelegate.window?.rootViewController as! UITabBarController
        
        
        if tabBarController.selectedIndex == 0 {
            self.isMyTripsTab = false
            self.title = "All Offerings"
        }
        else {
            self.isMyTripsTab = true
            self.title = "My Offerings"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        
      

        if (AppCacheManager.sharedInstance.isFilterSet()) {
            // self.btnFilterTheResults.setBackgroundImage(UIImage.init(imageLiteral: "filter_selected"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
            //   self.btnFilter.setBackgroundImage(UIImage.init(imageLiteral: "filter_selected"), for: UIControlState())
            self.btnFilter.setBackgroundImage(UIImage.init(named: "filter_selected"), for: UIControlState.normal)
        }
        else {
            //self.btnFilterTheResults.setBackgroundImage(UIImage.init(imageLiteral: "filter_normal"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
            //self.btnFilter.setBackgroundImage(UIImage.init(imageLiteral: "filter_normal"), for: UIControlState())
            self.btnFilter.setBackgroundImage(UIImage.init(named: "filter_normal"), for: UIControlState.normal)
        }
        
       
//        if (AppCacheManager.sharedInstance.isFilterSet()) {
//            // self.btnFilterTheResults.setBackgroundImage(UIImage.init(imageLiteral: "filter_selected"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
//            self.btnFilter.setBackgroundImage(UIImage.init(imageLiteral: "filter_selected"), for: UIControlState())
//        }
//        else {
//            //self.btnFilterTheResults.setBackgroundImage(UIImage.init(imageLiteral: "filter_normal"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
//            self.btnFilter.setBackgroundImage(UIImage.init(imageLiteral: "filter_normal"), for: UIControlState())
//        }
//        
        //  self.reachabiltyInitializatin()
        
        if (self.checkNetworkStatus() == true) {
            self.fetchAllFoodItems()
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //  self.title = ""
    }
    
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: K_NOTIFICATION_FILTER_TRIPS), object: nil)
    }
    
    
    // MARK: fetch Trip
    
    func fetchAllFoodItems() -> Void {
        PoolContants.sharedInstance.show()
        myTripsNetworkManager.getAllFoodItems { (responseTrips : AnyObject?, error : NSError?) in
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
            
            
            self.arrayTrip = NSArray(array: trips!) as? [FoodItem]
            
            self.generateDatasource()
            self.tableViewAllTrips.reloadData();
            
        }
    }
    
    
    func generateDatasource() -> Void {
        
        
        //TODO: Make to one
//        if self.travellerSegment.selectedSegmentIndex == 0 {
//            self.labelNoTrips.text = "No offerers found !!!"
//            self.arrayDatasource = arrayTrip!.filter({
//                $0.traveller_type == 1
//            })
//        }
//        else {
//            self.labelNoTrips.text = "No seekers found !!!"
//            self.arrayDatasource = arrayTrip!.filter({
//                $0.traveller_type == 2
//            })
//        }
        
        let loggedInPhone = AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        
        if isMyTripsTab == true {
            self.arrayDatasource = arrayTrip!.filter({
                $0.phonenumber == loggedInPhone
            })
        }
        else {
            self.arrayDatasource = arrayTrip!
        }
       
        self.labelNoTrips.text = "No Food Items Found"
        
        if arrayDatasource?.count == 0 {
            self.tableViewAllTrips.alpha = 0.0
            self.labelNoTrips.alpha = 1.0
        }
        else {
            self.tableViewAllTrips.alpha = 1.0
            self.labelNoTrips.alpha = 0.0
        }
    }
    
    
    /*
     
     
     - (void)alertView:(OpinionzAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     
     NSLog(@"buttonIndex: %li", (long)buttonIndex);
     NSLog(@"buttonTitle: %@", [alertView buttonTitleAtIndex:buttonIndex]);
     }
     
     */
    
    
    
    
    
    
    // MARK: TableView Methods
    
    
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDatasource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyTripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyTripTableViewCell", for: indexPath) as! MyTripTableViewCell
        let tempTrip : FoodItem = self.arrayDatasource![indexPath.row]
        
        
        var profile = ProfileAvatarImageViewDataSource()
        profile.name = PoolContants.sharedInstance.getNameFromEmailStr(tempTrip.email!)
        //print("pfff \(profile.name)")
        //cell.imageViewthumb.dataSource = profile
        
        
        var baseImageUrl = "\(kBaseURLString)uploads/\(tempTrip.image_name!)"
        print("baseulr \(baseImageUrl)")
        cell.imageViewthumb.sd_setImage(with: URL(string: baseImageUrl), placeholderImage:UIImage.init(named: "placeholder"))

        
        
        //        var profile : ProfileAvatarImageViewDataSource = ProfileAvatarImageViewDataSource()
        //        profile.assignNameToImage(tempTrip.email_val!)
        //        cell.imageViewthumb.dataSource = profile
        
        
        cell.deleteOverayView.isHidden = true
        if PoolContants.sharedInstance.checkThisTripIsMine(tempTrip.phonenumber!) {
            if (tempTrip.ispending! == 1) {
                cell.imageViewGreen.isHidden = false
                cell.labelTimeStamp.text = "Pending Approval"
            }
            else {
                cell.imageViewGreen.isHidden = false
                cell.labelTimeStamp.text = "Yours"
            }
            if (tempTrip.istaken! == 1) {
                cell.labelTimeStamp.text = "Taken away"
                cell.imageViewGreen.isHidden = true
                cell.deleteOverayView.isHidden = false
            }
           
        }
        else if (tempTrip.istaken! == 1) {
            cell.labelTimeStamp.text = "Taken away"
            cell.imageViewGreen.isHidden = true
            cell.deleteOverayView.isHidden = false
        }
        else if (tempTrip.isbooked! == 1) {
            cell.labelTimeStamp.text = "Already booked"
            cell.imageViewGreen.isHidden = true
        }
        else if (tempTrip.ispending! == 1) {
            cell.labelTimeStamp.text = "Pending Approval"
            cell.imageViewGreen.isHidden = true
        }
        else {
            cell.labelTimeStamp.text = "Available"
            cell.imageViewGreen.isHidden = true
        }
        
        if  tempTrip.foodType == 0 {
            cell.baleFoodType.text = "Veg"
            cell.baleFoodType.backgroundColor = UIColor.init(colorLiteralRed: (15.0/255.0), green:  (112.0/255.0), blue:  (1.0/255.0), alpha: 1.0)
        }
        else {
            cell.baleFoodType.text = "Non-Veg"
            cell.baleFoodType.backgroundColor = UIColor.init(colorLiteralRed: (112.0/255.0), green:  (40.0/255.0), blue:  (25.0/255.0), alpha: 1.0)
        }
        
        
        cell.weekDayPicker.alpha =  0.0
   //     cell.labelTimeStamp.alpha = (tempTrip.schedule_type == 1) ? 1.0 : 0.0
        
        
        
        cell.labelFromLocation.text = tempTrip.itemname!
        cell.labelTolocation.text = tempTrip.name!
        
         let selectedArrvivalDate = PoolContants.sharedInstance.getDateFromUNIXTimeStamp(tempTrip.pickat_date!)
        let strArrivalTime = PoolContants.sharedInstance.getFormatedStringFromDate(selectedArrvivalDate)
       
        let selectedDepartDate = PoolContants.sharedInstance.getDateFromUNIXTimeStamp(tempTrip.pickby_date!)
        let strDepartTime = PoolContants.sharedInstance.getFormatedStringFromDate(selectedDepartDate)
        
        cell.labelVia.text = "From - \(strArrivalTime) Till - \(strDepartTime)"
        cell.labelDistanceDuration.text = tempTrip.address!
        
      // cell.labelVia.text = "Via.\(tempTrip.trip_via!)"
      //  cell.labelDistanceDuration.text = "Distance : \(tempTrip.total_trip_distance!), Time : \(tempTrip.total_trip_time!)"
       // cell.fillPicker(tempTrip)
//        var timeString = (tempTrip.trip_type! == 2) ? "Onward at : \(tempTrip.time_leaving_source!), Back at : \(tempTrip.time_leaving_destination!)" : "Start at :\(tempTrip.time_leaving_source!)"
    //    cell.labelDistanceDuration.text = timeString
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.selectedTrip = self.arrayDatasource![indexPath.row] as FoodItem
        
        let cell : MyTripTableViewCell = tableView.cellForRow(at: indexPath) as! MyTripTableViewCell
        self.selectedImageData = UIImagePNGRepresentation(cell.imageViewthumb.image!)
        
        
        if PoolContants.sharedInstance.checkThisTripIsMine(self.selectedTrip!.phonenumber!) {
            if self.selectedTrip?.istaken! == 0 {
                self.performSegue(withIdentifier: "showMyOffer", sender: self)
            }
            
        }
        else {
            self.performSegue(withIdentifier: "showAllOffers", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 138.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: Selectors
    
    @IBAction func switchValueDidChange(_ sender: AnyObject) {
        //        print("\(sender.selectedIndex)")
        self.generateDatasource()
        self.tableViewAllTrips.reloadData();
        
    }
    
    @IBAction func filterTheResults(_ sender: AnyObject) {
        
        let tripStoryboard : UIStoryboard = UIStoryboard.init(name: "AllTripsStoryboard", bundle: Bundle.main)
        
        
        //        let filterVc : FilterPopupViewController = tripStoryboard.instantiateViewControllerWithIdentifier("FilterPopupViewController") as! FilterPopupViewController
        
        let filterVc : FilterBaseViewController = tripStoryboard.instantiateViewController(withIdentifier: "FilterBaseViewController") as! FilterBaseViewController
        
        //  presenter.presentationType = .Popup
        
        //  presenter.transitionType = nil
        // customPresentViewController(presenter, viewController: filterVc, animated: true, completion: nil)
        self.present(filterVc, animated: true, completion: nil)
    }
    
    // MARK: Perform Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAllOffers" {
            let allFoodDetailsViewController : AllFoodDetailsViewController  = (segue.destination as? AllFoodDetailsViewController)!
            allFoodDetailsViewController.currentEditingTrip  = self.selectedTrip!
            allFoodDetailsViewController.previousImageData = self.selectedImageData!
        }
        else if segue.identifier == "showMyOffer" {
            let myFoodDetailsViewController : MyFoodDetailsViewController  = (segue.destination as? MyFoodDetailsViewController)!
            myFoodDetailsViewController.currentEditingTrip  = self.selectedTrip!
            myFoodDetailsViewController.previousImageData = self.selectedImageData!
        }
    }

}
