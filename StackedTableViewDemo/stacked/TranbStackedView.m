//
//  TranbStackedView.m
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import "TranbStackedView.h"
#import "TranbTouchView.h"
#import "UIImage+imageWithColor.h"

#import "PrimaryProductIndustryTableViewCell.h"
#import "SecondaryProductIndustryTableViewCell.h"
#import "TertiaryProductIndustryTableViewCell.h"

#define StackedRectX(f)                            f.origin.x
#define StackedRectY(f)                            f.origin.y
#define StackedRectWidth(f)                        f.size.width
#define StackedRectHeight(f)                       f.size.height

//定义2中显示状态
#define IndSubViewDefault_X StackedRectWidth(self.bounds)
#define IndSubViewDisplay_X 50.0f
#define IndSubViewDefault_Width (StackedRectWidth(self.bounds) - IndSubViewDisplay_X)
#define IndSubViewDefault_Frame CGRectMake(IndSubViewDefault_X, StackedRectY(self.bounds), IndSubViewDefault_Width, StackedRectHeight(self.bounds))

//定义2种形态
#define IndDetailViewDefault_X StackedRectWidth(self.bounds) //初始状态下的x
#define IndDetailViewDisplay_X 190.0f
#define IndDetailViewDefault_Width (StackedRectWidth(self.bounds) - IndDetailViewDisplay_X)
#define IndDetailViewDefault_Frame CGRectMake(IndDetailViewDefault_X, StackedRectY(self.bounds), IndDetailViewDefault_Width, StackedRectHeight(self.bounds))

@interface TranbStackedView ()<UITableViewDataSource,UITableViewDelegate,TranbTouchViewDelegate>
{
    
}

//页面控制
@property(nonatomic, strong) NSMutableArray *productIndustryViews;


//数据集的展示
@property(nonatomic, strong) NSMutableArray *productIndustryData;

@end


@implementation TranbStackedView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.productIndustryViews = [NSMutableArray array];
        
        //UI
        [self initializationSubCompontents];
        
    }
    return self;
}

-(void)initializationSubCompontents
{
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    
    TranbTouchView *rTableView = [[TranbTouchView alloc] initWithFrame:self.bounds observingScrollView:nil showIndicator:NO];
    rTableView.cTableView.delegate = self;
    rTableView.cTableView.dataSource = self;
    rTableView.backgroundColor = [UIColor clearColor];
    rTableView.enabledPan = NO;
    [self addSubview:rTableView];
    
    [rTableView setttingThemeColor:[UIColor whiteColor]];
    
    TranbTouchView *sTableView = [[TranbTouchView alloc] initWithFrame:IndSubViewDefault_Frame observingScrollView:rTableView.cTableView showIndicator:YES];
    sTableView.cTableView.delegate = self;
    sTableView.cTableView.dataSource = self;
    sTableView.delegate = self;
    sTableView.backgroundColor = [UIColor clearColor];
    sTableView.stackDisplayX = IndSubViewDisplay_X;
    sTableView.stackDefaultX = IndSubViewDefault_X;
    sTableView.stackMoveGap = 30.0f;
    
    [self addSubview:sTableView];
    [sTableView setttingThemeColor:kColorWithRGB(232.0f, 231.0f, 231.0f)];
    
    TranbTouchView *dTableView = [[TranbTouchView alloc] initWithFrame:IndDetailViewDefault_Frame observingScrollView:sTableView.cTableView showIndicator:YES];
    dTableView.cTableView.delegate = self;
    dTableView.cTableView.dataSource = self;
    dTableView.delegate = self;
    dTableView.stackDisplayX = IndDetailViewDisplay_X;
    dTableView.stackDefaultX = IndDetailViewDefault_X;
    dTableView.stackMoveGap = 10.0f;
    
    dTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:dTableView];
    [dTableView setttingThemeColor:kColorWithRGB(220.f, 219.0f, 219.0f)];
    
    // 注册可重用视图
    [rTableView.cTableView registerClass:[PrimaryProductIndustryTableViewCell class] forCellReuseIdentifier:@"PrimaryProductIndustryParentCell"];
    
    // 注册可重用视图
    [sTableView.cTableView registerClass:[SecondaryProductIndustryTableViewCell class] forCellReuseIdentifier:@"SecondaryProductIndustryParentCell"];
    
    // 注册可重用视图
    [dTableView.cTableView registerClass:[TertiaryProductIndustryTableViewCell class] forCellReuseIdentifier:@"TertiaryProductIndustryParentCell"];
    
    
    [self.productIndustryViews addObject:rTableView];
    [self.productIndustryViews addObject:sTableView];
    [self.productIndustryViews addObject:dTableView];
}


//刷新数据,并更新页面
-(void)refreshData:(NSArray *)array selectedCode:(NSString *)code
{
    self.productIndustryData = [NSMutableArray arrayWithArray:array];
    
    if ([self.productIndustryData count] > 0) {
         TranbTouchView *vi = [self.productIndustryViews firstObject];
         vi.tableData = [self.productIndustryData copy];
        [vi.cTableView reloadData];

        //给每个页面进行赋值操作
        for (int index = 0; index < [self.productIndustryViews count]; index++) {
            
            TranbTouchView *tView = [self.productIndustryViews objectAtIndex:index];
            
            for (NSObject *obj in tView.tableData) {
                BOOL selected = [[obj valueForKey:@"industrySelected"] boolValue];
                if (selected) {
                    tView.selectedData = obj;
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tView.tableData indexOfObject:obj]
                                                                inSection:0];
                    
                    [tView.cTableView selectRowAtIndexPath:indexPath
                                                  animated:NO
                                            scrollPosition:UITableViewScrollPositionMiddle];
                    
                    //页面控制
                    NSArray *subNodes = [obj valueForKey:@"subNodes"];
                    
                    if ([subNodes count] > 0 && (index + 1) < [self.productIndustryViews count]) {
                        
                        //next View
                        [self showTouchView:(index + 1) datas:subNodes animation:NO];
                        
                    }
                }
            }
        }
    }
}

