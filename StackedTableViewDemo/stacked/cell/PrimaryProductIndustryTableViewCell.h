//
//  PrimaryProductIndustryTableViewCell.h
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stackedDefine.h"
#import "UIImageView+LocalPicture.h"

@interface PrimaryProductIndustryTableViewCell : UITableViewCell

@property(nonatomic, strong) NSObject *dataObject;

@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;

-(void)refreshData:(NSObject *)obj;


@end
