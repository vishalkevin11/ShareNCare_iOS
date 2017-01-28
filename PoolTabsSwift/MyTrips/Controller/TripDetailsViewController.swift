//
//  TripDetailsViewController.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 8/3/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit

class TripDetailsViewController: UIViewController {
    weak var parentController : UIViewController?
    
    @IBOutlet weak var labelPoolerName: UILabel!
    @IBOutlet weak var labelPoolerEmail: UILabel!
    @IBOutlet weak var labelPoolerPhoneNumber: UILabel!
    @IBOutlet weak var labelSource: UILabel!
    @IBOutlet weak var labelDestination: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelPathDirection: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loadUiElements(_ withSource:String?, destination : String?, distnace:String?, duration : String?, path : [String]?,  withTrip : Trip?) -> Void {
        self.labelSource.text = withSource!
        self.labelDestination.text = destination!
        self.labelDistance.text = distnace!
        self.labelDuration.text =  duration!
        
        let emailStr : String? = (withTrip?.email_val)!
        if ((emailStr != nil) ||  (emailStr != "")) {
            let delimiter = "@"
            let userName = emailStr!.components(separatedBy: delimiter)
            self.labelPoolerName.text = userName[0] as String
            self.labelPoolerEmail.text = emailStr
        }
       
        self.labelPoolerPhoneNumber.text = (withTrip?.phonenumber_val)!
        var pathString : String = ""
        
        for(_,value) in (path?.enumerated())! {
            pathString = pathString + "\r\n- " + value
        }
        
        self.labelPathDirection.text = pathString
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
