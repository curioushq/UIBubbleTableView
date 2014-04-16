//
//  UIBubbleTableView.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "UIBubbleHeaderTableViewCell.h"
#import "UIBubbleTypingTableViewCell.h"
#import "UIBubbleNotificationTableViewCell.h"
#import "UIBubbleReceiptTableViewCell.h"

@interface UIBubbleTableView ()

@property (nonatomic, retain) NSMutableArray *bubbleSection;

@end

@implementation UIBubbleTableView

@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize snapInterval = _snapInterval;
@synthesize bubbleSection = _bubbleSection;
@synthesize typingBubble = _typingBubble;
@synthesize showAvatars = _showAvatars;

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    // UIBubbleTableView default properties
    
    self.snapInterval = 120;
    self.typingBubble = NSBubbleTypingTypeNobody;
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_bubbleSection release];
	_bubbleSection = nil;
	_bubbleDataSource = nil;
    [super dealloc];
}
#endif

#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;
#if !__has_feature(objc_arc)
    self.bubbleSection = [[[NSMutableArray alloc] init] autorelease];
#else
    self.bubbleSection = [[NSMutableArray alloc] init];
#endif
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
#if !__has_feature(objc_arc)
        NSMutableArray *bubbleData = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
#else
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
#endif
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             NSBubbleData *bubbleData1 = (NSBubbleData *)obj1;
             NSBubbleData *bubbleData2 = (NSBubbleData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];
         }];
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            NSBubbleData *data = (NSBubbleData *)[bubbleData objectAtIndex:i];
            
            if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
            {
#if !__has_feature(objc_arc)
                currentSection = [[[NSMutableArray alloc] init] autorelease];
#else
                currentSection = [[NSMutableArray alloc] init];
#endif
                [self.bubbleSection addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
    
    [super reloadData];
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
	if (section >= [self.bubbleSection count]) return 1;
    
    return [[self.bubbleSection objectAtIndex:section] count] + 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        return MAX([UIBubbleTypingTableViewCell height], self.showAvatars ? 55 : 0);
    }
    
    // Header
    if (indexPath.row == 0)
    {
        return [UIBubbleHeaderTableViewCell height];
    }
    
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    
    if (data.type == BubbleTypeMine)
    {
        return [UIBubbleTableViewCell heightForData:data showAvatar:self.showAvatars && !self.hideMyAvatar];
    }
    else if (data.type == BubbleTypeNotification || data.type == BubbleTypeReceiptMine || data.type == BubbleTypeReceiptSomeone)
    {
        return [UIBubbleTableViewCell heightForData:data showAvatar:NO];
    }
    
    return [UIBubbleTableViewCell heightForData:data showAvatar:self.showAvatars];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.blankFooterSpace > 0 && section == [self.bubbleSection count] - 1)
    {
        UIView *footer = [[UIView alloc] init];
        footer.userInteractionEnabled = NO;
        footer.frame = CGRectMake(0, 0, 1, self.blankFooterSpace);
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.blankFooterSpace > 0 && section == [self.bubbleSection count] - 1)
    {
        return self.blankFooterSpace;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Now typing
	if (indexPath.section >= [self.bubbleSection count])
    {
        static NSString *cellId = @"tblBubbleTypingCell";
        UIBubbleTypingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) cell = [[UIBubbleTypingTableViewCell alloc] init];
        
        cell.type = self.typingBubble;
        cell.showAvatar = self.showAvatars;
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // Header with date and time
    if (indexPath.row == 0)
    {
        static NSString *cellId = @"tblBubbleHeaderCell";
        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
        
        if (cell == nil) cell = [[UIBubbleHeaderTableViewCell alloc] init];
        
        cell.drawLines = self.divideWithLines;
        cell.font = self.headerFont;
        cell.date = data.date;
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // Notifcation bubble
    NSBubbleData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row - 1];
    if (data.type == BubbleTypeNotification)
    {
        static NSString *cellId = @"tblBubbleNotificationCell";
        UIBubbleNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

        if (cell == nil) cell = [[UIBubbleNotificationTableViewCell alloc] init];
        
        cell.data = data;
        
        // fixme - run this through the NSBubbleData object
        cell.showAvatar = false;
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // Read receipt
    if (data.type == BubbleTypeReceiptMine || data.type == BubbleTypeReceiptSomeone)
    {
        static NSString *cellId = @"tblBubbleReceiptCell";
        UIBubbleReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) cell = [[UIBubbleReceiptTableViewCell alloc] init];
        
        // setup
        cell.data = data;
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // Standard bubble
    static NSString *cellId = @"tblBubbleCell";
    UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) cell = [[UIBubbleTableViewCell alloc] init];
    
    BOOL showAvatars = self.showAvatars;
    if (data.type == BubbleTypeMine)
    {
        showAvatars = showAvatars && !self.hideMyAvatar;
    }
    
    cell.data = data;
    cell.showAvatar = showAvatars;
    cell.avatarFont = self.avatarFont;
    cell.imageBubbleMine = self.imageBubbleMine;
    cell.imageBubbleMineSelected = self.imageBubbleMineSelected;
    cell.imageBubbleOther = self.imageBubbleOther;
    cell.imageBubbleOtherSelected = self.imageBubbleOtherSelected;
    cell.edgeInsetsMine = self.edgeInsetsMine;
    cell.edgeInsetsOther = self.edgeInsetsOther;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.bubbleDelegate scrollViewWillBeginDragging:scrollView];
    }
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.bubbleDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.bubbleDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.bubbleDelegate scrollViewDidScroll:scrollView];
    }
}

@end
