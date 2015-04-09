//
//  TertiaryProductIndustryTableViewCell.m
//  TableDemo
//
//  Created by caiwenshu on 4/5/15.
//  Copyright (c) 2015 caiwenshu. All rights reserved.
//

#import "TertiaryProductIndustryTableViewCell.h"

#define ProdIndus_Teriary_Text_Color           kColorWithRGB(88.0f, 87.0f, 87.0f);
#define ProdIndus_Teriary_Text_Selected_Color  kColorWithRGB(47.0f, 111.0f, 217.0f)

@implementation TertiaryProductIndustryTableViewCell

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
        
        // Initialization code
//        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.textLabel.textColor = ProdIndus_Teriary_Text_Color;
        self.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //todo:
}

-(void)refreshData:(NSObject *)obj updateLabelWithSelectedData:(NSObject *)selectedData
{
    
    self.dataObject = obj;
    
    self.textLabel.text = [obj valueForKey:@"name"];
    
    NSString *iUCode = [selectedData valueForKey:@"IUCode"];
    
    BOOL selected = NO;
    if ([[obj valueForKey:@"IUCode"] isEqualToString:iUCode]
        && [[selectedData valueForKey:@"subNodes"] count] < 1)
    {
        selected = YES;
    }
    
    [self updateLabelWithSelected:selected];
}

-(void)updateLabelWithSelected:(BOOL)selected
{
    if (selected) {
        self.textLabel.textColor = ProdIndus_Teriary_Text_Selected_Color;
    } else {
        self.textLabel.textColor = ProdIndus_Teriary_Text_Color;
    }
}

-(void)dealloc
{
    NSString *prt = [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])];
    NSLog(@"%@", prt);
}

@end
