//
//  Toast.m
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/5.
//

#import "Toast.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation Toast
+ (void)showTostWithImage:(UIImage *)image title:(NSString *)title superView:(UIView *)superView{
    [self showTostWithImage:image title:title superView:superView afterDelay:1.5];
}
+ (void)showTostWithImage:(UIImage *)image title:(NSString *)title superView:(UIView *)superView afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
    hud.userInteractionEnabled = NO;
    hud.minSize = CGSizeMake(Scale(125), Scale(125));
    hud.detailsLabel.text = title;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14.0];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 2.0;
    hud.margin = Scale(0.0);
    // 设置图片
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:true afterDelay:delay];
}

+ (void)showMessage:(NSString *)message superView:(UIView *)superView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];

    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);

    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
