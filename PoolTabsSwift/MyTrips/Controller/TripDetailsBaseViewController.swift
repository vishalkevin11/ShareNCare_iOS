//
//  TripDetailsBaseViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/3/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import MessageUI
//import PopupViewController
//import KRProgressHUD
import ReachabilitySwift

class TripDetailsBaseViewController: UIViewController,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    
    @IBOutlet weak var layerView : UIView!
    
    var pagerController : ViewPagerController?
    
    var mapVC : MapDetailsViewController?
    var detailsVC : TripDetailsViewController?
    var editTripVC : EditTripViewController?
    
    
    var currentTrip : FoodItem = FoodItem()
    var currentLatLongsArr : [LatLongs] = []
    
    var buttonsArr = [RHButtonView]()
    var sideButtonsView : RHSideButtons?
    
    var isMyTrip : Bool = false
    
    var reachability: Reachability?
    
    
    
    fileprivate func setupCommunicationButtons() {
        addSideButtons()
        
        let screenSize  = UIScreen.main.bounds.size
        
         self.sideButtonsView?.setTriggerButtonPosition(CGPoint(x: screenSize.width - 55, y: screenSize.height - 165.0))
    }
    
    fileprivate func addSideButtons() {
        
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
            $0.image = UIImage(named: "user_connect")
            $0.hasShadow = true
            $0.bgColor = UIColor.white
        }
        
        self.sideButtonsView = RHSideButtons(parentView: self.view, triggerButton: triggerButton)
        sideButtonsView!.delegate = self
        sideButtonsView!.dataSource = self
        

        
        let callBtn : RHButtonView = RHButtonView {
            $0.image = UIImage(named: "call_icon")
            $0.hasShadow = true
            $0.bgColor = UIColor.white
        }
        
        let smsBtn : RHButtonView = RHButtonView {
            $0.image = UIImage(named: "chat_icon")
            $0.hasShadow = true
            $0.bgColor = UIColor.white
        }
        
        let emailBtn : RHButtonView = RHButtonView {
            $0.image = UIImage(named: "email_icon")
            $0.hasShadow = true
            $0.bgColor = UIColor.white
        }
        buttonsArr.append(callBtn)
        buttonsArr.append(smsBtn)
        buttonsArr.append(emailBtn)
    }
    

    // MARK: View Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(self.isMyTrip) {
            setupCommunicationButtons()
        }
        
        
        
        
        
        let pagerController = ViewPagerController()
        pagerController.setParentController(self, parentView: self.layerView)
        
        var appearance = ViewPagerControllerAppearance()
        
        appearance.tabMenuHeight = 44.0
        appearance.scrollViewMinPositionY = 44.0
        appearance.scrollViewObservingType = .navigationBar(targetNavigationBar: self.navigationController!.navigationBar)
        

        appearance.tabMenuAppearance.selectedViewBackgroundColor = UIColor.white
        appearance.tabMenuAppearance.backgroundColor =  UIColor.init(patternImage: UIImage.init(named: "navbg")!) //PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.selectedTitleColor =  PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.highlightedTitleColor = PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.defaultTitleColor = UIColor.white
        appearance.tabMenuAppearance.selectedViewInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        pagerController.updateAppearance(appearance)
        
        pagerController.updateSelectedViewHandler = { selectedView in
            selectedView.layer.cornerRadius = selectedView.frame.size.height * 0.5
        }
        
        pagerController.willBeginTabMenuUserScrollingHandler = { selectedView in
            print("call willBeginTabMenuUserScrollingHandler")
            selectedView.alpha = 0.0
        }
        
        pagerController.didEndTabMenuUserScrollingHandler = { selectedView in
            print("call didEndTabMenuUserScrollingHandler")
            selectedView.alpha = 1.0
        }
        
        pagerController.didShowViewControllerHandler = { controller in
            print("call didShowViewControllerHandler")
            print("controller : \(controller.title)")
            let currentController = pagerController.currentContent()
            print("currentContent : \(currentController?.title)")
        }
        

        pagerController.didChangeHeaderViewHeightHandler = { height in
            print("call didChangeHeaderViewHeightHandler : \(height)")
        }
        
        pagerController.didScrollContentHandler = { percentComplete in
            print("call didScrollContentHandler : \(percentComplete)")
        }
        

        //Add two comtrollers
        
        let tripStoryBoard = UIStoryboard.init(name: "MyTripsStoryboard", bundle: Bundle.main)
        self.detailsVC  = tripStoryBoard.instantiateViewController(withIdentifier: "TripDetailsViewController") as? TripDetailsViewController
        self.detailsVC!.view.clipsToBounds = true
