//
//  UIImage+imageWithColor.h
//  tranb
//
//  Created by 耿功发 on 14/11/25.
//  Copyright (c) 2014年 cmf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageWithColor)

+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize) size;

@end
