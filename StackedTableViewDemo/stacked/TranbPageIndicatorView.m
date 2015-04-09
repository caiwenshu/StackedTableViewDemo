//
//  TranbPageIndicatorView.m
//  tranb
//
//  Created by caiwenshu on 4/8/15.
//  Copyright (c) 2015 cmf. All rights reserved.
//

#import "TranbPageIndicatorView.h"

@implementation TranbPageIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        _color = [UIColor greenColor];
    }
    return self;
}

#pragma mark - Public

- (void)setColor:(UIColor *)color
{
    if (![_color isEqual:color]) {
        _color = color;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextBeginPath(context);
    //    CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    //    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    //    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
}

-(void)dealloc
{
    NSString *prt = [NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])];
    NSLog(@"%@", prt);
}


@end
