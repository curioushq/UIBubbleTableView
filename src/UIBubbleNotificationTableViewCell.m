//
//  UIBubbleNotificationTableViewCell.m
//
//  Created by Shawn Lohstroh on 6/19/13.
//  Copyright (c) 2013 Curious Corp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleNotificationTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleNotificationTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *avatarImage;

- (void) setupInternalData;

@end

@implementation UIBubbleNotificationTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.data = nil;
    self.customView = nil;
    self.avatarImage = nil;
    [super dealloc];
}
#endif

- (void)setDataInternal:(NSBubbleData *)value
{
	self.data = value;
	[self setupInternalData];
}

- (void) setupInternalData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;

    // center it for now. If we have an avatar, we need to figure out how to put that on so it looks good.
    CGFloat x = (self.frame.size.width - width)/2;
    CGFloat y = 0;
    
//    // Adjusting the x coordinate for avatar
//    if (self.showAvatar)
//    {
//        [self.avatarImage removeFromSuperview];
//#if !__has_feature(objc_arc)
//        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
//#else
//        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
//#endif
//        self.avatarImage.layer.cornerRadius = 9.0;
//        self.avatarImage.layer.masksToBounds = YES;
//        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
//        self.avatarImage.layer.borderWidth = 1.0;
//        
//        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 2 : self.frame.size.width - 52;
//        CGFloat avatarY = self.frame.size.height - 50;
//        
//        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
//        [self addSubview:self.avatarImage];
//        
//        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
//        if (delta > 0) y = delta;
//        
//        if (type == BubbleTypeSomeoneElse) x += 54;
//        if (type == BubbleTypeMine) x -= 54;
//    }
    
    CGRect myFrame = self.frame;
    CGRect customFrame = self.customView.frame;
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];    
}

@end
