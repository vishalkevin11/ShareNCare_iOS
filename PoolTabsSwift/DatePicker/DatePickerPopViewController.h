//
//  DatePickerPopViewController.h
//  ChaParka
//
//  Created by Kevin Vishal on 10/23/15.
//  Copyright © 2015 TuffyTiffany. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    datePikerType,
    timePikerType,
    dateTimePickerType
} DatePickerType;

@interface DatePickerPopViewController : UIViewController

-(void)showInView:(UIView *)parentView inController:(UIViewController *)parentController withPickerType:(DatePickerType)pickerType withDate:(NSDate *)currentDate;
//- (void)showInView:(UIView *)parentView inController:(UIViewController *)parentController withPickerType:(DatePickerType)pickerType;
@end
