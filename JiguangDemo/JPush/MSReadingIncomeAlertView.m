//
//  MSReadingIncomeAlertView.m
//  MobiledataShare
//
//  Created by Cai on 2019/1/24.
//  Copyright © 2019 JiuXi Technology. All rights reserved.
//

#import "MSReadingIncomeAlertView.h"
#import <Masonry/Masonry.h>

typedef void(^callback)(void);
@interface MSReadingIncomeAlertView()
{
    CGFloat contentViewWidth;
    CGFloat contentViewHeight;
}
@property (copy) callback presscallback;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *iconImageView;
@property(strong, nonatomic) UILabel *contentlabel;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property(strong,nonatomic)NSString *content;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;
@end

@implementation MSReadingIncomeAlertView
+ (instancetype)alertReadingIncomeWithADF:(NSString*)adf convert:(NSString*)rb maxRMB:(NSString *)maxRMB completionBlock:(void(^)(void))callback{
    MSReadingIncomeAlertView *view = [[MSReadingIncomeAlertView alloc] initWithFrame:CGRectZero title:@"自定义消息" content:@"这是一条自定义消息7812928。 用户对此无感知，为演示做此效果。" icon:nil];
    view.presscallback = callback;
    [view show];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content icon:(UIImage*)icon;
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _content = content;
        _icon = icon;
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        
        [self initShowView];
    }
    return self;
}

- (void)initShowView {
    if (!_contentView) {
        contentViewWidth = Scale(304);
        contentViewHeight = Scale(190);
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
        _contentView.center = self.center;
    }
    [self addSubview:_contentView];
    [self initTitleAndIcon];
}

- (void)initTitleAndIcon {
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = _title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:18.0];
            label.textColor = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(Scale(26.3)));
                make.left.right.equalTo(@0);
                make.height.mas_equalTo(Scale(44.0));
            }];
            label;
        });
    }
    
    if (_icon != nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = _icon;
        [_contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_contentView);
            make.top.equalTo(_titleLabel.mas_bottom).offset(Scale(12));
            make.width.height.equalTo(@(Scale(140)));
        }];
    }
    
    self.contentlabel = ({
        UILabel *label = [UILabel new];label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = self.content;
        label.numberOfLines = 0;
        label.textColor = [UIColor colorWithRed:72/255.0 green:81/255.0 blue:98/255.0 alpha:1.0];
        label;
    });
    [_contentView addSubview:self.contentlabel];
    
    [self.contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.0);
        make.left.equalTo(@(38.0));
        make.right.equalTo(@(-38.0));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:132/255.0 blue:246/255.0 alpha:1.0];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = Scale(42) / 2;
    confirmBtn.layer.masksToBounds = true;
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentlabel.mas_bottom).offset(18.0);
        make.size.mas_equalTo(CGSizeMake(258, 42));
    }];
}

- (void)confirmAction{
    if (_presscallback) {
        self.presscallback();
    }
    [self hide];
}

- (void)hide {
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [window addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

- (void)showBackground {
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    self.alpha = 0.0;
    [UIView commitAnimations];
}
@end
