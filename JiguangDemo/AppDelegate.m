//
//  AppDelegate.m
//  TargetProject
//
//  Created by ys on 2020/8/20.
//

#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "JPush.h"
#import "JPUSHService.h"

#define APPKEY @"abb88ddba9ae89a3b0cb98b4"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self jpushInit:launchOptions];
    return YES;
}
- (void)jpushInit:(NSDictionary *)launchOptions {
    //【注册通知】通知回调代理（可选）
    [JPUSHService registerForRemoteNotificationConfig:[self pushRegisterEntity] delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //【初始化sdk】
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY
                          channel:@"test"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    //温馨提示：快速集成JPush只需要【注册通知】【初始化sdk】两步即可
    
    //获取registrationId/检测通知授权情况/地理围栏/voip注册/监听连接状态等其他功能
    [[JPush shared] initOthers:APPKEY launchOptions:launchOptions];
}

- (JPUSHRegisterEntity *)pushRegisterEntity {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //      NSSet<UNNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
    //    else {
    //      NSSet<UIUserNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
      }
    return entity;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //sdk注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    //在UI上展示
    [[JPush shared] deviceToken: deviceToken];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
//设置消息送达代理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
    [[JPush shared] willPresentNotification:notification];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
  
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler();  // 系统要求执行这个方法
    
    [[JPush shared] didReceiveNotificationResponse:response];
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
  NSLog(@"receive notification authorization status:%lu, info:%@", status, info);
  [[JPush shared] alertNotificationAuthorization:status];
}

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    NSLog(@"%@", title);
}
#endif

//【iOS7以上系统，收到通知以及静默推送】
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

//兼容【iOS6及以下系统，收到通知】
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//  [JPUSHService handleRemoteNotification:userInfo];
//}


@end
