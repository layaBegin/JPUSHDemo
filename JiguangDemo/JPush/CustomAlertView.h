//
//  CustomAlertView.h
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlertView : UIView
+ (void)alertWithTitle:(NSString *)title content:(NSString *)content icon:(nullable UIImage*)icon completionBlock:(void(^)(void))callback;
@end

NS_ASSUME_NONNULL_END
