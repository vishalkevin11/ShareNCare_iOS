//
//  MyTripTableViewCell.swift
//  PoolTabsSwift
//
//  Created by Kevin Vishal on 7/27/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit



class MyTripTableViewCell: UITableViewCell {

  //  @IBOutlet weak var imageViewthumb: UIImageView!
    @IBOutlet weak var labelTimeStamp: UILabel!
    @IBOutlet weak var labelFromLocation: UILabel!
    @IBOutlet weak var labelTolocation: UILabel!
    @IBOutlet weak var labelDistanceDuration: UILabel!
    @IBOutlet weak var labelVia: UILabel!
    @IBOutlet weak var imageViewGreen: UIImageView!
    
    @IBOutlet weak var weekDayPicker: WeekDaysSegmentedControl!
    @IBOutlet weak var deleteOverayView: UIView!
    
    @IBOutlet weak var baleFoodType: UILabel!
    @IBOutlet var imageViewthumb: UIImageView!     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   imageViewthumb.layer.cornerRadius  =  25.0
        self.weekDayPicker.allowSmallText = true
        self.weekDayPicker.borderColor = PoolContants.appPaleGreenColor
        self.weekDayPicker.font = UIFont.systemFont(ofSize: 11)
        
//        self.imageViewthumb.layer.cornerRadius = 55.0/2.0
        self.imageViewthumb.clipsToBounds  = true
    
        //imageViewthumb.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillPicker(_ currentEditingTrip : Trip) -> Void {
        
        let day1Value = String(currentEditingTrip.day1_str!)
        let day2Value = String(currentEditingTrip.day2_str!)
        let day3Value = String(currentEditingTrip.day3_str!)
        let day4Value = String(currentEditingTrip.day4_str!)
        let day5Value = String(currentEditingTrip.day5_str!)
        let day6Value = String(currentEditingTrip.day6_str!)
        let day7Value = String(currentEditingTrip.day7_str!)
        
        //   print("\(day1Value)\(day2Value)\(day3Value)\(day4Value)\(day5Value)\(day6Value)\(day7Value)");
        let str : String = "\((day1Value))\(day2Value)\(day3Value)\(day4Value)\(day5Value)\(day6Value)\(day7Value)"
     //   dispatch_async(dispatch_get_main_queue()) {
            self.weekDayPicker.daysString = str
        self.weekDayPicker.reloadTheView()
         // self.weekDayPicker.layoutSubviews()
        //    self.weekDayPicker.borderColor = UIColor.blueColor()
        
     //   }
        
    }
    


}
