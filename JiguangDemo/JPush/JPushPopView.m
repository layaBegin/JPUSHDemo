//
//  JPushPopView.m
//  JiguangDemo
//
//  Created by xudong.rao on 2020/11/10.
//

#import "JPushPopView.h"
#import "JPUSHService.h"
#import "Toast.h"
#import "SDBaseTextView.h"
#import "SDTextLimitTool.h"

@interface JPushPopView ()<UITextViewDelegate>
{
    NSString *lastContentString;
    float offsetY;
}
@property (strong, nonatomic) UIView *popView;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) SDBaseTextView *textView;
@property (strong, nonatomic) UILabel *tipLabel;


@end

static NSInteger seq = 0;

@implementation JPushPopView
- (NSInteger)seq {
  return ++ seq;
}
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder tip:(NSString *)tip maxCount:(NSInteger)maxCount{
    self = [super init];
    if (self) {
        self.title = title;
        self.placeholder = placeholder;
        self.tipMessage = tip;
        self.maxCount = maxCount;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextViewTextDidChangeNotification" object:self.textView];
        //键盘通知
        
        self.type = 1;
        self.maxCount = 40;
        self.title = @"新建标签";
        self.placeholder = @"";
        self.tipMessage = [NSString stringWithFormat:@"标签为大小写字母、数字、下划线、中文，单个标签字符长度不超过%ld",self.maxCount];
        
        _popView = [[UIView alloc] init];
        _popView.backgroundColor = RGB(245, 245, 245);
        _popView.layer.cornerRadius = 6;
        _popView.layer.masksToBounds = YES;
        [self addSubview:_popView];
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(Scale(304));
            make.height.mas_offset(Scale(232));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.font = [UIFont systemFontOfSize:19];
        self.titleLable.text = self.title;
        [_popView addSubview:self.titleLable];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(Scale(25));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_popView.mas_top).offset(Scale(16));
        }];
        
        self.textView = [[SDBaseTextView alloc] init];
        self.textView.layer.cornerRadius = 6;
        self.textView.layer.masksToBounds = YES;
        self.textView.delegate = self;
        if (self.text) {
            self.textView.text = self.text;
        }
        self.textView.placeholder = self.placeholder;
        self.textView.font = [UIFont systemFontOfSize:16];
        self.textView.backgroundColor = [UIColor whiteColor];
        [_popView addSubview:self.textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(Scale(Scale(72)));
            make.top.equalTo(_titleLable.mas_bottom).offset(Scale(12));
            make.left.equalTo(_popView.mas_left).offset(Scale(17));
            make.right.equalTo(_popView.mas_right).offset(Scale(-17));
        }];
        
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:13];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textColor = RGB(141, 147, 157);
        self.tipLabel.text = self.tipMessage;
        [_popView addSubview:self.tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(Scale(40));
            make.top.equalTo(_textView.mas_bottom).offset(Scale(8));
            make.left.equalTo(_textView.mas_left);
            make.right.equalTo(_textView.mas_right);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.tag = 1;
        cancelBtn.backgroundColor = RGB(245, 245, 245);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:RGB(142, 147, 157) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.tag = 2;
        sureBtn.backgroundColor = RGB(0, 132, 246);
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:sureBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_popView.mas_left);
            make.height.mas_equalTo(Scale(48));
            make.bottom.equalTo(_popView.mas_bottom);
            make.right.equalTo(sureBtn.mas_left);
            make.width.equalTo(sureBtn.mas_width);
        }];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_right);
            make.centerY.equalTo(cancelBtn.mas_centerY);
            make.right.equalTo(_popView.mas_right);
            make.height.equalTo(cancelBtn.mas_height);
            make.width.equalTo(cancelBtn.mas_width);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB(205, 205, 205);;
        [_popView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_left);
            make.top.equalTo(cancelBtn.mas_top);
            make.width.equalTo(cancelBtn.mas_width);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChangeNotification" object:self.textView];
}

- (void)didClickAction:(UIButton *)button {
    if (button.tag ==1) {
        NSLog(@"取消");
        [self.textView resignFirstResponder];
        [self removeFromSuperview];
    }else{
        NSLog(@"确定");
        if (self.textView.text.length <= 0) {
            [self reminderAction:self.type==1?@"请输入标签名称":@"请输入设备别名"];
            return;
        }
        if (self.popViewBlock) {
            self.popViewBlock(self.type, _textView.text,YES);
        }
    }
    
}

