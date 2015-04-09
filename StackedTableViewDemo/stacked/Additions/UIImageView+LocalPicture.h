//
//  UIImageView+LocalPicture.h
//  tranb
//
//  Created by caiwenshu on 4/8/15.
//  Copyright (c) 2015 cmf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface UIImageView (LocalPicture)

- (void)sdl_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock;

@end
