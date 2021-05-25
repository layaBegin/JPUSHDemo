//
//  CustomAlertView.m
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/5.
//

#import "CustomAlertView.h"
#import <Masonry/Masonry.h>

typedef void(^callback)(void);

@interface CustomAlertView ()
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

@implementation CustomAlertView

+ (void)alertWithTitle:(NSString *)title content:(NSString *)content icon:(UIImage*)icon completionBlock:(void(^)(void))callback{
    CustomAlertView *view = [[CustomAlertView alloc] initWithFrame:CGRectZero title:title content:content icon:icon];
    view.presscallback = callback;
    [view show];
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
        contentViewWidth = Scale(317);
        contentViewHeight = Scale(198);
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 6.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.center = self.center;
    }
    [self addSubview:_contentView];
    [self initTitleAndIcon];
}

- (void)initTitleAndIcon {
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(Scale(30.0));
        make.right.mas_equalTo(Scale(-30.0));
        make.height.mas_greaterThanOrEqualTo(contentViewHeight);
    }];
    
    if (_title != nil && ![_title isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:19.0];
        label.textColor = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(Scale(26.3)));
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(Scale(26.0));
        }];
        
        _titleLabel = label;
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
    
    self.contentlabel = [UILabel new];
    self.contentlabel.textAlignment = NSTextAlignmentCenter;
    self.contentlabel.font = [UIFont systemFontOfSize:15.0];
    self.contentlabel.text = self.content;
    self.contentlabel.numberOfLines = 0;
    self.contentlabel.textColor = [UIColor colorWithRed:72/255.0 green:81/255.0 blue:98/255.0 alpha:1.0];
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
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmBtn.mas_bottom).offset(Scale(27));
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