- (void)show {
    self.titleLable.text = self.title;
    self.tipLabel.text = self.tipMessage;
    self.textView.placeholder = self.placeholder;
    if (self.text) {
        self.textView.text = self.text;
    }
    
    [_tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(!_tipMessage.length ? 0 : Scale(40));
        make.top.equalTo(_textView.mas_bottom).offset(Scale(8));
        make.left.equalTo(_textView.mas_left);
        make.right.equalTo(_textView.mas_right);
    }];
    [_popView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(Scale(304));
        make.height.mas_offset(!_tipMessage.length ? Scale(192) : Scale(232));
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [RGB(37, 48, 68) colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - UITextViewDelegate
-(void)textFiledEditChanged:(NSNotification *)obj{
//    UITextView *textField = (UITextView *)obj.object;
//    NSLog(@"noti text =%@",textField.text);
//    NSString *toBeString = textField.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            NSUInteger len = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//            if (len > self.maxCount) {
//                [self reminderAction:[NSString stringWithFormat:@"单个%@字符长度不超过%ld",(self.type==1)?@"标签":@"别名",self.maxCount]];
//                textField.text = lastContentString;
//            } else{
//                lastContentString = toBeString;
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        NSUInteger len = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//        if (len > self.maxCount) {
//            [self reminderAction:[NSString stringWithFormat:@"单个%@字符长度不超过%ld",(self.type==1)?@"标签":@"别名",self.maxCount]];
//            textField.text = lastContentString;
//        }else{
//            lastContentString = toBeString;
//
//        }
//    }
//    NSUInteger lenght = [lastContentString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    if (lenght < self.maxCount) {
//        self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.textView.layer.borderWidth = 1;
//        self.tipLabel.textColor = RGB(141, 147, 157);
//        self.tipLabel.text = self.tipMessage;
//    }
}

- (void)reminderAction:(NSString *)tip {
    self.tipLabel.textColor = RGB(218, 20, 20);
    self.tipLabel.text =tip;
    
    self.textView.layer.borderColor = RGB(218, 20, 20).CGColor;
    self.textView.layer.borderWidth = 1;
}

//static NSString *regex = @"^[a-z0-9A-Z\\u4E00-\\u9FA5_]+$";
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //NSLog(@"textView.text=%@,text=%@",textView.text,text);
    
//    if ([text isEqualToString:@"\n"]) {
//        [self.textView resignFirstResponder];
//        return NO;
//    }
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isValid = [predicate evaluateWithObject:text];
//    if (!isValid) {
//        NSLog(@"标签为大小写字母、数字、下划线、中文，单个标签字符长度不超过40");
//        [self reminderAction:[NSString stringWithFormat:@"%@大小写字母、数字、下划线、中文",(self.type==1)?@"标签":@"别名"]];
//        return NO;
//    }
    
    return YES;
}
- (void)checkTextView:(UITextView *)textView {
    [SDTextLimitTool restrictionInputTextViewMaskSpecialCharacter:textView maxNumber:self.maxCount handler:^(SDTextErrorType errorType) {
        if (errorType == Illegal) {
            [self reminderAction:[NSString stringWithFormat:@"%@仅限大小字母、数字、下划线、中文",(self.type==1)?@"标签":@"别名"]];
        }else if (errorType == MoreThanLength){
            [self reminderAction:[NSString stringWithFormat:@"单个%@字符长度不超过%ld",(self.type==1)?@"标签":@"别名",self.maxCount]];
        }else{
            self.textView.layer.borderColor = [UIColor whiteColor].CGColor;
            self.textView.layer.borderWidth = 1;
            self.tipLabel.textColor = RGB(141, 147, 157);
            self.tipLabel.text = self.tipMessage;
        }
    }];
}

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"change=%@",textView.text);
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    NSString *lang = textView.textInputMode.primaryLanguage;//获取键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]){//九宫格
        //拼音输入的时候 selectedRange 会有值 输入完成 selectedRange 会等于nil
        //所以在输入完再进行相关的逻辑操作
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange) {//拼音全部输入完成
            //写相关输入监听逻辑
            [self checkTextView:textView];
        }else{//bar上的拼音监听
            //不做处理
        }
    }else{//英文情况下
        //写相关输入监听逻辑
        [self checkTextView:textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    offsetY = self.popView.frame.origin.y;
    CGRect rect = self.popView.frame;
    rect.origin.y =  rect.origin.y - 30;
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = rect;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    CGRect rect = self.popView.frame;
    rect.origin.y = offsetY;
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.frame = rect;
    }];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}



@end
