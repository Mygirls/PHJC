//
//  AHKActionSheet.m
//  AHKActionSheetExample
//
//  Created by Arkadiusz on 08-04-14.
//  Copyright (c) 2014 Arkadiusz Holko. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AHKActionSheet.h"
#import "AHKActionSheetViewController.h"
//#import "UIImage+AHKAdditions.h"
#import "UIWindow+AHKAdditions.h"


static const NSTimeInterval kDefaultAnimationDuration = 0.3f;
// Length of the range at which the blurred background is being hidden when the user scrolls the tableView to the top.
//static const CGFloat kBlurFadeRangeSize = 200.0f;
static NSString * const kCellIdentifier = @"Cell";
// How much user has to scroll beyond the top of the tableView for the view to dismiss automatically.
static const CGFloat kAutoDismissOffset = 80.0f;
// Offset at which there's a check if the user is flicking the tableView down.
static const CGFloat kFlickDownHandlingOffset = 20.0f;
static const CGFloat kFlickDownMinVelocity = 2000.0f;
// How much free space to leave at the top (above the tableView's contents) when there's a lot of elements. It makes this control look similar to the UIActionSheet.
//static const CGFloat kTopSpaceMarginFraction = 0.333f;
// cancelButton's shadow height as the ratio to the cancelButton's height
static const CGFloat kCancelButtonShadowHeightRatio = 0.333f;

/// Used for storing button configuration.
@interface AHKActionSheetItem : NSObject <CAAnimationDelegate>
@property (copy, nonatomic) NSString *title, *accessory_title;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) AHKActionSheetButtonType type;
@property (strong, nonatomic) AHKActionSheetHandler handler;
@end

@implementation AHKActionSheetItem
@end
@interface AHKActionSheet() <UITableViewDataSource, UITableViewDelegate,CAAnimationDelegate>
@property (strong, nonatomic) NSMutableArray *items;
@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UIView *blurredBackgroundView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) UIView *cancelButtonShadowView, *line_view;
@end

@implementation AHKActionSheet

#pragma mark - Init

+ (void)initialize
{
    if (self != [AHKActionSheet class]) {
        return;
    }

    AHKActionSheet *appearance = [self appearance];
    [appearance setBlurRadius:16.0f];
//    [appearance setBlurTintColor:[UIColor clearColor]];
//    [appearance setBlurSaturationDeltaFactor:1.8f];
    [appearance setButtonHeight:50.0f];
    [appearance setCancelButtonHeight:50.0f];
//    [appearance setAutomaticallyTintButtonImages:@YES];
//    [appearance setSelectedBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.0f]];
    [appearance setCancelButtonTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                 NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    [appearance setButtonTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f]}];
    [appearance setDestructiveButtonTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                      NSForegroundColorAttributeName : [UIColor redColor] }];
    [appearance setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                                      NSForegroundColorAttributeName : [UIColor redColor] }];
    [appearance setAnimationDuration:kDefaultAnimationDuration];
    
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];

    if (self) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _title = [title copy];
        _cancelButtonTitle = @"取消";
        
        
    }

    return self;
}

