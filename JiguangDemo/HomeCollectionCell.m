//
//  HomeCollectionCell.m
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/3.
//

#import "HomeCollectionCell.h"
#import <Masonry/Masonry.h>

@interface HomeCollectionCell ()

@end

@implementation HomeCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
        
    }
    return self;
}

- (void)setView{
    //图片
    _icon = [[UIImageView alloc]init];
    _icon.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_icon];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(23.0);
    }];
    
    //文字
    self.label = [[UILabel alloc] init];
    self.label.text = @"测试";
    self.label.font = [UIFont systemFontOfSize:14.0];
    self.label.textColor = UIColor.blackColor;
    [self.contentView addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-18.0);
    }];
    
    self.contentView.layer.cornerRadius = 4.0;
    self.contentView.layer.masksToBounds = true;
    self.contentView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:247/255.0 alpha:1.0].CGColor;;
    self.contentView.layer.borderWidth = 1.0;
}

@end
