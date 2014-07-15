//
//  UIBubbleTableViewCell.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell : UITableViewCell

@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;
@property (nonatomic, strong) UIFont *avatarFont;
@property (nonatomic, strong) NSString *imageBubbleMine;
@property (nonatomic, strong) NSString *imageBubbleMineSelected;
@property (nonatomic, strong) NSString *imageBubbleOther;
@property (nonatomic, strong) NSString *imageBubbleOtherSelected;
@property (nonatomic) UIEdgeInsets edgeInsetsMine;
@property (nonatomic) UIEdgeInsets edgeInsetsOther;
@property (nonatomic, strong) NSDictionary *avatarTextAttributes;

+ (CGFloat)heightForData:(NSBubbleData *)data showAvatar:(BOOL)showAvatar;

@end