#pragma mark - UITableView data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TranbTouchView *tranbView = (TranbTouchView *)tableView.superview;
    return [tranbView.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    
    TranbTouchView *tranbView = (TranbTouchView *)tableView.superview;
    NSUInteger index = [self.productIndustryViews indexOfObject:tranbView];
    
    NSObject *obj = [tranbView.tableData objectAtIndex:row];
    
    if (index == 0) {
        PrimaryProductIndustryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"PrimaryProductIndustryParentCell"];
        
        [cell refreshData:obj];
        
        return cell;
        
    } else if (index == 1)
    {
        SecondaryProductIndustryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SecondaryProductIndustryParentCell"];
        
        
        [cell refreshData:obj updateLabelWithSelectedData:tranbView.selectedData];
        
        return cell;
    }
    
    TertiaryProductIndustryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"TertiaryProductIndustryParentCell"];
    
    [cell refreshData:obj updateLabelWithSelectedData:tranbView.selectedData];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TranbTouchView *tranbView = (TranbTouchView *)tableView.superview;
    NSUInteger index = [self.productIndustryViews indexOfObject:tranbView];
    
    if (index == 0) {
        return 72.f;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TranbTouchView *touchView = (TranbTouchView *)tableView.superview;
    
    NSInteger row = [indexPath row];
    NSObject *selectedData = [touchView.tableData objectAtIndex:row];
    touchView.selectedData = selectedData;
    //重新刷新页面，并选中
    [touchView.cTableView reloadData];
    [touchView.cTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //页面控制
    NSArray *subNodes = [selectedData valueForKey:@"subNodes"];
    
    NSUInteger index = [self.productIndustryViews indexOfObject:touchView];
    
    if ([subNodes count] > 0) {
        
        if (index+1 < [self.productIndustryViews count])
        {
            [self showTouchView:(index + 1) datas:subNodes animation:YES];
        }
        
        [self hiddenTouchViews:(index + 2)];

    } else {
       [self hiddenTouchViews:(index + 1)];
        //无子节点类。需要回传选中
        
        if ([self.delegate respondsToSelector:@selector(tranbStackedViewDidSelectedObjcet:)])
        {
            [self.delegate tranbStackedViewDidSelectedObjcet:selectedData];
        }
    }
}

#pragma mark - 页面显示或者隐藏控制
- (void)showTouchView:(NSInteger)index datas:(NSArray *)data animation:(BOOL)animation
{
    TranbTouchView *nextView = [self.productIndustryViews objectAtIndex:index];
    
    [nextView toShowWithAnimation:animation];
    [nextView movingIndicatorToSelectedIndexPath];
    
    //重置数据
    nextView.tableData = [NSMutableArray arrayWithArray:data];
    nextView.selectedData = nil;
    [nextView.cTableView reloadData];
}


-(void)hiddenTouchViews:(NSInteger) index
{
    for (NSInteger i = index; i< [self.productIndustryViews count]; i++) {
        TranbTouchView *vi = [self.productIndustryViews objectAtIndex:i];
        [vi toHiddenWithAnimation:YES];
    }
}

#pragma mark - TranbTouchView delegate
- (void)stackedTouchViewDidShow:(TranbTouchView *)stackedView
{
    NSUInteger index = [self.productIndustryViews indexOfObject:stackedView];
    if (index == 1) {
        TranbTouchView *touchView = [self.productIndustryViews objectAtIndex:0];
        touchView.cTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)stackedTouchViewDidHidden:(TranbTouchView *)stackedView
{
    NSUInteger index = [self.productIndustryViews indexOfObject:stackedView];
    if (index == 1) {
        TranbTouchView *touchView = [self.productIndustryViews objectAtIndex:0];
        touchView.cTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    stackedView.tableData = nil;
    stackedView.selectedData = nil;
    [stackedView.cTableView reloadData];
}

//拖动中页面移动
-(void)stackedTouchView:(TranbTouchView *)touchView moveOffset:(NSInteger)offset
{
    NSUInteger index = [self.productIndustryViews indexOfObject:touchView];
    for (NSUInteger i = (index + 1); i< [self.productIndustryViews count]; i++) {
        TranbTouchView *vi = [self.productIndustryViews objectAtIndex:i];
        [vi moveStackWithOffset:offset];
    }
    
}

//拖动完成页面移动
-(void)stackedTouchViewDidGestureEnded:(TranbTouchView *)touchView duration:(CGFloat)duration offset:(CGFloat)offset
{
    NSUInteger index = [self.productIndustryViews indexOfObject:touchView];
    for (NSUInteger i = (index + 1); i< [self.productIndustryViews count]; i++) {
        TranbTouchView *vi = [self.productIndustryViews objectAtIndex:i];
        [vi alignStackAnimated:YES duration:duration offset:offset];
    }
}

-(void)dealloc
{
    NSString *prt = [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])];
    NSLog(@"%@", prt);
}

@end

