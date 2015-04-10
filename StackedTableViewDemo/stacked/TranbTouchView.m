//
//  TranbTouchView.m
//  TableDemo
//
//  Created by caiwenshu on 4/3/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import "TranbTouchView.h"
#import "TranbPageIndicatorView.h"
#import "UIView+Size.h"

typedef void(^PSSVSimpleBlock)(void);
#define kTranbStackAnimationSpeedModifier 1.f // DEBUG!
#define kTranbtackAnimationDuration kTranbStackAnimationSpeedModifier * 0.25f

@interface TranbTouchView ()<UIGestureRecognizerDelegate>
{
    NSInteger lastDragOffset_;
    BOOL lastDragDividedOne_;
}
 //
@property(nonatomic, strong) TranbPageIndicatorView *pageIndicatorView;
@property (weak,   nonatomic) UITableView *observingScrollView;

/// pangesture recognizer used
@property(nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation TranbTouchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame observingScrollView:(UITableView *)observingScrollView showIndicator:(BOOL)showIndicator
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.enabledPan  = YES;

        //UI
        [self initializationSubViewsWithShowIndicator:showIndicator];
        
        [self configureGestureRecognizer];
        
        //开始监听
        [self startObservingContentOffsetForScrollView:observingScrollView];
    }
    return self;
}


-(void)initializationSubViewsWithShowIndicator:(BOOL)showIndicator
{
 
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];

    if (showIndicator) {
        //-------箭头初始化----
        self.pageIndicatorView = [[TranbPageIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f , 10.0f)];
        [self.pageIndicatorView setColor: [UIColor redColor]];
        [self addSubview:self.pageIndicatorView];
    }

    //-------tableview 初始化----
    CGRect rect = self.bounds;
    rect.origin.x = self.pageIndicatorView.bounds.size.width;
    rect.size.width -= rect.origin.x;
    
    self.cTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.cTableView.backgroundColor = [UIColor redColor];
    self.cTableView.showsVerticalScrollIndicator = NO;
    self.cTableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.cTableView];
    
    [self extraCellLineHidden:self.cTableView];
}

-(void)setttingThemeColor:(UIColor *)col
{
    self.cTableView.backgroundColor = col;
    [self.pageIndicatorView setColor:col];
}

#pragma mark - 加载监听
- (void)startObservingContentOffsetForScrollView:(UITableView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - KVO 及其 辅助方法

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    CGRect rect = self.pageIndicatorView.frame;
    rect.origin.y = [self centerForObservingViewSelectedItem].y;
    
    self.pageIndicatorView.frame = rect;
}

- (CGPoint)centerForObservingViewSelectedItem
{

    NSIndexPath *indexPath = [self.observingScrollView indexPathForSelectedRow];
    
    if (indexPath != nil) {
        if ([self.observingScrollView numberOfRowsInSection:indexPath.section] <= indexPath.row) {
            return CGPointZero;
        }
        
        CGRect rect = [self.observingScrollView rectForRowAtIndexPath:indexPath];
        
        CGPoint offset = self.observingScrollView.contentOffset;
        offset.y =  (CGRectGetMidY(rect)) - offset.y - (self.pageIndicatorView.height / 2.0f);
        return offset;
        
    }
    return CGPointZero;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 手势监听

- (void)configureGestureRecognizer
{
    [self removeGestureRecognizer:self.panRecognizer];
    
    //add a gesture recognizer to detect dragging to the guest controllers
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:NO];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    self.panRecognizer = panRecognizer;
    
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (!self.enabledPan) {
        return;
    }
    
    CGPoint translatedPoint = [recognizer translationInView:self];
    UIGestureRecognizerState state = recognizer.state;

    // reset last offset if gesture just started
    if (state == UIGestureRecognizerStateBegan) {
        lastDragOffset_ = 0;
    }

//    NSLog(@"handlePanFrom:%f,%f",translatedPoint.x,translatedPoint.y);
    
    NSInteger offset = translatedPoint.x - lastDragOffset_;

    // we only want to move full pixels - but if we drag slowly, 1 get divided to zero.
    // so only omit every second event
    if (labs(offset) == 1) {
        if(!lastDragDividedOne_) {
            lastDragDividedOne_ = YES;
            offset = 0;
        }else {
            lastDragDividedOne_ = NO;
        }
    }else {
        offset = roundf(offset/2.f);
    }
    
    [self moveStackWithOffset:offset];

    // save last point to calculate new offset
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        lastDragOffset_ = translatedPoint.x;
    }

    // perform snapping after gesture ended
    BOOL gestureEnded = state == UIGestureRecognizerStateEnded;
    if (gestureEnded) {
        [self alignStackAnimated:YES];
        
    }
}

