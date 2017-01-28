//
//  ProductTypeViewController.swift
//  ShareNCare
//
//  Created by Kevin Vishal on 1/27/17.
//  Copyright © 2017 TuffyTiffany. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ProductTypeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableViewProduct: UITableView!
    @IBOutlet weak var openGooglePickerBtn: UIButton!
    @IBOutlet weak var clearPlaceSearchedBtn: UIButton!
    @IBOutlet weak var placenamesearched: UILabel!
    
    var arrayTrip : [ProductType]? = []
    var arrayDatasource : [ProductType]? = []
    var selectedTrip : ProductType?
//    var allDetailsVC : TripDetailsBaseViewController?
    
    var reachability: Reachability?
    
    
    
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
        cell.labelProductSubType.text = ""
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tripStoryboard : UIStoryboard = UIStoryboard.init(name: "AllTripsStoryboard", bundle: Bundle.main)
        
        let allFoodItemsViewController : AllFoodItemsViewController  = tripStoryboard.instantiateViewController(withIdentifier: "AllFoodItemsViewController") as! AllFoodItemsViewController
        
        self.navigationController?.pushViewController(allFoodItemsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Button actions
    
    @IBAction func openGooglePicker(_ sender: Any) {
    }
    @IBAction func clearPlaceSearched(_ sender: Any) {
    }

}
