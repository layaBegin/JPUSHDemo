//
//  JPushHomeViewController.m
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/3.
//

#import "JPushHomeViewController.h"
#import "UIButton+JXPostion.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Toast.h"
#import "MSReadingIncomeAlertView.h"
#import "CustomAlertView.h"
#import "JPUSHService.h"
#import "JPushTagAliasViewController.h"
#import "JPush.h"

@interface JPushHomeViewController ()<UIAlertViewDelegate>

@end

@implementation JPushHomeViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.translucent = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent= false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jpush_back"]];
    backImageView.frame = CGRectMake(0, 0, Scale(375), Scale(320));
    [self.view addSubview:backImageView];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIView * whiteRoundView = [[UIView alloc] initWithFrame:CGRectMake(0, Scale(234), DeviceSize.width, self.view.frame.size.height - Scale(234))];
    whiteRoundView.backgroundColor = UIColor.whiteColor;
    whiteRoundView.layer.cornerRadius = Scale(6);
    whiteRoundView.layer.masksToBounds = true;
    [self.view addSubview:whiteRoundView];
    

    UILabel *regidLabel = [[UILabel alloc] init];
//    regidLabel.frame = CGRectMake(Scale(16.1),Scale(268),Scale(100),Scale(20));
    regidLabel.font = [UIFont systemFontOfSize:14.0];
    regidLabel.numberOfLines = 0;
    regidLabel.text = @"Registration ID";
    [self.view addSubview:regidLabel];
    [regidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Scale(100));
        make.height.mas_equalTo(Scale(20));
        make.left.equalTo(self.view).offset(Scale(16.1));
        make.top.equalTo(self.view).offset(Scale(268));
    }];

    UILabel *regidContentLabel = [[UILabel alloc] init];
//    regidContentLabel.frame = CGRectMake(Scale(155),Scale(269.5),Scale(169),Scale(17));
    regidContentLabel.numberOfLines = 0;
    regidContentLabel.textColor = [UIColor colorWithRed:141/255.0 green:147/255.0 blue:157/255.0 alpha:1.0];
    regidContentLabel.font = [UIFont systemFontOfSize:12.0];
    regidContentLabel.textAlignment = NSTextAlignmentRight;
    regidContentLabel.text = [JPush shared].registrationID?:@"";
    [self.view addSubview:regidContentLabel];
    
//    UIButton *copyBtn = [[UIButton alloc] init];
//    [copyBtn setImage:[UIImage imageNamed:@"Copy"] forState:UIControlStateNormal];
//    [copyBtn addTarget:self action:@selector(copyRegID) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:copyBtn];
    
    [regidContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(regidLabel.mas_height);
        make.centerY.equalTo(regidLabel.mas_centerY);
        make.left.equalTo(regidLabel.mas_right).offset(Scale(10));
        //make.right.equalTo(copyBtn.mas_left).offset(Scale(-10));
        make.right.equalTo(self.view.mas_right).offset(Scale(-16));
    }];
//    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.and.height.mas_equalTo(Scale(20.0));
//        make.centerY.equalTo(regidLabel.mas_centerY);
//        make.right.equalTo(self.view.mas_right).offset(Scale(-16));
//    }];
    
    UIView *line = [[UIView alloc] init];
//    line.frame = CGRectMake(Scale(16.1),Scale(302),Scale(342.9),Scale(1));
    line.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:247/255.0 alpha:1.0].CGColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(Scale(1));
        make.left.equalTo(self.view.mas_left).offset(Scale(16));
        make.right.equalTo(self.view.mas_right).offset(Scale(-16));
        make.top.equalTo(regidLabel.mas_bottom).offset(Scale(16));
    }];
    
    UILabel *statuslabel = [[UILabel alloc] init];
//    statuslabel.frame = CGRectMake(Scale(16.1),Scale(323),Scale(46),Scale(20));
    statuslabel.numberOfLines = 0;
    statuslabel.font = [UIFont systemFontOfSize:14.0];
    statuslabel.text = @"ID 状态";
    statuslabel.textColor = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
    [self.view addSubview:statuslabel];
    [statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Scale(100));
        make.height.mas_equalTo(Scale(20));
        make.left.equalTo(regidLabel.mas_left);
        make.top.equalTo(line.mas_bottom).offset(Scale(20));
    }];
    
//    UISwitch *switchView = [[UISwitch alloc] init];
//    switchView.frame = CGRectMake(Scale(263),Scale(317),Scale(62),Scale(32));
//    [self.view addSubview:switchView];
//    switchView.hidden = YES;
    
    UILabel *switchLabel = [[UILabel alloc] init];