- (void)alignStackAnimated:(BOOL)animated {
    
    CGFloat duration = kTranbtackAnimationDuration;
    CGFloat gridOffset = [self gridOffsetByPixels];
    
    // some magic numbers to better reflect movement time
    duration = abs(gridOffset)/200.f * duration * 0.4f + duration * 0.6f;

    CGRect r = self.frame;
    CGFloat offset = 0.0f;
    // iterate over all view controllers and snap them to their correct positions
    if (self.left - [self stackDisplayX] >=  [self stackMoveGap]) {
        
        offset = r.origin.x - [self stackDefaultX];
        
    } else if (self.left - [self stackDisplayX] <  [self stackMoveGap])
    {
        offset = r.origin.x - [self stackDisplayX];
    }
    
    if (offset == 0.0f) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(stackedTouchViewDidGestureEnded:duration:offset:)]) {
        [self.delegate stackedTouchViewDidGestureEnded:self duration:duration offset:offset];
    }

    [self alignStackAnimated:animated duration:duration offset:offset];
 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
// returns +/- amount if grid is not aligned correctly
// + if view is too far on the right, - if too far on the left
- (CGFloat)gridOffsetByPixels {
    CGFloat gridOffset = 0;
    
    // easiest case, controller is > then wide menu
    if (self.left - [self stackDisplayX] >=  [self stackMoveGap]) {
        
        gridOffset = [self stackDefaultX] - self.left;
        
    } else if (self.left - [self stackDisplayX] <  [self stackMoveGap])
    {
        gridOffset = [self stackDisplayX] - self.left;
    }
    
    return gridOffset;
}

//-----------------------手势动画---------------------------------------------
#pragma mark - Public 动画调用方法集
//移动当前页面的位置(无动画)--用于拖动的页面移动
- (void)moveStackWithOffset:(NSInteger)offset{
    
    [self stopStackAnimation];
    
    if ( [self stackDisplayX] <= (self.left +  offset)) {
        self.left += offset;
        if ([self.delegate respondsToSelector:@selector(stackedTouchView:moveOffset:)]) {
            [self.delegate stackedTouchView:self moveOffset:offset];
        }
    }
    
}

//移动当前页面到指定位置(有动画)--用于拖动完成后的页面组动画
- (void)alignStackAnimated:(BOOL)animated  duration:(CGFloat)duration offset:(CGFloat)offset {
    
    
    PSSVSimpleBlock alignmentBlock = ^{
        
        CGRect r = self.frame;
        r.origin.x -= offset;
        self.frame = r;
    };
    if (animated) {
        [UIView animateWithDuration:duration
                              delay:0.f
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear
                         animations:alignmentBlock
                         completion:^(BOOL finished) {
                             //归位
                             if (self.left != [self stackDisplayX] && self.left != [self stackDefaultX]) {
                                 
                                 CGRect r = self.frame;
                                 
                                 // iterate over all view controllers and snap them to their correct positions
                                 if (self.left  >= [self stackDefaultX]) {
                                     r.origin.x = [self stackDefaultX];
                                     
                                 } else
                                 {
                                     r.origin.x = [self stackDisplayX];
                                 }
                                 
                                 self.frame = r;
                             }
                             
                             //to show status
                             if (self.left == [self stackDisplayX]) {
                                 
                                 [self.delegate stackedTouchViewDidShow:self];
                                 
                             } else {
                                 
                                 [self.delegate stackedTouchViewDidHidden:self];
                                 
                             }
                             
                         }
         ];
    }
    else {
        alignmentBlock();
        
    }
    
}

-(void)movingIndicatorToSelectedIndexPath
{
    CGRect rect = self.pageIndicatorView.frame;
    rect.origin.y = [self centerForObservingViewSelectedItem].y;
    
    [UIView animateWithDuration:kTranbtackAnimationDuration animations:^{
        self.pageIndicatorView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)toShowWithAnimation:(BOOL)animated
{
    CGRect r = self.frame;
    
    r.origin.x = [self stackDisplayX];
    
    [self moveFrameWithAnimation:animated targetFrame:r];
    
}


-(void)toHiddenWithAnimation:(BOOL)animated
{
    CGRect r = self.frame;
    
    r.origin.x = [self stackDefaultX];

    [self moveFrameWithAnimation:animated targetFrame:r];
    
}


#pragma mark - Privates
//删除所有其他动画
- (void)stopStackAnimation {
    // remove all current animations
    [self.layer removeAllAnimations];
}


-(void)moveFrameWithAnimation:(BOOL)animated targetFrame:(CGRect)frame
{
    [UIView animateWithDuration:animated ? kTranbtackAnimationDuration : 0.0f
                          delay:0.f
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveLinear
                     animations:^{
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             //to show status
                             if (self.left == [self stackDisplayX]) {
                                 
                                 [self.delegate stackedTouchViewDidShow:self];
                                 
                             } else {
                                 
                                 [self.delegate stackedTouchViewDidHidden:self];
                                 
                             }
                         }
                     }];
}

//隐藏额外的多余的线段
-(void)extraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


-(void)dealloc
{
    [self stopObservingContentOffset];
    NSString *prt = [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])];
    NSLog(@"%@", prt);
}

@end
