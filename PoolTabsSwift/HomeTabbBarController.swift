//
//  HomeTabbBarController.swift
//  TavantPool
//
//  Created by Kevin Vishal on 8/20/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import ReachabilitySwift
//import PopupViewController
//import HotBoxNotification

class HomeTabbBarController: UITabBarController { //,HotBoxDelegate {

  //  var reachability: Reachability?

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        HotBox.sharedInstance().settings = [
//            "failure": [ "backgroundColor": UIColor.init(colorLiteralRed: (255.0/255.0), green: (84.0/255.0), blue: (73.0/255.0), alpha: 1.0) ],
//            "warning": [ "backgroundColor": UIColor.yellowColor() ],
//            "success": [ "backgroundColor": UIColor.greenColor() ],
//        ]
        
        let tabBarItem0 : UITabBarItem = self.tabBar.items![0]
        tabBarItem0.title = "All Offerings"
        tabBarItem0.image = UIImage.init(named: "food_icon")
        tabBarItem0.selectedImage = UIImage.init(named: "food_icon")
        
        let tabBarItem1 : UITabBarItem = self.tabBar.items![1]
        tabBarItem1.title = "Create Offer"
        tabBarItem1.image = UIImage.init(named: "add_trip_icon")
        tabBarItem1.selectedImage = UIImage.init(named: "add_trip_icon")
        
        let tabBarItem2 : UITabBarItem = self.tabBar.items![2]
        tabBarItem2.title = "My Offers"
        tabBarItem2.image = UIImage.init(named: "refrigerator_icon")
        tabBarItem2.selectedImage = UIImage.init(named: "refrigerator_icon")
        
//        [tabBarItem0 setImage:[[UIImage imageNamed:@"iconGray.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem0 setSelectedImage:[[UIImage imageNamed:@"iconBlue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }
    
    
    func reachabiltyInitializatin() -> Void {
//        do {
//            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch {
//            print("Unable to create Reachability")
//            return
//        }
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(HomeTabbBarController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
//        do{
//            try reachability?.startNotifier()
//        }catch{
//            print("could not start reachability notifier")
//        }
        let reachability = Reachability()!
        
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTabbBarController.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reachabiltyInitializatin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Reachability
    
    func reachabilityChanged(_ note: Notification) {
        
        var alertText  = ""
        let reachability = Reachability()!
        if (reachability.isReachable) {
            if (reachability.isReachableViaWiFi) {
                //print("Reachable via WiFi")
                
            } else {
                //print("Reachable via Cellular")
            }
            alertText = "Network Connected."
            //  HotBox.sharedInstance().showMessage(NSAttributedString(string: alertText), ofType: "failure", withDelegate: self)
        } else {
            // //print("Network not reachable")
            alertText = "Lost Network Connection."
            //HotBox.sharedInstance().showMessage(NSAttributedString(string: alertText), ofType: "failure", withDelegate: self)
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: K_NOTIFICATION_FILTER_TRIPS), object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
