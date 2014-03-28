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

static CGFloat const kBubbleAvatarLabelHeight = 15.f;
static CGFloat const kBubbleAvatarImageSize = 50.f;
static CGFloat const kBubbleBorderPadding = 10.f;
static CGFloat const kBubbleElementPadding = 5.f;

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.avatarFont = [UIFont systemFontOfSize:11.f];
    }
    
    return self;
}

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
    self.longPressTimer = nil;
    [super dealloc];
}
#endif

+ (CGFloat)heightForData:(NSBubbleData *)data showAvatar:(BOOL)showAvatar
{
    float avatarLabel = 0;
    if (data.avatarLabelStr != nil && data.type == BubbleTypeSomeoneElse)
    {
        avatarLabel = kBubbleAvatarLabelHeight;
    }
    
    float numberA = data.insets.top + data.view.frame.size.height + data.insets.bottom;
    float numberB = showAvatar ? kBubbleAvatarImageSize : 0;

    return ( MAX (numberA, numberB) + avatarLabel + kBubbleElementPadding);
}

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

    CGFloat left = (type == BubbleTypeSomeoneElse) ? kBubbleBorderPadding : self.frame.size.width - width - self.data.insets.left - self.data.insets.right - kBubbleBorderPadding;
    CGFloat bottom = [[self class] heightForData:self.data showAvatar:self.showAvatar] - kBubbleElementPadding;
    
    if (self.data.avatarLabelStr != nil && type == BubbleTypeSomeoneElse)
    {
        [self.avatarLabel removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarLabel = [[[UILabel alloc] init] autorelease];
#else
        self.avatarLabel = [[UILabel alloc] init];
#endif
        UIFont *font = self.avatarFont;
        if (font == nil)
        {
            font = [UIFont systemFontOfSize:11.f];
        }
        
        self.avatarLabel.text = self.data.avatarLabelStr;
        self.avatarLabel.backgroundColor = [UIColor clearColor];
        self.avatarLabel.font = font;
        self.avatarLabel.textColor = [UIColor darkTextColor];

        bottom -= kBubbleAvatarLabelHeight;
        self.avatarLabel.frame = CGRectMake(left, bottom, 200, kBubbleAvatarLabelHeight);
        [self.contentView addSubview:self.avatarLabel];
    }
    
    // Adjusting the x coordinate for avatar
    if (self.showAvatar)
    {
        [self.avatarImage removeFromSuperview];
#if !__has_feature(objc_arc)
        self.avatarImage = [[[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])] autorelease];
#else
        self.avatarImage = [[UIImageView alloc] initWithImage:(self.data.avatar ? self.data.avatar : [UIImage imageNamed:@"missingAvatar.png"])];
#endif
        self.avatarImage.layer.cornerRadius = 4.0;
        self.avatarImage.layer.masksToBounds = YES;

        CGFloat avatarX = (type == BubbleTypeSomeoneElse) ? left : self.frame.size.width - 50 - kBubbleBorderPadding;
        CGFloat avatarY = bottom - kBubbleAvatarImageSize;
        
        self.avatarImage.frame = CGRectMake(avatarX, avatarY, kBubbleAvatarImageSize, 50);
        [self addSubview:self.avatarImage];
        
        if (type == BubbleTypeSomeoneElse) left += 50 + kBubbleElementPadding;
        if (type == BubbleTypeMine) left -= 50 - kBubbleElementPadding;
    }
    
    CGFloat delta = self.data.insets.top + self.data.insets.bottom + self.data.view.frame.size.height;
    if (delta > 0) bottom -= delta;
    
    [self.customView removeFromSuperview];
    self.customView = self.data.view;
    self.customView.frame = CGRectMake(left + self.data.insets.left, bottom + self.data.insets.top, width, height);
    [self.contentView addSubview:self.customView];
    
    if (type == BubbleTypeSomeoneElse)
    {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 24, 18, 18)];
        self.bubbleImage.highlightedImage = [[UIImage imageNamed:@"bubbleSomeoneSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 24, 18, 18)];
        
    }
    else {
        self.bubbleImage.image = [[UIImage imageNamed:@"bubbleMine"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 24)];
        self.bubbleImage.highlightedImage = [[UIImage imageNamed:@"bubbleMineSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 24)];
    }
    
    self.bubbleImage.frame = CGRectMake(left, bottom, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
}

#pragma mark - UIResponder subclassing

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

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

    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

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

- (void)willHideEditMenu:(NSNotification *)note
{
    self.bubbleImage.highlighted = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)longPressTimerDidFire:(NSTimer *)timer
{
    self.longPressTimer = nil;
    
    if ([self becomeFirstResponder])
    {
        self.bubbleImage.highlighted = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        CGRect selectionRect = self.customView.frame;
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

@end
