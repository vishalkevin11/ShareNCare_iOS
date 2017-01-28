//
//  PoolRoutesViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/21/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//


import GoogleMaps
import UIKit


class PoolRoutesViewController: UIViewController {
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
   // @IBOutlet weak var directions: UITableView!
    @IBOutlet weak var layerView : UIView!
    @IBOutlet weak var mapHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelRouteTitle: UILabel!
    var pagerController : ViewPagerController?
    var currentController : RoutesListViewController?
    
    var request: PXGoogleDirections!
    var results: [PXGoogleDirectionsRoute]!
    var routeIndex: Int = 0
    
    var routesListViewController : RoutesListViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePaging()
        mapView.delegate = self
        //mapView.accessibilityElementsHidden =  false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRoute()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializePaging() -> Void {
        let pagerController = ViewPagerController()
        pagerController.setParentController(self, parentView: self.layerView)
        
        var appearance = ViewPagerControllerAppearance()
        
        appearance.headerHeight = self.mapHeightContraint.constant
        appearance.scrollViewMinPositionY = self.mapHeightContraint.constant
       // appearance.scrollViewObservingType = .NavigationBar(targetNavigationBar: self.navigationController!.navigationBar)
         appearance.scrollViewObservingType = .header
        let imageView = UIImageView(image: UIImage(named: "hous"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        appearance.headerContentsView = imageView
        
     //   appearance.headerContentsView?.alpha=0.0
        
        appearance.tabMenuAppearance.selectedViewBackgroundColor = UIColor.white
        appearance.tabMenuAppearance.backgroundColor =  PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.selectedTitleColor =  PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.highlightedTitleColor = PoolContants.appPaleGreenColor // UIColor(red: 88.0/255.0, green: 229.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        appearance.tabMenuAppearance.defaultTitleColor = UIColor.white
        appearance.tabMenuAppearance.selectedViewInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        
        
        
        
        pagerController.updateAppearance(appearance)
        
        pagerController.updateSelectedViewHandler = { selectedView in
            //UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
            selectedView.layer.cornerRadius = selectedView.frame.size.height * 0.5
            
        }
        
        pagerController.willBeginTabMenuUserScrollingHandler = { selectedView in
           // print("call willBeginTabMenuUserScrollingHandler")
            selectedView.alpha = 0.0
        }
        
        pagerController.didEndTabMenuUserScrollingHandler = { selectedView in
           // print("call didEndTabMenuUserScrollingHandler")
            selectedView.alpha = 1.0
        }
        
        pagerController.didShowViewControllerHandler = { controller in
            print("call didShowViewControllerHandler")
            
            let rt : RoutesListViewController = controller as! RoutesListViewController
            print("controller : \(rt.routeIndex)")
            self.currentController = pagerController.currentContent() as? RoutesListViewController
            self.routeIndex = rt.routeIndex!
            self.updateRoute()
            print("currentContent : \(self.currentController?.title)")
        }
        
        pagerController.changeObserveScrollViewHandler = { controller in
            print("call didShowViewControllerObservingHandler")
            let detailController = controller as! RoutesListViewController
            
            return detailController.tableView
        }
        
        pagerController.didChangeHeaderViewHeightHandler = { height in
            
            self.mapHeightContraint.constant = height
           
            self.view.layoutIfNeeded()
            //print("call didChangeHeaderViewHeightHandler : \(height)")
        }
        
        pagerController.didScrollContentHandler = { percentComplete in
          //  print("call didScrollContentHandler : \(percentComplete)")
        }
        //var  i : Int;
        
        for i in 1...results.count {
//            if i != routeIndex {
//                
//            }
            
            let titleStr  = "Route \(i)"
             self.routesListViewController = UIStoryboard(name: "RoutesStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RoutesListViewController") as? RoutesListViewController
            self.routesListViewController!.results = results
            self.routesListViewController!.title = titleStr
            self.routesListViewController!.routeIndex = i - 1
            self.routesListViewController!.parentController = self
            pagerController.addContent(titleStr, viewController: self.routesListViewController!)
        }
//        for title in ["one","two","threse"] {
//            let controller = UIStoryboard(name: "RoutesStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("RoutesListViewController") as! RoutesListViewController
//            controller.view.clipsToBounds = true
//            controller.results = results
//            controller.parentController = self
//            pagerController.addContent(title, viewController: controller)
//        }
        
        self.pagerController = pagerController
    }
    
    @IBAction func openInGoogleMapsButtonTouched(_ sender: UIButton) {
        if !request.openInGoogleMaps(center: nil, mapMode: .streetView, view: Set(arrayLiteral: PXGoogleMapsView.satellite, PXGoogleMapsView.traffic, PXGoogleMapsView.transit), zoom: 15, callbackURL: URL(string: "pxsample://"), callbackName: "PXSample") {
            let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Could not launch the Google Maps app. Maybe this app is not installed on this device?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateRoute() {
        
        //        prevButton.enabled = (routeIndex > 0)
        //        nextButton.enabled = (routeIndex < (results).count - 1)
        //        routesLabel.text = "\(routeIndex + 1) of \((results).count)"
        mapView.clear()
        
        let selectedRouteObj  =   results[routeIndex]
        var summaryStr : String? = ""
        
        
        if selectedRouteObj.legs.count > 0 {
            let leg = selectedRouteObj.legs[0]
//            if let dist = leg.distance?.description, dur = leg.duration?.description {
             if let dist = leg.distance?.description {
                summaryStr =  "via .\(selectedRouteObj.summary!)"
            }
            
            
            self.labelRouteTitle.text = summaryStr!
        }
        
        
        for i in 0 ..< results.count {
            if i != routeIndex {
                
                results[i].drawOnMap(mapView, withIndex:i, approximate: false, strokeColor: UIColor.lightGray, strokeWidth: 3.0)
            }
        }
        
        
        
        
        mapView.animate(with: GMSCameraUpdate.fit(results[routeIndex].bounds!, withPadding: 40.0))
        
        results[routeIndex].drawOnMap(mapView, withIndex:routeIndex, approximate: false, strokeColor: UIColor.purple, strokeWidth: 8.0)
        results[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.green, opacity: 1.0, flat: true)
        results[routeIndex].drawDestinationMarkerOnMap(mapView, title: "Destination", color: UIColor.red, opacity: 1.0, flat: true)
        //directions.reloadData()
        
        // Reload Table
       //  pagerController!.updateAppearance( ViewPagerControllerAppearance())
        
        self.currentController?.reloadTableData(routeIndex)
    }
}


extension PoolRoutesViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
        let titleString  : String = overlay.title!
        let titleStringRemaining : String = titleString.replacingOccurrences(of: "polyline", with: "")
        let index :Int? = Int(titleStringRemaining)
        routeIndex = index!
        
        updateRoute()
        NSLog("TAPPPPPPPPPP\(index)")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        NSLog("hhhhhhhhhhh")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        NSLog("PPPPPPP")
        return true
    }
   
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        NSLog("Location Tapped")
        return true
    }
    
