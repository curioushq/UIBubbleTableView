//
//  UIBubbleReceiptTableViewCell.m
//  UIBubbleTableView
//
//  Created by Kirill Kormiltsev on 3/7/14.
//
//

#import "UIBubbleReceiptTableViewCell.h"

@interface UIBubbleReceiptTableViewCell ()

@property (nonatomic, strong) UIView *customView;

- (void)updateData;

@end

@implementation UIBubbleReceiptTableViewCell

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateData];
}

- (void)updateData
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    CGFloat x = (self.data.type == BubbleTypeReceiptMine) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
}

@end