- (instancetype)init
{
    return [self initWithTitle:nil];
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)[self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellStyle style = [self.buttonTextCenteringEnabled boolValue] ? UITableViewCellStyleDefault : UITableViewCellStyleSubtitle;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.textColor = [CMCore basic_black_color];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:kCellIdentifier];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v1_cellAccessoryView_choice"]];
    }
    AHKActionSheetItem *item = self.items[(NSUInteger)indexPath.row];
    NSDictionary *attributes = item.type == AHKActionSheetButtonTypeDefault ? self.buttonTextAttributes : self.destructiveButtonTextAttributes;
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:item.title attributes:attributes];
    cell.textLabel.attributedText = attrTitle;
    cell.textLabel.textAlignment = [self.buttonTextCenteringEnabled boolValue] ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    
    cell.detailTextLabel.text = item.accessory_title;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.imageView.image = item.image;
    cell.backgroundColor = [UIColor whiteColor];

    if (self.selectedBackgroundColor && ![cell.selectedBackgroundView.backgroundColor isEqual:self.selectedBackgroundColor]) {
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = self.selectedBackgroundColor;
    }
    if (cell.detailTextLabel && cell.detailTextLabel.text.length > 0) {
        if ([cell.detailTextLabel.text isEqualToString:_selected_str]) {
            cell.accessoryView.hidden = NO;
        }else
        {
            cell.accessoryView.hidden = YES;
        }
    }else
    {
        if ([cell.textLabel.text isEqualToString:_selected_str]) {
            cell.accessoryView.hidden = NO;
        }else
        {
            cell.accessoryView.hidden = YES;
        }
        
    }
    

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{[tableView deselectRowAtIndexPath:indexPath animated:YES];
    AHKActionSheetItem *item = self.items[(NSUInteger)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [CMCore basic_black_color];
    cell.accessoryView.hidden = NO;
    _selected_str = cell.textLabel.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(get_clicked_cell_index:)]) {
        [self.delegate get_clicked_cell_index:indexPath.row];
    }
    [self dismissAnimated:YES duration:self.animationDuration completion:item.handler];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cancelButtonHeight;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self fadeBlursOnScrollToTop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint scrollVelocity = [scrollView.panGestureRecognizer velocityInView:self];

    BOOL viewWasFlickedDown = scrollVelocity.y > kFlickDownMinVelocity && scrollView.contentOffset.y < -self.tableView.contentInset.top - kFlickDownHandlingOffset;
    BOOL shouldSlideDown = scrollView.contentOffset.y < -self.tableView.contentInset.top - kAutoDismissOffset;
    if (viewWasFlickedDown) {
        // use a shorter duration for a flick down animation
//        static const NSTimeInterval duration = 0.2f;
        [self dismissAnimated:YES duration:self.animationDuration completion:self.cancelHandler];
    } else if (shouldSlideDown) {
        [self dismissAnimated:YES duration:self.animationDuration completion:self.cancelHandler];
    }
}

#pragma mark - Properties

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }

    return _items;
}

#pragma mark - Actions

- (void)cancelButtonTapped:(id)sender
{
    [self dismissAnimated:YES duration:self.animationDuration completion:self.cancelHandler];
}
- (void)tap_background_view {
    [self dismissAnimated:YES duration:self.animationDuration completion:self.cancelHandler];
}
#pragma mark - Public

- (void)addButtonWithTitle:(NSString *)title type:(AHKActionSheetButtonType)type handler:(AHKActionSheetHandler)handler
{
    [self addButtonWithTitle:title image:nil type:type handler:handler];
}

- (void)addButtonWithTitle:(NSString *)title image:(UIImage *)image type:(AHKActionSheetButtonType)type handler:(AHKActionSheetHandler)handler
{
    AHKActionSheetItem *item = [[AHKActionSheetItem alloc] init];
    item.title = title;
    item.image = image;
    item.type = type;
    item.handler = handler;
    [self.items addObject:item];
}
- (void)addButtonWithTitle:(NSString *)title accessory_title:(NSString *)accessory_title image:(UIImage *)image type:(AHKActionSheetButtonType)type handler:(AHKActionSheetHandler)handler {
    AHKActionSheetItem *item = [[AHKActionSheetItem alloc] init];
    item.title = title;
    item.accessory_title = accessory_title;
    item.image = image;
    item.type = type;
    item.handler = handler;
    [self.items addObject:item];
}
- (void)show
{
    NSAssert([self.items count] > 0, @"Please add some buttons before calling -show.");

    BOOL actionSheetIsVisible = !!self.window; // action sheet is visible iff it's associated with a window
    if (actionSheetIsVisible) {
        return;
    }

    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    UIImage *previousKeyWindowSnapshot = [self.previousKeyWindow ahk_snapshot];

    [self setUpNewWindow];
    [self setUpBlurredBackgroundWithSnapshot:previousKeyWindowSnapshot];
    [self setUpCancelButton];
    [self setUpTableView];
    self.cancelButton.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.bounds) - self.cancelButtonHeight,
                                         CGRectGetWidth(self.bounds),
                                         self.cancelButtonHeight);
    self.blurredBackgroundView.alpha = 0.3f;
//    CGFloat tableContentHeight = [self.items count] * self.buttonHeight + CGRectGetHeight(self.tableView.tableHeaderView.frame);
    CGFloat tableContentHeight = [self.items count] * _cancelButtonHeight + _cancelButtonHeight;
    CGFloat topInset;
    BOOL buttonsFitInWithoutScrolling = tableContentHeight < CGRectGetHeight(self.tableView.frame);
    if (buttonsFitInWithoutScrolling) {
        // show all buttons if there isn't many
        topInset = 0;//CGRectGetHeight(self.tableView.frame) - tableContentHeight
        CGRect frame = CGRectMake(0,
                                  CGRectGetHeight(self.bounds) - _cancelButtonHeight - tableContentHeight,
                                  CGRectGetWidth(self.bounds),
                                  tableContentHeight);
        self.tableView.frame = frame;
        
    } else {
        // leave an empty space on the top to make the control look similar to UIActionSheet
//        topInset = (CGFloat)round(CGRectGetHeight(self.tableView.frame) * kTopSpaceMarginFraction);
        topInset = 0;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = self.animationDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self.tableView.layer addAnimation:animation forKey:@"AHKAnimationSheet"];
}

