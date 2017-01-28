//
//  MyTripsViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/18/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
//import OpinionzAlertView
//import PopupViewController
import ReachabilitySwift
//import KRProgressHUD

class MyTripsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var arrayTrip : NSArray?
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    var detailsVC : TripDetailsBaseViewController?
    var selectedTrip : FoodItem?
    var reachability: Reachability?
    
    @IBOutlet weak var tableViewMyTrips: UITableView!
    @IBOutlet weak var labelNoTrips: UILabel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrayTrip = NSArray()
        self.tableViewMyTrips.alpha  = 1.0
      
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
        self.title = "My Trips"
        //self.reachabiltyInitializatin()
        
        if (self.checkNetworkStatus() == true) {
           self.fetchMyTrips()
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
       // self.title = ""
    }
    
    
    // MARK: fetch Trip
    
    func fetchMyTrips() -> Void {
        
        PoolContants.sharedInstance.show()
        myTripsNetworkManager.getMyTrips { (responseTrips : AnyObject?, error : NSError?) in
            
            var alertMess  = ""
            var alertTitle  = ""
            PoolContants.sharedInstance.dismiss()
            if (error == nil) && (responseTrips != nil) {
                
                let trips = responseTrips as! NSArray
                
                
                self.reloadTrips(trips)
                if trips.count > 0 {
                    
                    self.tableViewMyTrips.alpha  = 1.0
                    return
                }
                else {
                    self.tableViewMyTrips.alpha  = 0.0
                    alertTitle = ""
                    alertMess = "Sorry, No items found on our server."
                    return
                }
            }
            else {
                 self.tableViewMyTrips.alpha  = 0.0
                alertTitle = ""
                alertMess = "Failed To Fetch trip."
                return
            }
            
            //alert.iconType = OpinionzAlertIconSuccess;
            //alert.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
            
//            let alertPopup : OpinionzAlertView = OpinionzAlertView.init(title: alertTitle, message: alertMess, cancelButtonTitle: "OK", otherButtonTitles: nil)
//            //alertPopup.color = UIColor.init(red: 0.61, green: 0.35, blue: 0.71, alpha: 1)
//            alertPopup.iconType = OpinionzAlertIconWarning
//            alertPopup.show()
            
            let alert = PopupViewController(title: alertTitle, message: alertMess)
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action:PopupAction) in
                self.tableViewMyTrips.alpha  = 0.0
            }))
           // self.present(alert, animated: true, completion: nil)


            
        }
        
    }
    
    // MARK:  Reload
    
    func reloadTrips(_ trips : NSArray?) -> Void {
        
        
        DispatchQueue.main.async { 
            self.arrayTrip = NSArray.init(array: trips!)
            self.tableViewMyTrips.reloadData();
        }
        
       
    }
    
    // MARK: TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTrip!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyTripTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyTripTableViewCell", for: indexPath) as! MyTripTableViewCell
        let tempTrip : Trip = self.arrayTrip![indexPath.row] as! Trip
        
        //dispatch_async(dispatch_get_main_queue()) {
        //self.fillPicker(tempTrip,forCell: cell)
        //}
        
        cell.labelTimeStamp.text = tempTrip.tripDateSTR!
        cell.weekDayPicker.alpha = (tempTrip.schedule_type == 1) ? 0.0 : 0.0
        cell.labelTimeStamp.alpha = (tempTrip.schedule_type == 1) ? 1.0 : 0.0
        cell.fillPicker(tempTrip)
        
        cell.labelFromLocation.text = tempTrip.source_name!
        cell.labelTolocation.text = tempTrip.destination_name!
        cell.labelVia.text = "Via.\(tempTrip.trip_via!)"
     //   cell.labelDistanceDuration.text = "Distance : \(tempTrip.total_trip_distance!), Time : \(tempTrip.total_trip_time!)"
      //    self.fillPicker(tempTrip,forCell: cell)
         var timeString = (tempTrip.trip_type! == 2) ? "Onward at : \(tempTrip.time_leaving_source!), Back at : \(tempTrip.time_leaving_destination!)" : "Start at :\(tempTrip.time_leaving_source!)"
        cell.labelDistanceDuration.text = timeString
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTrip = self.arrayTrip![indexPath.row] as? FoodItem
         //let cell : MyTripTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! MyTripTableViewCell
      //  cell.weekDayPicker.daysString = "1011111"
        self.performSegue(withIdentifier: "showTripDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    // MARK: Perform Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTripDetails" {
            
            //            let tripStoryBoard = UIStoryboard.init(name: "MyTripsStoryboard", bundle: NSBundle.mainBundle())
            //            let detailsVC : TripDetailsBaseViewController = tripStoryBoard.instantiateViewControllerWithIdentifier("TripDetailsBaseViewController") as! TripDetailsBaseViewController
            self.detailsVC  = segue.destination as? TripDetailsBaseViewController
            self.detailsVC?.isMyTrip = true
            self.detailsVC?.currentTrip  = self.selectedTrip!
          //  self.detailsVC?.fromLocation = (self.selectedTrip?.source_name! != nil) ? self.selectedTrip?.source_name! : "NA"
          //  self.detailsVC?.toLocation = (self.selectedTrip?.destination_name!  != nil) ? self.selectedTrip?.destination_name! : "NA"
        }
    }
}
