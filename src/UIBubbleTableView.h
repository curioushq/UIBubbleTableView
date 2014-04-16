//
//  UIBubbleTableView.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>

#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"

typedef enum _NSBubbleTypingType
{
    NSBubbleTypingTypeNobody = 0,
    NSBubbleTypingTypeMe = 1,
    NSBubbleTypingTypeSomebody = 2,
    NSBubbleTypingLoading = 3
} NSBubbleTypingType;

@interface UIBubbleTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) IBOutlet id<UIBubbleTableViewDataSource> bubbleDataSource;
@property (nonatomic, assign) IBOutlet id<UIBubbleTableViewDelegate> bubbleDelegate;
@property (nonatomic) NSTimeInterval snapInterval;
@property (nonatomic) NSBubbleTypingType typingBubble;
@property (nonatomic) BOOL showAvatars;
@property (nonatomic) BOOL hideMyAvatar;
@property NSInteger blankFooterSpace;

@property (nonatomic) BOOL divideWithLines;
@property (nonatomic, copy) UIColor *headerLinesColor;

@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIFont *avatarFont;
@property (nonatomic, strong) NSString *imageBubbleMine;
@property (nonatomic, strong) NSString *imageBubbleMineSelected;
@property (nonatomic, strong) NSString *imageBubbleOther;
@property (nonatomic, strong) NSString *imageBubbleOtherSelected;
@property (nonatomic) UIEdgeInsets edgeInsetsMine;
@property (nonatomic) UIEdgeInsets edgeInsetsOther;
@property (nonatomic, retain) NSDictionary *headerTextAttributes;
@property (nonatomic, retain) NSDictionary *avatarTextAttributes;

@property (nonatomic, retain) NSString *receiptDescription;

@end
