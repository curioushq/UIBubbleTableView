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

#if !__has_feature(objc_arc)
- (void) dealloc
{
    self.label = nil;
    self.date = nil;
    self.textAttributes = nil;
    self.linesColor = nil;
    [super dealloc];
}
#endif

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
    
    if (self.label && self.textAttributes)
    {
        self.label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributes];
        return;
    }
    
    NSMutableDictionary *textAttributes = [self.textAttributes mutableCopy];
    if (textAttributes == nil)
    {
        textAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          [UIFont systemFontOfSize:11.f], NSFontAttributeName,
                          [UIColor blackColor], NSForegroundColorAttributeName,
                          nil];
    }
    
    if (![textAttributes objectForKey:NSParagraphStyleAttributeName])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
#if !__has_feature(objc_arc)
        [paragraphStyle release];
#endif
    }
    
    self.textAttributes = textAttributes;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
    self.label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:textAttributes];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    
#if !__has_feature(objc_arc)
    [textAttributes release];
#endif
    
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

        CGFloat red = 0.5, green = 0.5, blue = 0.5;
        CGFloat alpha = 1.0;
        if (self.linesColor != nil)
        {
            [self.linesColor getRed:&red green:&green blue:&blue alpha:&alpha];
        }
        CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
        UIRectFill(_leftLine);
        UIRectFill(_rightLine);
        
        CGContextRestoreGState(ctx);
    }
}

@end
