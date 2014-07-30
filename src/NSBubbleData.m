//
//  NSBubbleData.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>
#import "NIAttributedLabel.h"
#import <CoreText/CoreText.h>

@interface NSBubbleData() <NIAttributedLabelDelegate>
@end

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize avatarLabelStr = _avatarLabelStr;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;
    self.avatarLabelStr = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {4, 12, 8, 20};
const UIEdgeInsets textInsetsSomeone = {4, 18, 8, 12};
const UIEdgeInsets textInsetsNotification = {5, 0, 5, 0};
const UIEdgeInsets textInsetsReadReceipt = {0, 10, 5, 10};

+ (id)dataWithAttributedText:(NSAttributedString *)text date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithAttributedText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithAttributedText:text date:date type:type];
#endif    
}

- (id)initWithAttributedText:(NSAttributedString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    if (text == nil)
    {
        text = [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *attrString = [text mutableCopy];
    NIAttributedLabel *label = nil;
    
    if (type == BubbleTypeNotification || type == BubbleTypeReceiptMine || type == BubbleTypeReceiptSomeone)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if (type == BubbleTypeNotification)
        {
            paragraphStyle.alignment = NSTextAlignmentCenter;
        }
        else
        {
            paragraphStyle.alignment = (type == BubbleTypeReceiptMine) ? NSTextAlignmentRight : NSTextAlignmentLeft;
        }
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    paragraphStyle, NSParagraphStyleAttributeName, nil];
        [attrString addAttributes:attributes range:NSMakeRange(0, text.length)];
        
#if !__has_feature(objc_arc)
        [paragraphStyle release];
#endif
        
        // static width, variable height
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
        CGSize targetSize = CGSizeMake(300.f, CGFLOAT_MAX);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]),
                                                                      NULL, targetSize, NULL);
        CFRelease(framesetter);
        
        label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0.f, 0, 300.f, fitSize.height)];
    }
    else
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
        CGSize targetSize = CGSizeMake(220.f, CGFLOAT_MAX);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]),
                                                                      NULL, targetSize, NULL);
        CFRelease(framesetter);
        
        label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, fitSize.width, fitSize.height)];
        
        label.autoDetectLinks = YES;
        label.linksHaveUnderlines = YES;
        NSMutableDictionary *attributes = [[text attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
        [attributes setObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
        label.attributesForLinks = attributes;
        label.delegate = self;
    }
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.attributedText = attrString;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [attrString release];
    [label autorelease];
#endif
    
    UIEdgeInsets insets = textInsetsMine;
    if (type == BubbleTypeSomeoneElse || type == BubbleTypeSomeoneElsePrivate)
    {
        insets = textInsetsSomeone;
    }
    else if (type == BubbleTypeNotification)
    {
        insets = textInsetsNotification;
    }
    else if (type == BubbleTypeReceiptMine || type == BubbleTypeReceiptSomeone)
    {
        insets = textInsetsReadReceipt;
    }
    
    return [self initWithView:label date:date type:type insets:insets];
}

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type];
#endif
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type
{
    _type = type;

    if (text == nil)
    {
        text = @"";
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    NIAttributedLabel *label = nil;
    
    if (type == BubbleTypeNotification || type == BubbleTypeReceiptMine || type == BubbleTypeReceiptSomeone)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if (type == BubbleTypeNotification)
        {
            paragraphStyle.alignment = NSTextAlignmentCenter;
        }
        else
        {
            paragraphStyle.alignment = (type == BubbleTypeReceiptMine) ? NSTextAlignmentRight : NSTextAlignmentLeft;
        }
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont boldSystemFontOfSize:12], NSFontAttributeName,
                                    (type == BubbleTypeNotification) ? [UIColor blackColor] : [UIColor grayColor], NSForegroundColorAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName, nil];
        [attributedText addAttributes:attributes range:NSMakeRange(0, attributedText.length)];
        
#if !__has_feature(objc_arc)
        [paragraphStyle release];
#endif
        
        // static width, variable height
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
        CGSize targetSize = CGSizeMake(300.f, CGFLOAT_MAX);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]),
                                                                      NULL, targetSize, NULL);
        CFRelease(framesetter);

        label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0.f, 0, 300.f, fitSize.height)];
        label.shadowOffset = CGSizeMake(0, 1);
        label.shadowColor = [UIColor whiteColor];
    }
    else
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Helvetica" size:15], NSFontAttributeName,
                                    [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [attributedText addAttributes:attributes range:NSMakeRange(0, text.length)];
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
        CGSize targetSize = CGSizeMake(220.f, CGFLOAT_MAX);
        CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]),
                                                                      NULL, targetSize, NULL);
        CFRelease(framesetter);
        
        label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, fitSize.width, fitSize.height)];
        
        label.autoDetectLinks = YES;
        label.linksHaveUnderlines = YES;
        label.attributesForLinks = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Helvetica" size:15], NSFontAttributeName,
                                    [UIColor blueColor], NSForegroundColorAttributeName, nil];
        label.delegate = self;
    }
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.attributedText = attributedText;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [attributedText release];
    [label autorelease];
#endif
    
    UIEdgeInsets insets = textInsetsMine;
    if (type == BubbleTypeSomeoneElse || type == BubbleTypeSomeoneElsePrivate)
    {
        insets = textInsetsSomeone;
    }
    else if (type == BubbleTypeNotification)
    {
        insets = textInsetsNotification;
    }
    else if (type == BubbleTypeReceiptMine || type == BubbleTypeReceiptSomeone)
    {
        insets = textInsetsReadReceipt;
    }
    
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type
{
    CGSize size = image.size;
    if (size.width > 220)
    {
        size.height /= (size.width / 220);
        size.width = 220;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view bubble

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

#pragma mark - NIAttributedLabel Delegate

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel
didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point;
{
    if (result.resultType == NSTextCheckingTypeLink)
    {
        [[UIApplication sharedApplication] openURL:result.URL.absoluteURL];
    }
}

- (bool)isChat
{
    return self.isChatMine || self.isChatSomeoneElse;
}

- (bool)isChatMine
{
    return (self.type == BubbleTypeMine || self.type == BubbleTypeMinePrivate);
}

- (bool)isChatSomeoneElse
{
    return (self.type == BubbleTypeSomeoneElse || self.type == BubbleTypeSomeoneElsePrivate);
}

- (bool)isPrivate
{
    return (self.type == BubbleTypeMinePrivate || self.type == BubbleTypeSomeoneElsePrivate);
}


@end
