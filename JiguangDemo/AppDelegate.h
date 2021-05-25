//
//  AppDelegate.h
//  TargetProject
//
//  Created by ys on 2020/8/20.
//

#define DEMO_VERSION 2.0.0

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// 是否允许旋转
@property (assign, nonatomic) BOOL allow;

@end

