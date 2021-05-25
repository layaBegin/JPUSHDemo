//
//  JPushPopView.h
//  JiguangDemo
//
//  Created by xudong.rao on 2020/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ActionType) {
    ADD = 1,
    DELETE = 2
};

typedef void (^JPushPopViewBlock)(NSInteger type,NSString *content, BOOL isSuccess);

@interface JPushPopView : UIView

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) NSString *tipMessage;
@property(nonatomic, assign) NSInteger maxCount;
/// 1：设置标签，2：设置别名 3：设置手机号
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) JPushPopViewBlock popViewBlock;
- (void)show;

///可手动调用
- (void)dismiss;

- (void)reminderAction:(NSString *)tip;

@end

NS_ASSUME_NONNULL_END
