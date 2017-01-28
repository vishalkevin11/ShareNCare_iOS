//
//  DatePickerPopViewController.m
//  ChaParka
//
//  Created by Kevin Vishal on 10/23/15.
//  Copyright © 2015 TuffyTiffany. All rights reserved.
//

#import "DatePickerPopViewController.h"


@interface DatePickerPopViewController () {
    NSString *selectedValue;
    NSString *selectedDisplayValue;
    DatePickerType datepickerSentType;
    NSDate *selectedDate;
}
@property (weak, nonatomic) IBOutlet UIView *pickerBaseView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation DatePickerPopViewController
@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickerBaseView.layer.cornerRadius = 7.0;
    if (datepickerSentType == datePikerType) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.date = selectedDate;
    }
//    else  if (datepickerSentType == timePikerType) {
//                self.datePicker.datePickerMode = UIDatePickerModeTime;
//       // NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
//       // [self.datePicker setLocale:locale];
//    }
//    
    else {
//        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
//        [self.datePicker setLocale:locale];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.date = selectedDate;
    }
    
    
    
    [self setTheDateValuesFromPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Add/Remove View

//-(void)showInView:(UIView *)parentView inController:(UIViewController *)parentController withPickerType:(DatePickerType)pickerType {

-(void)showInView:(UIView *)parentView inController:(UIViewController *)parentController withPickerType:(DatePickerType)pickerType withDate:(NSDate *)currentDate{
    
    datepickerSentType = pickerType;
    
   // if (pickerType == dateTimePickerType) {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate =  currentDate;
        NSDate *dateForPic = (currentDate)? currentDate : [NSDate date];
        [self.datePicker setDate: dateForPic];
        selectedDate  = dateForPic;
//    }
//    else {
//        self.datePicker.datePickerMode = UIDatePickerModeTime;
//    }
    
    //parentController.navigationController.navigationBarHidden = YES;
//    self.view.alpha = 0.0;
//    
//    [parentView addSubview:self.view];
//    [parentController.navigationController addChildViewController:self];
//    
//    
//    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.view.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//    }];
    [parentController presentViewController:self animated:NO completion:nil];
}


#pragma mark - Set Date Values

-(void)setTheDateValuesFromPicker {
    
    NSDate *pickerDate = [self getdateValueForPicker:datePicker];
    selectedDate = pickerDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    
    if (datepickerSentType == datePikerType) {
        
        
        [formatter setDateFormat:@"MMM dd yyyy"];
        [formatter2 setDateFormat:@"yyyy-MMM-dd"];
        
        
        //[formatter2 setDateFormat:@"yyyyMMdd"];
    }
    else if (datepickerSentType == timePikerType) {
        
        //[formatter setDateFormat:@"hh:mm:ss a"];
        [formatter setDateFormat:@"HH:mm"];
        [formatter2 setDateFormat:@"HH:mm"];
    }
    else if (datepickerSentType == dateTimePickerType) {
        
        [formatter setDateFormat:@"MMM dd yyyy HH:mm"];
        [formatter2 setDateFormat:@"yyyy-MMM-dd HH:mm"];
        
        
        //[formatter2 setDateFormat:@"yyyyMMdd"];
    }
    
    selectedDisplayValue = [formatter stringFromDate:pickerDate];
    selectedValue = [formatter2 stringFromDate:pickerDate];
}

#pragma mark -  Button Actions

- (IBAction)selectOptionAndDismiss:(id)sender {
    
    [self setTheDateValuesFromPicker];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FilerSelecetedDateValue" object:@{@"selectedValue":selectedValue,@"selectedDisplayValue":selectedDisplayValue,@"selectedDate":selectedDate} userInfo:nil];
    [self dismissView];
}

- (IBAction)removeFromParent:(id)sender {
    [self dismissView];
}

- (void)dismissView {
//    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        //self.parentViewController.navigationController.navigationBarHidden = NO;
//        self.view.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [self removeFromParentViewController];
//        [self.view removeFromSuperview];
//    }];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark-
#pragma mark Date Picker Methods

- (IBAction)dateChanged:(id)sender {
    
  //  UIDatePicker *datePicker = (UIDatePicker *)sender;
    //selectedValue = [self getdateValueForPicker:datePicker];
}

-(NSDate *)getdateValueForPicker:(UIDatePicker *)picker {
    NSLog(@"%@",picker.date);
    return picker.date;
}

@end

