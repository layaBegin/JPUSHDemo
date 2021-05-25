//
//  Toast.h
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/5.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSObject
+ (void)showTostWithImage:(UIImage *)image title:(NSString *)title superView:(UIView *)superView;
+ (void)showTostWithImage:(UIImage *)image title:(NSString *)title superView:(UIView *)superView afterDelay:(NSTimeInterval)delay;
+ (void)showMessage:(NSString *)message superView:(UIView *)superView;
@end

NS_ASSUME_NONNULL_END
