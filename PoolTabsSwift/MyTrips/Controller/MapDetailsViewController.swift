//
//  MapDetailsViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/3/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//


import GoogleMaps
import UIKit

class MapDetailsViewController: UIViewController {
    weak var parentController : UIViewController?
    
    
    @IBOutlet weak var mapView1: GMSMapView!
    // @IBOutlet weak var directions: UITableView!
//    @IBOutlet weak var layerView : UIView!
//    @IBOutlet weak var mapHeightContraint: NSLayoutConstraint!
    
 //   @IBOutlet weak var labelRouteTitle: UILabel!
//    var pagerController : ViewPagerController?
//    var currentController : RoutesListViewController?
    
    var request: PXGoogleDirections!
    var results: [PXGoogleDirectionsRoute]!
    var routeIndex: Int = 0
    
  //  var routesListViewController : RoutesListViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView1.clear()
        mapView1.delegate = self
    }
    
    func loadMapWith(_ steps:[String],orgLatitude : CLLocationDegrees, orgLongitude : CLLocationDegrees,desLatitude : CLLocationDegrees, desLongitude : CLLocationDegrees)->Void {
        
        self.drawPolylineOnMap(steps)
        self.drawOriginMarkerPinOnMap(orgLatitude, orgLng: orgLongitude)
        self.drawDestinationMarkerPinOnMap(desLatitude, desLng: desLongitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    @IBAction func openInGoogleMapsButtonTouched(sender: UIButton) {
//        if !request.openInGoogleMaps(center: nil, mapMode: .StreetView, view: Set(arrayLiteral: PXGoogleMapsView.Satellite, PXGoogleMapsView.Traffic, PXGoogleMapsView.Transit), zoom: 15, callbackURL: NSURL(string: "pxsample://"), callbackName: "PXSample") {
//            let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Could not launch the Google Maps app. Maybe this app is not installed on this device?", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
    
    func drawPolylineOnMap(_ steps:[String]) -> [GMSPolyline] {
        
         var polylines = [GMSPolyline]()
        for singleStep in steps {
            
            
            let polyPath : GMSPath = GMSPath.init(fromEncodedPath: singleStep)!
            let polyline = GMSPolyline(path: polyPath)
           // polyline.title = "polyline\(withIndex)"
            polyline.strokeColor =  UIColor.orange
            polyline.strokeWidth = 5.0
            polyline.map = self.mapView1
            // polyline.spans = [GMSStyleSpan(style: redYellow)]
            polyline.isTappable = true
            polylines.append(polyline)
        }
        
        return polylines
    }

    
    func drawPolylineForPath(_ gmPath:GMSPath) -> [GMSPolyline] {
//        
        var polylines = [GMSPolyline]()
//        for singleStep in steps {
        
            
           // let polyPath : GMSPath = GMSPath.init(fromEncodedPath: singleStep)!
            let polyline = GMSPolyline(path: gmPath)
            // polyline.title = "polyline\(withIndex)"
            polyline.strokeColor =  UIColor.orange
            polyline.strokeWidth = 5.0
            polyline.map = self.mapView1
            // polyline.spans = [GMSStyleSpan(style: redYellow)]
            polyline.isTappable = true
            polylines.append(polyline)
        //}
        
        return polylines
    }

    
    func drawOriginMarkerPinOnMap(_ orgLat : CLLocationDegrees, orgLng : CLLocationDegrees) -> GMSMarker? {
        
        
        let originCooordinates : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: orgLat, longitude: orgLng)
        let marker = GMSMarker(position: originCooordinates)
        marker.title = title
        marker.icon = GMSMarker.markerImage(with: UIColor.red)
        marker.opacity = 1.0
        marker.isFlat = false
        marker.map = self.mapView1
        return marker
    }
    
    func drawDestinationMarkerPinOnMap(_ desLat : CLLocationDegrees, desLng : CLLocationDegrees) -> GMSMarker? {
        
        
        let destinationCooordinates : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: desLat, longitude: desLng)
        let marker = GMSMarker(position: destinationCooordinates)
        marker.title = title
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        marker.opacity = 1.0
        marker.isFlat = false
        marker.map = self.mapView1
        return marker
    }
    /*
     func animateWithCameraUpdateForMap(cameraUpdate: GMSCameraUpdate,lat : CLLocationDegrees, lng : CLLocationDegrees) {
     
     
     let fancy = GMSCameraPosition.cameraWithLatitude(lat,
     longitude: lng, zoom: 6, bearing: 30, viewingAngle: 45)
     self.mapView1.camera = fancy
     
     self.mapView1.animateWithCameraUpdate(cameraUpdate)
     //self.mapView1.animateToZoom(0.5)
     }
 */
    func animateWithCameraUpdateForMap(_ cameraUpdate: GMSCameraUpdate) {
        
        
        DispatchQueue.main.async { 
            self.mapView1.animate(with: cameraUpdate)
            self.mapView1.animate(toViewingAngle: 3)
            
            self.mapView1.animate(toZoom: 4)
        }
    }
}


extension MapDetailsViewController: GMSMapViewDelegate {
    

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
    
}
