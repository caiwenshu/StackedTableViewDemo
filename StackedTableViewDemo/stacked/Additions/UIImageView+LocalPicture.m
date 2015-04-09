//
//  UIImageView+LocalPicture.m
//  tranb
//
//  Created by caiwenshu on 4/8/15.
//  Copyright (c) 2015 cmf. All rights reserved.
//

#import "UIImageView+LocalPicture.h"
#import "SDWebImageManager.h"

@implementation UIImageView (LocalPicture)

- (void)sdl_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(SDWebImageOptions)options
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock
{
    
    BOOL isRemotePath = YES;
    NSString *strUrl  = (NSString *)url;
    //判断是否是本地地址
    if ([url isKindOfClass:NSString.class]) {
        isRemotePath = [self isStartWithHttp:strUrl];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (isRemotePath) {
        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                         options:options
                        progress:progressBlock
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                           if (completedBlock) {
                               completedBlock(image, error, cacheType, imageUrl);
                           }
                       }
         ];
    } else {
        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image) {
                
                dispatch_main_sync_safe(^{
                    if (completedBlock) {
                        completedBlock(image, nil, SDImageCacheTypeNone, url);
                    }
                });
                
                weakSelf.image = image;
                
            } else {
                
                image = [UIImage imageNamed:strUrl];
                
                if (image) {
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                    
                    dispatch_main_sync_safe(^{
                        if (completedBlock) {
                            completedBlock(image, nil, SDImageCacheTypeNone, url);
                        }
                    });
                }
                
                
                weakSelf.image = image;
            }
        }];
    }
}


-(BOOL)isStartWithHttp:(NSString *)url
{
    //只对存在
    if (url == nil || url.length < 1) {
        return YES;
    }
    if ([url hasPrefix:@"http://"]
        || [url hasPrefix:@"https://"]) {
        return YES;
    }
    
    return NO;
}

@end
