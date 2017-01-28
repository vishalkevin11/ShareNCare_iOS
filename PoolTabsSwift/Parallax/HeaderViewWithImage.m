//
//  HeaderViewWithImage.m
//  Example
//
//  Created by Marek Serafin on 13/10/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import "HeaderViewWithImage.h"
#import "ShareNCare-Swift.h"


@implementation HeaderViewWithImage

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    
    return [views firstObject];
    
}


//-(void)awakeFromNib {
//    self.imageViewProfileIcon.na
//}
////didSet {
//    imageViewthumb.configuration = TableAvatarImageConfig()
//}

//struct TableAvatarImageConfig: AvatarImageViewConfiguration {
//    let shape: Shape = .Circle
//}

//-(void)setImageViewProfileIcon:(AvatarImageView *)imageViewProfileIcon {
//    imageViewProfileIcon.configuration = AvatarImageViewConfiguration()
//}

@end
