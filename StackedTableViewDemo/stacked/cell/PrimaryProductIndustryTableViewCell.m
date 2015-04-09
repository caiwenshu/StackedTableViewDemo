//
//  PrimaryProductIndustryTableViewCell.m
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import "PrimaryProductIndustryTableViewCell.h"
#import "UIView+Size.h"
#import "UIImage+imageWithColor.h"

@interface PrimaryProductIndustryTableViewCell()

@property(nonatomic, strong) UILabel *cLabel;

@end

@implementation PrimaryProductIndustryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.iconImageView.backgroundColor = [UIColor clearColor];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailLabel.textColor = [UIColor grayColor];
        self.detailLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.detailLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //todo:
    
    float viewGap = 15.0f;
    
     float imgY =  (self.height - 26.0f) / 2.0f;
    
    self.iconImageView.frame = CGRectMake(viewGap, imgY, 26.0f, 26.0f);
    
    [self.titleLabel sizeToFit];
//    [self.detailLabel sizeToFit];
    
    CGSize size = [self.detailLabel sizeThatFits:CGSizeMake( self.width - (self.iconImageView.right + viewGap * 2), 0)];
    
//    NSLog(@"%@--width:%f-----height:%f",self.detailLabel.text,size.width, size.height);
    
    //字体大小决定了开始坐标
    float viewStartY = self.iconImageView.centerY - self.titleLabel.height;//居中显示
    
    if (self.detailTextLabel.hidden) {
        //居中显示，数据来源系统控件 textLabel的值
        self.titleLabel.centerY = self.iconImageView.centerY;
        viewStartY = self.titleLabel.y;
    }
    
    self.titleLabel.frame  = CGRectMake(self.iconImageView.right + viewGap, viewStartY, self.width - (self.iconImageView.right + viewGap * 2), self.titleLabel.height);
    
    self.detailLabel.frame = CGRectMake(self.titleLabel.x,
                                        self.titleLabel.bottom,
                                        self.width - (self.iconImageView.right + viewGap * 2),
                                        size.height > viewGap * 2 ? viewGap * 2 : size.height);
    
    
}

-(void)refreshData:(NSObject *)obj
{
    
    self.dataObject = obj;
    
    self.titleLabel.text =[self.dataObject valueForKey:@"name"];
    NSArray *subNodeNames = [[self.dataObject valueForKey:@"subNodes"] valueForKeyPath: @"name"];
    
    if ([subNodeNames count] > 0) {
        self.detailTextLabel.hidden = NO;
    } else {
        self.detailTextLabel.hidden = YES;
    }
    
    self.detailLabel.text = [subNodeNames componentsJoinedByString:@","];
    
    [self.iconImageView sdl_setImageWithURL:[obj valueForKey:@"icon"]
                           placeholderImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(26.0f, 26.0f)]
                                    options:0
                                   progress:nil
                                  completed:nil];
    
//    [self setNeedsLayout];
    
}

-(void)dealloc
{
    NSString *prt = [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])];
    NSLog(@"%@", prt);
}

@end