//        detailsVC.title = title
        self.detailsVC!.parentController = self
        pagerController.addContent("Details", viewController: self.detailsVC!)
        
        
        self.mapVC = tripStoryBoard.instantiateViewController(withIdentifier: "MapDetailsViewController") as? MapDetailsViewController
        self.mapVC!.view.clipsToBounds = true
        //        detailsVC.title = title
       self.mapVC!.parentController = self
        pagerController.addContent("Map", viewController: self.mapVC!)
        
        
        self.pagerController = pagerController
        
        
        //Call to server to fetch routes
        
        //self.fetchRoutes()
    }
  
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Trip Details"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        //self.title = ""
    }
    
    
//    func fetchRoutes() -> Void {
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            PoolContants.sharedInstance.show()
//        }
//        
//        myTripsNetworkManager.getLatLongs("\(self.currentTrip.uniqueid_val!)"){ (responseArr : AnyObject?, error : NSError?) in
////        myTripsNetworkManager.getLatLongs("pas Id here") { (responseArr : AnyObject?, error : NSError?) in
//            
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                PoolContants.sharedInstance.dismiss()
//            }
//            
//            // set the values for details and map
//            
//            /*
// 
//             latValue : Dou
//             longValue : Do
//             routeIdValue :
//             distanceValue
//             durationValue 
//             htmlImstructio
//             polylineValue
// */
//            
//           
//            
//            let latlongs = responseArr as! [LatLongs]
//            
//            
//            
//            
//            self.currentLatLongsArr = responseArr as! [LatLongs]
//            
//            
//            //self.mapVC?.drawPolylineOnMap([String])
//            
//            var orgLat , orgLng , desLat , desLng : Double
//            
//            var orgLtlng , desLtlng, midLtlng : LatLongs
//            
//            
//            if latlongs.count > 0 {
//                orgLtlng = latlongs[0]
//                desLtlng = latlongs[latlongs.count-1]
//                midLtlng = latlongs[((latlongs.count)/2)]
//                
//                orgLat = orgLtlng.latValue!
//                orgLng = orgLtlng.longValue!
//                
//                desLat = desLtlng.latValue!
//                desLng = desLtlng.longValue!
//                
//                
//                //var stepsArray : [String] = []
//                var stepsHtmlArray : [String] = []
//                let path = GMSMutablePath()
//                
//                for (index, latlongsValue) in latlongs.enumerate() {
//                    
//                    
//                //    var latlongPolyline = latlongsValue.polylineValue
//                    //stepsArray.append(latlongPolyline!)
//                    
//                    let pathInstruction = latlongsValue.htmlImstructionValue
//                    stepsHtmlArray.append(pathInstruction!)
//                    
//                    
//                    path.addCoordinate(CLLocationCoordinate2DMake(latlongsValue.latValue!, latlongsValue.longValue!))
//                    
//                    
//                }
//                
//                
//               dispatch_async(dispatch_get_main_queue(), {
//                 self.detailsVC?.loadUiElements(self.currentTrip.source_name, destination: self.currentTrip.destination_name, distnace: self.currentTrip.total_trip_distance, duration: self.currentTrip.total_trip_time, path: stepsHtmlArray, withTrip: self.currentTrip)
//               });
////
////                var northCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(midLtlng.latValue!,midLtlng.longValue!)
////                
////                var southCoord : CLLocationCoordinate2D = CLLocationCoordinate2DMake(desLtlng.latValue!,desLtlng.longValue!)
////                
////                
////                var gmscoord : GMSCoordinateBounds = GMSCoordinateBounds.init(coordinate: northCoord, coordinate: southCoord)
//                
//                
//                let bounds = GMSCoordinateBounds(path: path)
//                
//                
//                //self.mapVC?.drawPolylineOnMap(stepsArray)
//                
//                self.mapVC?.drawPolylineForPath(path)
//                
//                self.mapVC?.animateWithCameraUpdateForMap(GMSCameraUpdate.fitBounds(bounds, withPadding : 0.01))
//                //self.mapVC?.animateWithCameraUpdateForMap(GMSCameraUpdate.fitBounds(bounds, withPadding : 0.01), lat: midLtlng.latValue!, lng: midLtlng.longValue!)
//                 self.mapVC?.drawOriginMarkerPinOnMap(orgLat, orgLng: orgLng)
//                self.mapVC?.drawDestinationMarkerPinOnMap(desLat, desLng: desLng)
//            }
//            
//            
//           
//            
//           // self.reloadTrips(trips)
//            }
//        
//    }
    
    
    // MARK: Delete Trip Call
    
    func deleteTheTrip() -> Void {
        
        let swiftDict : Dictionary<String,Int> = [kPOSTUniqueID : Int(self.currentTrip.uniqueid!)]
        
        DispatchQueue.main.async {
            PoolContants.sharedInstance.show()
        }
        
        myTripsNetworkManager.deleteTrip(swiftDict as (Dictionary<String, AnyObject>)?) { (responseTrips : AnyObject?, error : NSError?) in
            
            DispatchQueue.main.async {
                PoolContants.sharedInstance.dismiss()
            }
            
            var alertMess  = ""
            var alertTitle  = ""
            
            if (error == nil) && (responseTrips != nil) {
                
                let tripscreted = responseTrips as! String
                //
                //                if trips.count > 0 {
                //                    self.reloadTrips(trips)
                //                }
                //                else {
                alertTitle = ""
                alertMess = tripscreted
                
                self.navigationController?.popViewController(animated: true)
                //                }
            }
            else {
                alertTitle = ""
                alertMess = (error?.localizedDescription)!
            }
            
            let alert = PopupViewController(title: alertTitle, message: alertMess)
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    
    // MARK: Prepare For Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditTrip" {
            
            self.editTripVC = segue.destination as? EditTripViewController
            self.editTripVC?.currentEditingTrip = self.currentTrip
            self.editTripVC?.currentEditingLatLongsArr = self.currentLatLongsArr
           // self.editTripVC?.initialize()
        }
    }
    
    
    
    // MARK: Button Actions
    
    
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

    
    func fetchPhoneNumbrFromServer() -> Void {
        
        if (self.checkNetworkStatus() == true) {
            self.fetchPhonenumber()
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: fetch Trip
    
    func fetchPhonenumber() -> Void {
      
        var nameStr : String? = ""
        let emailStr : String? = (self.currentTrip.email)!
        if ((emailStr != nil) ||  (emailStr != "")) {
            let delimiter = "@"
            let userName = emailStr!.components(separatedBy: delimiter)
            nameStr = userName[0] as String
        }
        
        if ((self.currentTrip.email == nil) || (self.currentTrip.email?.isEmpty == true)) {
            let alert = PopupViewController(title: "Sorry", message: "No Phone Nmber found.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
              PoolContants.sharedInstance.show()
            myTripsNetworkManager.getProfileDetailsForEmail(self.currentTrip.email!){ (responseTrips : AnyObject?, error : NSError?) in
                PoolContants.sharedInstance.dismiss()
                var alertMess  = ""
                var alertTitle  = ""
                
                if (error == nil) && (responseTrips != nil) {
                    
                    let trips = responseTrips as! NSDictionary
                    //  self.reloadTrips(trips)
                    if trips.count > 0 {
                        //self.reloadTrips(trips)
                        let phNumber : String? = trips["phonenumber"] as? String
                        if ((phNumber == nil) || (phNumber!.isEmpty == true)) {
                            let alert = PopupViewController(title: "Sorry", message: "No Phone Number found.")
                            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if let url = URL(string: "tel://\(phNumber!)") {
                            
                            let alert = PopupViewController(title: "", message: "Call \(nameStr!) ?")
                            alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
                            alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
                                
                                // Call
                                UIApplication.shared.openURL(url)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            
                            let alert = PopupViewController(title: "Sorry ...", message: "Phone number is invalid.")
                            alert.addAction(PopupAction(title: "OK", type: .negative, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
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
                
                let alert = PopupViewController(title: alertTitle, message: alertMess)
                alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
                //self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    func callTripOwner() -> Void {
        
        
        //fetch the contact from login tabel to get the upadted one
        
        self.fetchPhoneNumbrFromServer()
        
     /*
        
        var nameStr : String? = ""
        let emailStr : String? = (self.currentTrip.email_val)!
        if ((emailStr != nil) ||  (emailStr != "")) {
            let delimiter = "@"
            let userName = emailStr!.componentsSeparatedByString(delimiter)
            nameStr = userName[0] as String
        }
        
        if ((self.currentTrip.phonenumber_val == nil) || (self.currentTrip.phonenumber_val?.isEmpty == true)) {
            let alert = PopupViewController(title: "Sorry", message: "No Phone number found.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if let url = NSURL(string: "tel://\(self.currentTrip.phonenumber_val!)") {
            
            let alert = PopupViewController(title: "", message: "Call \(nameStr!) ?")
            alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
            alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
                
                // Call
               UIApplication.sharedApplication().openURL(url)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let alert = PopupViewController(title: "Sorry ...", message: "Phone number is invalid.")
            alert.addAction(PopupAction(title: "OK", type: .negative, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
 
 */
    }
    
    func emailTripOwner() -> Void {
        
        
       if ((self.currentTrip.email == nil) || (self.currentTrip.email?.isEmpty == true)) {
            let alert = PopupViewController(title: "Sorry", message: "No Email-Id found.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (MFMailComposeViewController.canSendMail()) {
            let controller = MFMailComposeViewController()
            
        let delimiter = "@"
            
            let emailStr = self.currentTrip.email
            
            if ((emailStr != nil) && (emailStr?.isEmpty == false)) {
                let userName = emailStr!.components(separatedBy: delimiter)
                 controller.setSubject("Lets pool !")
                controller.setMessageBody("Hi \(userName[0])," + "\r\n" + "Can we pool together ?", isHTML: false)
            }
            else {
                controller.setSubject("Lets pool !")
                controller.setMessageBody("Hi," + "\r\n" + "Can we pool together ?", isHTML: false)
            }
            

            controller.setToRecipients([self.currentTrip.email!])
            controller.mailComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let alert = PopupViewController(title: "Sorry", message: "E-mail cannot be sent at this time.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func smsTripOwner() -> Void {
       // print("sms")
        
        if ((self.currentTrip.phonenumber == nil) || (self.currentTrip.phonenumber?.isEmpty == true)) {
            let alert = PopupViewController(title: "Sorry", message: "No Phone number found.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            
            let delimiter = "@"
            
            let emailStr = self.currentTrip.email
            
            if ((emailStr != nil) && (emailStr?.isEmpty == false)) {
                let userName = emailStr!.components(separatedBy: delimiter)
                controller.body = "Hi \(userName[0])," + "\r\n" + "Can we pool together ?"
            }
            else {
                controller.body = "Hi," + "\r\n" + "Can we pool together ?"
            }
            
            
            controller.recipients = [self.currentTrip.phonenumber!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let alert = PopupViewController(title: "Sorry", message: "Message cannot be sent at this time.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func editTrip(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: "showEditTrip", sender: self)
    }
    
    @IBAction func deleteTrip(_ sender: AnyObject) {
        //Do Validation
        // POSt all values
        //self.createPOSTDictionary()
        
        let alert = PopupViewController(title: "", message: "Do you really want to delete this trip ?")
        alert.addAction(PopupAction(title: "No", type: .negative, handler: nil))
        alert.addAction(PopupAction(title: "Yes", type: .positive, handler: {(action : PopupAction) in
            
            // Call deelet trip
            self.deleteTheTrip()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func sendText(_ sender: UIButton) {
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       self.dismiss(animated: true, completion: nil)
    }
}

// Side Menu Buttons

extension TripDetailsBaseViewController: RHSideButtonsDataSource {
    
    func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index]
    }
}

extension TripDetailsBaseViewController: RHSideButtonsDelegate {
    
    func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        
        switch index {
        case 0:
            callTripOwner()
            break
        case 1:
            smsTripOwner()
            break
        case 2:
            emailTripOwner()
            break
        default:
            break
        }
    }
    
    func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
    }
}
