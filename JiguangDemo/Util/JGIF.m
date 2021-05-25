//
//  JGIF.m
//  TargetProject
//
//  Created by ys on 2021/3/4.
//

#import "JGIF.h"
#import <SDWebImage.h>

@implementation JGIF

+(void)setGif:(UIImageView *)imageView url:(NSURL*)url {
    [imageView sd_setImageWithURL:url];
}

@end
