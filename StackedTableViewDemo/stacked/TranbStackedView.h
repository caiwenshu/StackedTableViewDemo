//
//  TranbStackedView.h
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TranbStackedViewDelegate <NSObject>

- (void)tranbStackedViewDidSelectedObjcet:(NSObject *)obj;

@end

@interface TranbStackedView : UIView

@property(nonatomic, assign)id<TranbStackedViewDelegate> delegate;

-(void)refreshData:(NSArray *)array selectedCode:(NSString *)code;

@end
