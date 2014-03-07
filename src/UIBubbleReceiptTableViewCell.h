//
//  UIBubbleReceiptTableViewCell.h
//  Pods
//
//  Created by Kirill on 3/7/14.
//
//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

typedef NS_ENUM(NSUInteger, BubbleReceiptType)
{
    BubbleReceiptTypeNone = 0,
    BubbleReceiptTypeSeen,
    BubbleReceiptTypeDelivered
};

@interface UIBubbleReceiptTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *receiptDetails;
@property (nonatomic) BubbleReceiptType type;
@property (nonatomic, getter = isMine) BOOL mine;
@property (nonatomic, strong) NSBubbleData data;

@end
