//
//  UIBubbleNotificationTableViewCell.m
//
//  Created by Shawn Lohstroh on 6/19/13.
//  Copyright (c) 2013 Curious Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

@interface UIBubbleNotificationTableViewCell : UITableViewCell


- (void)setDataInternal:(NSBubbleData *)value;


@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;

@end