//    switchLabel.frame = CGRectMake(Scale(335),Scale(324.5),Scale(26),Scale(20));
    switchLabel.numberOfLines = 0;
    switchLabel.text = @"在线";
    switchLabel.textAlignment = NSTextAlignmentRight;
    switchLabel.font = [UIFont systemFontOfSize:12.0];
    switchLabel.textColor = [UIColor colorWithRed:141/255.0 green:147/255.0 blue:157/255.0 alpha:1.0];
    [self.view addSubview:switchLabel];
    [switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(statuslabel.mas_height);
        make.centerY.equalTo(statuslabel.mas_centerY);
        //make.right.equalTo(copyBtn.mas_right);
        make.right.equalTo(regidContentLabel.mas_right);
    }];
    
    
    UIView *intervalView = [[UIView alloc] init];
    intervalView.frame = CGRectMake(0,Scale(363),Scale(375),Scale(10));
    intervalView.layer.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:247/255.0 alpha:1.0].CGColor;
    [self.view addSubview:intervalView];
    
    UIButton *notiBtn = [[UIButton alloc] init];
    [notiBtn setBackgroundImage:[UIImage imageNamed:@"btn_42px"] forState:UIControlStateNormal];
    notiBtn.frame = CGRectMake(Scale(47.5),Scale(414),Scale(280),Scale(42));
    [notiBtn setTitle:@"本地化通知测试" forState:UIControlStateNormal];
    notiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    notiBtn.layer.cornerRadius = Scale(42) / 2;
    notiBtn.layer.masksToBounds = true;
    [notiBtn addTarget:self action:@selector(addNotificationWithTimeintervalTrigger) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notiBtn];
    
    UIButton *customBtn = [[UIButton alloc] init];
    customBtn.backgroundColor = [UIColor whiteColor];
    [customBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:132/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
    customBtn.frame = CGRectMake(Scale(47.5),Scale(476),Scale(280),Scale(42));
    [customBtn setTitle:@"高级功能" forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    customBtn.layer.cornerRadius = Scale(42) / 2;
    customBtn.layer.masksToBounds = true;
    customBtn.layer.borderWidth = 1.0;
    customBtn.layer.borderColor = [UIColor colorWithRed:0/255.0 green:132/255.0 blue:246/255.0 alpha:1.0].CGColor;
    [customBtn setImage:[[UIImage imageNamed:@"arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [customBtn setImagePosition:LXMImagePositionRight spacing:1.0];
    customBtn.imageView.tintColor = [UIColor colorWithRed:0/255.0 green:132/255.0 blue:246/255.0 alpha:1.0];
    [customBtn addTarget:self action:@selector(openTagAlaisVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customBtn];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feet_logo"]];
    logoImageView.frame = CGRectMake(Scale(136), self.view.frame.size.height - Scale(32), Scale(104), Scale(16));
    [self.view addSubview:logoImageView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)copyRegID{
    [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"内容已复制" superView:self.view];
}

- (void)addNotificationWithTimeintervalTrigger {
    [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
      NSLog(@"notification authorization status:%lu", status);
        if (status < JPAuthorizationStatusAuthorized) {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先开启推送权限" message:@"是否进入手机设置开启通知权限？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
          [alertView show];
        }else{
            [self sendNotificationRequest];
        }
    }];
}
- (void)sendNotificationRequest{
    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
      //n s之后触发
      trigger.timeInterval = 1;
      trigger.repeat = NO;
    }else {
        NSLog(@"timeInterval 触发通知只在 iOS10 以上有效哦……");
        [Toast showTostWithImage:[UIImage imageNamed:@"Toast_1"] title:@"触发通知只在 iOS10 以上有效" superView:self.view];
      return;
    }
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    request.content = [self generateNotificationCotent];
    request.trigger = trigger;
    request.completionHandler = ^(id result) {
      if (result) {
          NSLog(@"添加 timeInterval 通知成功 --- %@", result);
      }else {
      }
    };
    request.requestIdentifier = @"123";
    [JPUSHService addNotification:request];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    if(@available(iOS 8.0, *)) {
      [JPUSHService openSettingsForNotification:^(BOOL success) {
        NSLog(@"open settings %@", success?@"success":@"failed");
      }];
    }
  }
}
- (JPushNotificationContent *)generateNotificationCotent {
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    content.title = @"极光Demo";
    content.subtitle = @"这是一条测试消息";
    content.body = @"这是一条测试消息";
    content.userInfo = @{@"jumpUrl":@"https://jiguang.cn"};
    content.badge = @(1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
      JPushNotificationSound *soundSetting = [[JPushNotificationSound alloc] init];
      //如果是告警通知
      if (@available(iOS 12.0, *)) {
        soundSetting.criticalSoundVolume = 0.9;
      }
      content.soundSetting = soundSetting;
    }else {
    }
    return content;
}

- (void)openTagAlaisVc{
    JPushTagAliasViewController *tagAliasVc = [[JPushTagAliasViewController alloc] init];
    [self.navigationController pushViewController:tagAliasVc animated:true];
}



@end
