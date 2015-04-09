//
//  TranbTouchView.h
//  TableDemo
//
//  Created by caiwenshu on 4/3/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

//容器类
#import <UIKit/UIKit.h>

@protocol TranbTouchViewDelegate;

@interface TranbTouchView : UIView

@property(nonatomic, strong) UITableView *cTableView;

//初始化
- (id)initWithFrame:(CGRect)frame observingScrollView:(UITableView *)observingScrollView showIndicator:(BOOL)showIndicator;

//页面样式的设定(箭头和背景颜色的设定)
-(void)setttingThemeColor:(UIColor *)col;

//移动当前页面的箭头方法
-(void)movingIndicatorToSelectedIndexPath;

//-----------------------手势动画---------------------------------------------
//移动当前页面的位置(无动画)--用于拖动的页面移动
- (void)moveStackWithOffset:(NSInteger)offset;

//移动当前页面到指定位置(有动画)--用于拖动完成后的页面组动画
- (void)alignStackAnimated:(BOOL)animated duration:(CGFloat)duration offset:(CGFloat)offset;

//-----------------------隐藏/显示页面动画---------------------------------------------
-(void)toShowWithAnimation:(BOOL)animated;

-(void)toHiddenWithAnimation:(BOOL)animated;

//-----------------------手势动画---------------------------------------------
//数据集的展示
@property(nonatomic, strong) NSMutableArray *tableData;

//选中数据的保存
@property(nonatomic, strong) NSObject *selectedData;

//-----------------------页面两种状态临界值---------------------------------------------
//1.显示状态时的坐标
//2.隐藏时的坐标
//3.移动间隙
@property(nonatomic, assign) CGFloat stackDisplayX;
@property(nonatomic, assign) CGFloat stackDefaultX;
@property(nonatomic, assign) CGFloat stackMoveGap;

//页面是否支持手势操作
@property(nonatomic, assign) BOOL enabledPan;

/// event delegate
@property(nonatomic, assign) id<TranbTouchViewDelegate> delegate;

@end


@protocol TranbTouchViewDelegate <NSObject>

@optional

- (void)stackedTouchViewDidShow:(TranbTouchView *)stackedView;

- (void)stackedTouchViewDidHidden:(TranbTouchView *)stackedView;

-(void)stackedTouchView:(TranbTouchView *)stackedView moveOffset:(NSInteger)offset;

-(void)stackedTouchViewDidGestureEnded:(TranbTouchView *)stackedView duration:(CGFloat)duration offset:(CGFloat)offset;

@end
