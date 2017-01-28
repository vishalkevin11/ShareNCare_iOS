//
//  HeaderViewWithImage.h
//  Example
//
//  Created by Marek Serafin on 13/10/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AvatarImageView;
@interface HeaderViewWithImage : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserRpleType;
@property (weak, nonatomic) IBOutlet AvatarImageView *imageViewProfileIcon;
+ (instancetype)instantiateFromNib;

@end