    // MARK: Button Actions
    
    @IBAction func closeRoutesView(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
        let userInfo : PXGoogleDirectionsRoute = results[routeIndex]
        NotificationCenter.default.post(name: Notification.Name(rawValue: kRouteSelected), object: nil, userInfo: [kRouteSelectedDict:userInfo])
    }
}

//extension PoolRoutesViewController: UITableViewDataSource {
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return (results[routeIndex].legs).count
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (results[routeIndex].legs[section].steps).count
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let leg = results[routeIndex].legs[section]
//        if let dist = leg.distance?.description, dur = leg.duration?.description {
//            return "Step \(section + 1) (\(dist), \(dur))"
//        } else {
//            return "Step \(section + 1)"
//        }
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("RouteStep")
//        if (cell == nil) {
//            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "RouteStep")
//        }
//        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
//        if let instr = step.rawInstructions {
//            cell!.textLabel!.text = instr
//        }
//        if let dist = step.distance?.description, dur = step.duration?.description {
//            cell!.detailTextLabel?.text = "\(dist), \(dur)"
//        }
//        return cell!
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
//        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(step.bounds!, withPadding: 40.0))
//    }
//    
//    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
//        var msg: String
//        if let m = step.maneuver {
//            msg = "\(step.rawInstructions!)\nGPS instruction: \(m)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
//        } else {
//            msg = "\(step.rawInstructions!)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
//        }
//        let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//extension PoolRoutesViewController: UITableViewDelegate {
//}
//
