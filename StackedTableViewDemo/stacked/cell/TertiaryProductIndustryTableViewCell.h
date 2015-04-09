//
//  TertiaryProductIndustryTableViewCell.h
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stackedDefine.h"

@interface TertiaryProductIndustryTableViewCell : UITableViewCell

@property(nonatomic, strong) NSObject *dataObject;

-(void)refreshData:(NSObject *)obj updateLabelWithSelectedData:(NSObject *)selectedData;

@end
