//
//  ProfileViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/22/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
//import PopupViewController
import ReachabilitySwift
import MessageUI
import AvatarImageView

struct TableAvatarImageConfig: AvatarImageViewConfiguration {
    let shape: Shape = .circle
}

let rowHeight : CGFloat = 74.0
let paddingForHeader : CGFloat  = 15.0
let navBarHeight : CGFloat  = 64.0
let footerHeight : CGFloat  = 55.0

class ProfileViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    var headerView : HeaderViewWithImage?
    var reachability: Reachability?
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelEmailId: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         self.view.backgroundColor = [UIColor lightGrayColor];
         
         self.headerView = [HeaderView instantiateFromNib];
         self.headerView.backgroundColor = [UIColor colorWithRed:0.59 green:0.85 blue:0.27 alpha:1];
         
         [self.tableView setParallaxHeaderView:self.headerView
         mode:VGParallaxHeaderModeTopFill
         height:200];
         */
        
        
        let screenHeight  = UIScreen.main.bounds.height
        let totalHeaderHeight = screenHeight - (3 * rowHeight) - paddingForHeader - navBarHeight - footerHeight
        
        
        self.view.backgroundColor = UIColor.white
        self.headerView = HeaderViewWithImage.instantiateFromNib()
        self.headerView!.backgroundColor = UIColor.white
        self.profileTable.setParallaxHeader(self.headerView!, mode: VGParallaxHeaderMode.topFill, height: totalHeaderHeight)
        self.headerView?.imageViewProfileIcon.configuration = TableAvatarImageConfig()
        
        var profile = ProfileAvatarImageViewDataSource()
        profile.name = AppCacheManager.sharedInstance.getLoggedInUserName()
       // print("pfff \(profile.name)")
        self.headerView?.imageViewProfileIcon.dataSource = profile
        
        initializeUiElements()
        
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
       // self.reachabiltyInitializatin()
        
        if (self.checkNetworkStatus() == true) {
        
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.profileTable.shouldPositionParallaxHeader()
    }
    
    
    
    func initializeUiElements() {
        
        self.labelEmailId.text =  AppCacheManager.sharedInstance.getLoggedInUserEmail()
        self.labelPhoneNumber.text =  AppCacheManager.sharedInstance.getLoggedInUserPhoneNumber()
        self.headerView?.labelUserName.text = AppCacheManager.sharedInstance.getLoggedInUserName()
        self.headerView?.labelUserRpleType.text = AppCacheManager.sharedInstance.getLoggedInUserRoleType()
    }

    
    // MARK: Feedback 
    
    @IBAction func sendFeedback(_ sender: AnyObject) {
        
     if (MFMailComposeViewController.canSendMail()) {
            let controller = MFMailComposeViewController()
            
            let delimiter = "@"
            
            let emailStr = "kevin.saldanha@tavant.com"
            
           // if ((emailStr != nil) && (emailStr?.isEmpty == false)) {
               // let userName = emailStr.componentsSeparatedByString(delimiter)
                controller.setSubject("Here is what I think about Tavant Pool !")
                //controller.setMessageBody("Hi \(userName[0])," + "\r\n" + "Can we pool together ?", isHTML: false)
            //}
//            else {
//                controller.setSubject("Lets pool !")
//                controller.setMessageBody("Hi," + "\r\n" + "Can we pool together ?", isHTML: false)
//            }
        
            
            controller.setToRecipients([emailStr])
            controller.mailComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let alert = PopupViewController(title: "Sorry", message: "E-mail cannot be sent at this time.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: SignOut 
    
    func signOutFromApp() -> Void {
        AppCacheManager.sharedInstance.logOutFormApp()
        
        DispatchQueue.main.async { 
            let alert = PopupViewController(title: "Logged Out !!!", message: "You Succesfully logged out from the app.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                AppCacheManager.sharedInstance.showLoggedInScreen()
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signOut(_ sender: AnyObject) {
        
        let alert = PopupViewController(title: "", message: "Do you really want to Sign-Out from Tavnat Pool ?")
        alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
        alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
            
            // Call deelet trip
            self.signOutFromApp()
        }))
        self.present(alert, animated: true, completion: nil)

        
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
 
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell : MyTripTableViewCell = tableView.dequeueReusableCellWithIdentifier("MyTripTableViewCell", forIndexPath: indexPath) as! MyTripTableViewCell
//        
//        cell.labelTimeStamp.text = "tempTrip.time_leaving_source"
//        return cell
//    }
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
}