- (void)dismissAnimated:(BOOL)animated
{
    [self dismissAnimated:animated duration:self.animationDuration completion:self.cancelHandler];
}

#pragma mark - Private

- (void)dismissAnimated:(BOOL)animated duration:(NSTimeInterval)duration completion:(AHKActionSheetHandler)completionHandler
{
    // delegate isn't needed anymore because tableView will be hidden (and we don't want delegate methods to be called now)
    self.line_view.alpha = 0.0f;
    self.tableView.delegate = nil;
    self.tableView.userInteractionEnabled = NO;
    // keep the table from scrolling back up
    self.tableView.contentInset = UIEdgeInsetsMake(-self.tableView.contentOffset.y, 0, 0, 0);

    void(^tearDownView)(void) = ^(void) {
        // remove the views because it's easiest to just recreate them if the action sheet is shown again
        if (completionHandler) {
            completionHandler(self);
        }
    };
    if (animated) {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = duration;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.tableView setAlpha:0.0f];
        [self.cancelButton setAlpha:0.0f];
        [self.tableView.layer addAnimation:animation forKey:@"AHKAnimationSheet"];
        [self.cancelButton.layer addAnimation:animation forKey:@"AHKAnimationSheet"];
        [self performSelector:@selector(remove_some_subViews) withObject:nil afterDelay:duration];
    }
        else {
            [self remove_some_subViews];
        tearDownView();
    }
}
- (void)remove_some_subViews {
    for (UIView *view in @[self.tableView, self.cancelButton, self.blurredBackgroundView, self.window]) {
        [view removeFromSuperview];
    }
    self.window = nil;
    [self.previousKeyWindow makeKeyAndVisible];
}
- (void)setUpNewWindow
{
    AHKActionSheetViewController *actionSheetVC = [[AHKActionSheetViewController alloc] initWithNibName:nil bundle:nil];
    actionSheetVC.actionSheet = self;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.rootViewController = actionSheetVC;
    [self.window makeKeyAndVisible];
}

- (void)setUpBlurredBackgroundWithSnapshot:(UIImage *)previousKeyWindowSnapshot
{
//    UIImage *blurredViewSnapshot = [previousKeyWindowSnapshot
//                                    ahk_applyBlurWithRadius:self.blurRadius
//                                    tintColor:self.blurTintColor
//                                    saturationDeltaFactor:self.blurSaturationDeltaFactor
//                                    maskImage:nil];
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:blurredViewSnapshot];
//    backgroundView.frame = self.bounds;
//    backgroundView.alpha = 0.0f;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.3f;
    [self addSubview:backgroundView];
    
    self.blurredBackgroundView = backgroundView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_background_view)];
    self.blurredBackgroundView.userInteractionEnabled = YES;
    [self.blurredBackgroundView addGestureRecognizer:tap];
    
}

- (void)setUpCancelButton
{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.backgroundColor = [UIColor whiteColor];
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:self.cancelButtonTitle
                                                                    attributes:self.cancelButtonTextAttributes];
    [cancelButton setAttributedTitle:attrTitle forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.bounds) - self.cancelButtonHeight,
                                    CGRectGetWidth(self.bounds),
                                    self.cancelButtonHeight);
    // move the button below the screen (ready to be animated -show)
    cancelButton.transform = CGAffineTransformMakeTranslation(0, self.cancelButtonHeight);
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;

    // add a small shadow/glow above the button
    if (self.cancelButtonShadowColor) {
        self.cancelButton.clipsToBounds = NO;
        CGFloat gradientHeight = (CGFloat)round(self.cancelButtonHeight * kCancelButtonShadowHeightRatio);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -gradientHeight, CGRectGetWidth(self.bounds), gradientHeight)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
