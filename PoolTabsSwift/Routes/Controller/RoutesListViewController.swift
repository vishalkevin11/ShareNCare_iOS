//
//  RoutesListViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/22/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class RoutesListViewController: UIViewController {

    weak var parentController : UIViewController?
    var results: [PXGoogleDirectionsRoute]!
    var routeIndex: Int?
    
    @IBOutlet weak var tableView : UITableView!
    
    
    
    func reloadTableData(_ withIndex : Int?) -> Void {
        self.routeIndex = withIndex
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  print("DetailViewController viewWillAppear - " + self.title!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  print("DetailViewController viewWillDisappear - " + self.title!)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return (results[routeIndex!].legs).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results[routeIndex!].legs[section].steps).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let leg = results[routeIndex!].legs[section]
        if let dist = leg.distance?.description, let dur = leg.duration?.description {
            return "Step \(section + 1) (\(dist), \(dur))"
        } else {
            return "Step \(section + 1)"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RouteStep")
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "RouteStep")
        }
        let step = results[routeIndex!].legs[indexPath.section].steps[indexPath.row]
        if let instr = step.rawInstructions {
            cell!.textLabel!.text = instr
        }
        if let dist = step.distance?.description, let dur = step.duration?.description {
            cell!.detailTextLabel?.text = "\(dist), \(dur)"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let step = results[routeIndex!].legs[indexPath.section].steps[indexPath.row]
      //  mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(step.bounds!, withPadding: 40.0))
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: IndexPath) {
        let step = results[routeIndex!].legs[indexPath.section].steps[indexPath.row]
        var msg: String
        if let m = step.maneuver {
            msg = "\(step.rawInstructions!)\nGPS instruction: \(m)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
        } else {
            msg = "\(step.rawInstructions!)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
        }
        let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}
