//
//  NSBubbleData.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <Foundation/Foundation.h>

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeMinePrivate = 1,
    BubbleTypeSomeoneElse = 2,
    BubbleTypeSomeoneElsePrivate = 3,
    BubbleTypeNotification = 4,
    BubbleTypeReceiptMine = 5,
    BubbleTypeReceiptSomeone = 6
} NSBubbleType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSString *avatarLabelStr;

- (id)initWithAttributedText:(NSAttributedString *)text date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithAttributedText:(NSAttributedString *)text date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets;

- (bool)isChat;
- (bool)isChatMine;
- (bool)isChatSomeoneElse;
- (bool)isPrivate;

@end
