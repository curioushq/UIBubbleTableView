//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"

@interface UIBubbleHeaderTableViewCell ()
{
    CGRect _leftLine;
    CGRect _rightLine;
}

@property (nonatomic, retain) UILabel *label;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize date = _date;

+ (CGFloat)height
{
    return 28.0;
}

- (void)setDate:(NSDate *)value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *text = [dateFormatter stringFromDate:value];
#if !__has_feature(objc_arc)
    [dateFormatter release];
#endif
    
    if (self.label)
    {
        self.label.text = text;
        return;
    }
    
    UIFont *font = self.font;
    if (font == nil)
    {
        font = [UIFont systemFontOfSize:11.f];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
    self.label.text = text;
    self.label.font = font;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    
    CGFloat dateWidth = ceilf(self.label.attributedText.size.width / 2 + 10.0);
    CGFloat originY = ceilf(self.label.bounds.size.height / 2) + 2;
    _leftLine = CGRectMake(0, originY, CGRectGetMidX(self.bounds) - dateWidth, 1);
    _rightLine =  CGRectMake(CGRectGetMidX(self.bounds) + dateWidth, originY,
                             CGRectGetMidX(self.bounds) - dateWidth, 1);
}

- (void)drawRect:(CGRect)rect
{
    if (self.drawLines)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);

        CGContextSetRGBFillColor(ctx, 175.0 / 255.0, 175.0 / 255.0, 175.0 / 255.0, 1.0);
        UIRectFill(_leftLine);
        UIRectFill(_rightLine);
        
        CGContextRestoreGState(ctx);
    }
}

@end
