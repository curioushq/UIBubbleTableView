//
//  UIBubbleReceiptTableViewCell.m
//  Pods
//
//  Created by Kirill on 3/7/14.
//
//

#import "UIBubbleReceiptTableViewCell.h"

@interface UIBubbleReceiptTableViewCell ()

//@property (nonatomic, strong) NSString *typeString;
//@property (nonatomic, strong) NSString *typeRelativeString;
//@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *customView;

- (void)updateData;

@end

@implementation UIBubbleReceiptTableViewCell

//- (void)setType:(BubbleReceiptType)type
//{
//    switch (type) {
//        case BubbleReceiptTypeDelivered:
//            self.typeString = NSLocalizedString(@"Delivered", nil);
//            self.typeRelativeString = NSLocalizedString(@"Delivered to %@", nil);
//            break;
//        case BubbleReceiptTypeSeen:
//            self.typeString = NSLocalizedString(@"/u2713 Seen", nil);
//            self.typeRelativeString = NSLocalizedString(@"/u2713 Seen by %@", nil);
//            break;
//        default:
//            self.typeString = @"";
//            self.typeRelativeString = @"";
//            break;
//    }
//    
//    _type = type;
//    [self updateData];
//}
//
//- (void)setReceiptDetails:(NSString *)receiptDetails
//{
//    if (_receiptDetails != receiptDetails)
//    {
//        _receiptDetails = receiptDetails;
//    }
//    
//    [self updateData];
//}
//
//- (void)setMine:(BOOL)mine
//{
//    _mine = mine;
//    
//    [self updateData];
//}
//
//- (void)updateData
//{
//    if (self.textLabel == nil)
//    {
//        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        self.textLabel.textAlignment = [self isMine] ? NSTextAlignmentLeft : NSTextAlignmentRight;
//        
//        // setup font style...
//    }
//    
//    if (self.receiptDetails != nil && ![self.receiptDetails isEqualToString:@""])
//    {
//        self.textLabel.text = [NSString stringWithFormat:self.typeRelativeString, self.receiptDetails];
//    }
//    else
//    {
//        self.textLabel.text = self.typeString;
//    }
//    
//    [self.textLabel sizeToFit];
//    CGSize labelSize = self.textLabel.frame.size;
//    // or
////    CGSize labelSize = [self.textLabel.attributedText boundingRectWithSize:CGSizeMake(self.textLabel.frame.size.width, CGFLOAT_MAX)
////                                                                   options:NSStringDrawingUsesLineFragmentOrigin
////                                                                   context:nil].size;
//    CGRect initialFrame = self.frame;
//    initialFrame.size.height = labelSize.height;
//    self.frame = initialFrame;
//}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateData];
}

- (void)updateData
{
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    CGFloat x = (self.data.type == BubbleTypeReadReceiptMine) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
}

@end