//        gradient.colors = @[ (id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor, (id)[self.blurTintColor colorWithAlphaComponent:0.1f].CGColor ];
        gradient.colors = @[ (id)[UIColor whiteColor].CGColor, (id)[self.blurTintColor colorWithAlphaComponent:0.1f].CGColor ];
        [view.layer insertSublayer:gradient atIndex:0];
        [self.cancelButton addSubview:view];
        self.cancelButtonShadowView = view;
    }
    UIView *line_view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds) - self.cancelButtonHeight - 4, CGRectGetWidth(self.bounds), 4)];
    self.line_view = line_view;
    line_view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self addSubview:line_view];
    
}

- (void)setUpTableView
{
//    CGRect statusBarViewRect = [self convertRect:[UIApplication sharedApplication].statusBarFrame fromView:nil];
//    CGFloat statusBarHeight = CGRectGetHeight(statusBarViewRect);
    CGRect frame = CGRectMake(0,
                              CGRectGetHeight(self.bounds) - 5 * _cancelButtonHeight,
                              CGRectGetWidth(self.bounds),
                               4 * _cancelButtonHeight);

    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    if (self.separatorColor) {
        tableView.separatorColor = self.separatorColor;
    }

    tableView.delegate = self;
    tableView.dataSource = self;
    
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self insertSubview:tableView aboveSubview:self.blurredBackgroundView];
    // move the content below the screen, ready to be animated in -show
    tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.bounds), 0, 0, 0);

    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.tableView.bounces = NO;
//    [self setUpTableViewHeader];
}
//- (void)setUpTableViewHeader
//{
//    if (self.title) {
//        // paddings similar to those in the UITableViewCell
////        static const CGFloat leftRightPadding = 0.0f;
////        static const CGFloat topBottomPadding = 0.0f;
////        CGFloat labelWidth = CGRectGetWidth(self.bounds) - 2*leftRightPadding;
//
//        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.title attributes:self.titleTextAttributes];
//        // create a label and calculate its size
//        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor whiteColor];
//        label.numberOfLines = 0;
//        [label setAttributedText:attrText];
////        CGSize labelSize = [label sizeThatFits:CGSizeMake(labelWidth, MAXFLOAT)];
////        label.frame = CGRectMake(leftRightPadding, topBottomPadding, labelWidth, labelSize.height);
//        label.frame = CGRectMake(0, 0, kScreenWidth, self.buttonHeight);
//        // create and add a header consisting of the label
////        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), labelSize.height + 2*topBottomPadding)];
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.buttonHeight)];
//        [headerView addSubview:label];
//        self.tableView.tableHeaderView = headerView;
//
//    } else if (self.headerView) {
//        self.tableView.tableHeaderView = self.headerView;
//    }
//
//    // add a separator between the tableHeaderView and a first row (technically at the bottom of the tableHeaderView)
//    if (self.tableView.tableHeaderView && self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
//        CGFloat separatorHeight = 1.0f / [UIScreen mainScreen].scale;
//        CGRect separatorFrame = CGRectMake(0,
//                                           CGRectGetHeight(self.tableView.tableHeaderView.frame) - separatorHeight,
//                                           CGRectGetWidth(self.tableView.tableHeaderView.frame),
//                                           separatorHeight);
//        UIView *separator = [[UIView alloc] initWithFrame:separatorFrame];
//        separator.backgroundColor = self.tableView.separatorColor;
//        [self.tableView.tableHeaderView addSubview:separator];
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.title) {
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:self.title attributes:self.titleTextAttributes];
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:17];
            label.backgroundColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            [label setAttributedText:attrText];
            label.frame = CGRectMake(15, 0, kScreenWidth - 15, _cancelButtonHeight);
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, _cancelButtonHeight - 0.5, kScreenWidth - 15, 0.5)];
            line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _cancelButtonHeight)];
            headerView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:label];
            [headerView addSubview:line];
            return headerView;
        }
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _cancelButtonHeight;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (void)fadeBlursOnScrollToTop
{
    
//    if (self.tableView.isDragging || self.tableView.isDecelerating) {
//        CGFloat alphaWithoutBounds = 1.0f - ( -(self.tableView.contentInset.top + self.tableView.contentOffset.y) / kBlurFadeRangeSize);
//        // limit alpha to the interval [0, 1]
//        CGFloat alpha = (CGFloat)fmax(fmin(alphaWithoutBounds, 1.0f), 0.0f);
////        self.blurredBackgroundView.alpha = alpha;
//        self.cancelButtonShadowView.alpha = alpha;
//    }
}

@end
