//
//  AppDelegate.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/18/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import PopupViewController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var directionsAPI: PXGoogleDirections!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.initializeUIElements()
        self.fetchTheInitialBaseURL()
        return true
    }
    
    
    
    func fetchTheInitialBaseURL() -> Void {
        AppCacheManager.sharedInstance.getTheBaseURL { (foundUrl) in
            if foundUrl == true {
                DispatchQueue.main.async(execute: { 
                  self.switchControllers()
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    
              
                    let alert = PopupViewController(title: "", message: "Something went wrong, Please restart the app.")
                    alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                        
                    }))
                    self.window?.rootViewController!.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    func switchControllers() -> Void {
        
        GMSServices.provideAPIKey("AIzaSyBYlV9fIYKemuLjp5VyBMa_YycGaWFBu2E")
        GMSPlacesClient.provideAPIKey("AIzaSyBYlV9fIYKemuLjp5VyBMa_YycGaWFBu2E")
        directionsAPI = PXGoogleDirections(apiKey: "AIzaSyBYlV9fIYKemuLjp5VyBMa_YycGaWFBu2E")
        
        if !AppCacheManager.sharedInstance.isLoggedIn() {
            
            let mainStoryboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let loginToTavantViewController : LoginToTavantViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginToTavantViewController") as! LoginToTavantViewController
            self.window?.rootViewController =  loginToTavantViewController
            
        }
        else {
            self.initialiseTabbarController()
        }
        
        
        
    }
    
    
    func initializeUIElements() -> Void {
        UINavigationBar.appearance().tintColor  = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navbg"), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "navshadow")
        UITabBar.appearance().tintColor = PoolContants.appPaleGreenColor
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    // MARK: Add controllers to tab
    
    
    func initialiseTabbarController() -> Void {
        
        let tabStoryboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let tabbar : UITabBarController  = tabStoryboard.instantiateViewController(withIdentifier: "TabbarController") as! UITabBarController
        
        
        //  let tabbar = self.window?.rootViewController as! UITabBarController
        
        let createTripStoryboard : UIStoryboard = UIStoryboard.init(name: "CreateTripStoryboard", bundle: Bundle.main)
        //   let createTripVC : CreateTripViewController  = createTripStoryboard.instantiateViewControllerWithIdentifier("CreateTripViewController") as! CreateTripViewController
        
        let createTripNavVC : UINavigationController  = createTripStoryboard.instantiateViewController(withIdentifier: "CreateTripNavViewController") as! UINavigationController
        
        
        let myTripStoryboard : UIStoryboard = UIStoryboard.init(name: "MyTripsStoryboard", bundle: Bundle.main)
        
        //let myTripVC : MyTripsViewController  = myTripStoryboard.instantiateViewControllerWithIdentifier("MyTripsViewController") as! MyTripsViewController
        
        let myTripNavVC : UINavigationController  = myTripStoryboard.instantiateViewController(withIdentifier: "MyTripsNavViewController") as! UINavigationController
        
        
        let profileStoryboard : UIStoryboard = UIStoryboard.init(name: "ProfileStoryboard", bundle: Bundle.main)
        
        //let profileVC : ProfileViewController  = profileStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        
        let profileNavVC : UINavigationController  = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavViewController") as! UINavigationController
        
        
        let productTypeStoryboard : UIStoryboard = UIStoryboard.init(name: "ProductTypeStoryboard", bundle: Bundle.main)
        
        
        
        //        let tripNavVC : UINavigationController  = tripStoryboard.instantiateViewController(withIdentifier: "AllFoodItemsNavViewController") as! UINavigationController
        
        
        let productTypeNavTripsVC : UINavigationController  = productTypeStoryboard.instantiateViewController(withIdentifier: "ProductTypeNavViewController") as! UINavigationController
        
        
        
        let tripStoryboard : UIStoryboard = UIStoryboard.init(name: "AllTripsStoryboard", bundle: Bundle.main)
        

        
//        let tripNavVC : UINavigationController  = tripStoryboard.instantiateViewController(withIdentifier: "AllFoodItemsNavViewController") as! UINavigationController
        
        
        let allMyfoodVC : AllFoodItemsViewController  = tripStoryboard.instantiateViewController(withIdentifier: "AllFoodItemsViewController") as! AllFoodItemsViewController
        
        var allMYfoodnav = UINavigationController.init(rootViewController: allMyfoodVC)
        
        tabbar.setViewControllers([productTypeNavTripsVC,createTripNavVC,allMYfoodnav,profileNavVC], animated: true)
        
        self.window?.rootViewController =  tabbar

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

