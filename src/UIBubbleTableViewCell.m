//
//  UIBubbleTableViewCell.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <QuartzCore/QuartzCore.h>
#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell ()

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) UIImageView *avatarImage;
@property (nonatomic, retain) UILabel *avatarLabel;
@property (nonatomic, retain) NSTimer *longPressTimer;

- (void) setupInternalData;

@end

@implementation UIBubbleTableViewCell

@synthesize data = _data;
@synthesize customView = _customView;
@synthesize bubbleImage = _bubbleImage;
@synthesize showAvatar = _showAvatar;
@synthesize avatarImage = _avatarImage;
@synthesize avatarLabel = _avatarLabel;
@synthesize longPressTimer = _longPressTimer;

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
    self.bubbleImage = nil;
    self.avatarImage = nil;
    self.avatarLabel = nil;
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
    
    if (!self.bubbleImage)
    {
#if !__has_feature(objc_arc)
        self.bubbleImage = [[[UIImageView alloc] init] autorelease];
#else
        self.bubbleImage = [[UIImageView alloc] init];
#endif
        [self addSubview:self.bubbleImage];
    }
    
    NSBubbleType type = self.data.type;
    
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    
    CGFloat x = (type == BubbleTypeSomeoneElse) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.avatarImage.layer.cornerRadius = 9.0;
        self.avatarImage.layer.masksToBounds = YES;
        self.avatarImage.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.avatarImage.layer.borderWidth = 1.0;
        
        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? 2 : self.frame.size.width - 52;
        CGFloat avatarY = self.frame.size.height - 50;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, 50, 50);
        [self addSubview:self.avatarImage];
        
        CGFloat delta = self.frame.size.height - (self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height);
        if (delta > 0) y = delta;
        
        if (type == BubbleTypeSomeoneElse) x += 54;
        if (type == BubbleTypeMine) x -= 54;
    }
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
    
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    }
    
    self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
    
    
    if (self.data.avatarLabelStr != nil && type == BubbleTypeSomeoneElse)
    {
        [self.avatarLabel removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarLabel = [[[UILabel alloc] init] autorelease];
#else
        self.avatarLabel = [[UILabel alloc] init];
#endif
        
        self.avatarLabel.text = self.data.avatarLabelStr;
        self.avatarLabel.backgroundColor = [UIColor clearColor];
        self.avatarLabel.font = [UIFont systemFontOfSize:12];
        self.avatarLabel.textColor = [UIColor grayColor];
        
        CGFloat avatarLabelX = self.bubbleImage.frame.origin.x + 10;
        CGFloat avatarLabelY = self.bubbleImage.frame.origin.y - 24;
        
        self.avatarLabel.frame = CGRectMake(avatarLabelX, avatarLabelY, 200, 30);
        [self.contentView addSubview:self.avatarLabel];
    }
    
}

#pragma mark - UIResponder subclassing

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"Touches began!!!");
    
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.bubbleImage.frame, point))
    {
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                                             selector:@selector(longPressTimerDidFire:)
                                                             userInfo:nil repeats:NO];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    NSLog(@"Touches cancelled!!!");
    
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    NSLog(@"Touches ended!!!");
    
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL retVal = NO;
    BOOL isTextContainer = ([self.customView isKindOfClass:[UILabel class]]
                            || [self.customView isKindOfClass:[UITextView class]]
                            || [self.customView isKindOfClass:[UITextField class]]);
    
    if (action == @selector(copy:) && isTextContainer)
    {
        retVal = YES;
    }
    else
    {
        retVal = [super canPerformAction:action withSender:sender];
    }
    
    return retVal;
}

- (void)copy:(id)sender
{
    if ([self.customView respondsToSelector:@selector(attributedText)]
        && [self.customView valueForKey:@"attributedText"] != nil)
    {
        [[UIPasteboard generalPasteboard] setString:[[self.customView valueForKey:@"attributedText"] string]];
    }
    else if ([self.customView respondsToSelector:@selector(text)]
             && [self.customView valueForKey:@"text"] != nil)
    {
        [[UIPasteboard generalPasteboard] setString:[self.customView valueForKey:@"text"]];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
    
    return [super resignFirstResponder];
}

- (void)longPressTimerDidFire:(NSTimer *)timer
{
    self.longPressTimer = nil;
    
    if ([self becomeFirstResponder])
    {
        NSLog(@"Became First Responder!!!");
        
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        CGRect selectionRect = self.customView.frame;
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

@end
