//
//  JPushTagListView.m
//  JiguangDemo
//
//  Created by xudong.rao on 2020/11/11.
//

#import "JPushTagListView.h"
#import "Masonry.h"

#define Image_Width  14.0
#define Image_Height  Image_Width

#define Text_Width 68.0
#define Text_Height 34.0
#define Text_Space 10.0

@interface TagItemView : UIButton
@property(nonatomic, strong) UIImageView *removeImageView;
@property(nonatomic, assign) BOOL isEditState;
@property(nonatomic, assign) BOOL isAddButton;
@end

@implementation TagItemView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isAddButton = NO;
        _removeImageView = [[UIImageView alloc] init];
        _removeImageView.frame = CGRectZero ;//CGRectMake(CGRectGetMaxX(frame)-Image_Width/2, CGRectGetMinY(frame)-Image_Height/2, Image_Width, Image_Height);
        _removeImageView.image = [UIImage imageNamed:@"tag_close"];
        _removeImageView.hidden = YES;
        _removeImageView.userInteractionEnabled = YES;
        [self addSubview:_removeImageView];
        
        _removeImageView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        [_removeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(Image_Width);
            make.height.mas_offset(Image_Height);
            make.top.equalTo(self.mas_top).offset(-Image_Height/2);
            make.right.equalTo(self.mas_right).offset(Image_Width/2);
        }];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [removeImage addGestureRecognizer:tap];
//        [tap addTarget:self action:@selector(tapIconView:)];
    }
    return self;
}


-(void)setIsEditState:(BOOL)isEditState {
    _isEditState = isEditState;
//    _removeImageView.frame = CGRectMake(CGRectGetMaxX(self.frame)-Image_Width/2, CGRectGetMinY(self.frame)-Image_Height/2, Image_Width, Image_Height);
    self.removeImageView.hidden = !_isEditState;
    if (self.isAddButton) {
        self.removeImageView.hidden = YES;
    }
}

@end

@interface JPushTagListView (){
    
    CGRect  previousFrame ;
    float   tagView_height ;
    NSInteger tagIndex;

    NSMutableArray *tagArray;
    NSMutableArray *itemsArray;
    BOOL editStatus;
}

@end

@implementation JPushTagListView

-(BOOL)isEditStatus{
    return editStatus;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        editStatus = NO;
        _autoTagWidth = NO;
        _tagFont = 12;
        _minimumHeight = 45;
        _tagWidth = Text_Width;
        _tagTextColor = [UIColor blackColor];
        _tagBackgroundColor = [UIColor grayColor];
        _tagTextAlignment = NSTextAlignmentLeft;
        _tagCornerRadius = 4;
        _tagBorderWidth = 0;
        _tagBorderColor = nil;
        _is_can_addTag = YES;
        
        itemsArray = [NSMutableArray array];
    }
    return self;
}
- (NSInteger)tagsCount{
    return tagArray.count;
}
- (NSArray *)tagsArray {
    return tagArray;
}
- (void)reloadData:(NSArray *)newTagArr {
    previousFrame = CGRectZero;
    [tagArray removeAllObjects];
    for (id temp in self.subviews) {
        if ([temp isKindOfClass:[UIButton class]] || [temp isKindOfClass:[UIImageView class]]) {
            [temp removeFromSuperview];
        }
    }
    if (newTagArr.count == 0 || !newTagArr) {
        editStatus = NO;
    }
    [self creatUI:newTagArr];
}
- (CGRect)updateItem:(TagItemView *)button title:(NSString *)title previousFrame:(CGRect)frame {
    CGFloat itemWidth = self.tagWidth;
    button.frame = CGRectMake(0, 0, itemWidth, Text_Height);
    
    if (self.autoTagWidth && self.maximumTagWidth > Text_Width) {
        //计算label的大小
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tagFont]};
        CGSize Size_str = [title sizeWithAttributes:attrs];
        itemWidth = Size_str.width;
        if (Size_str.width > self.maximumTagWidth) {
            itemWidth = self.maximumTagWidth;
        }
        if (Size_str.width < self.tagWidth) {
            itemWidth = self.tagWidth;
        }
    }
    
    CGRect newRect = CGRectZero;
    if (CGRectGetMaxX(previousFrame) + Text_Space + itemWidth > CGRectGetWidth(self.frame)) {
        newRect.origin = CGPointMake(Text_Space, CGRectGetMaxY(previousFrame) + Text_Space);
    }else{
        newRect.origin = CGPointMake(CGRectGetMaxX(previousFrame)+Text_Space, (button.tag==0)?Text_Space:CGRectGetMinY(previousFrame));
    }
    newRect.size = CGSizeMake(itemWidth, Text_Height);
    button.frame = newRect;
    return button.frame;
}

-(void)creatUI:(NSArray *)tagArr {
    tagArray = [NSMutableArray arrayWithArray:tagArr];
    if (_is_can_addTag) {
        [tagArray addObject:@""];
    }
    
    for (int i = 0; i < tagArray.count; i++) {
        NSString *tag = tagArray[i];
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:_tagTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:_tagFont];
        //button.titleLabel.textAlignment = NSTextAlignmentLeft;//_tagTextAlignment;
        if (self.tagTextAlignment == NSTextAlignmentLeft) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else if (self.tagTextAlignment == NSTextAlignmentRight){
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }else{
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.backgroundColor =_tagBackgroundColor;
        button.layer.cornerRadius = _tagCornerRadius;
        button.layer.masksToBounds = YES;
        if (_tagBorderColor) {
            button.layer.borderColor = _tagBorderColor.CGColor;
            button.layer.borderWidth = _tagBorderWidth;
        }
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        button.tag = i;
        [self addSubview:button];
        [itemsArray addObject:button];
        
        //previousFrame = [self updateItem:button title:tag previousFrame:previousFrame];
        
        /**/
        CGFloat itemWidth = self.tagWidth;
        button.frame = CGRectMake(0, 0, itemWidth, Text_Height);
        if (self.autoTagWidth && self.maximumTagWidth > Text_Width) {
            //计算label的大小
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tagFont]};
            CGSize Size_str = [tag sizeWithAttributes:attrs];
            itemWidth = Size_str.width;
            if (Size_str.width > self.maximumTagWidth) {
                itemWidth = self.maximumTagWidth;
            }
            if (Size_str.width < self.tagWidth) {
                itemWidth = self.tagWidth;
            }
        }
        
        CGRect newRect = CGRectZero;
        if (CGRectGetMaxX(previousFrame) + Text_Space + itemWidth > CGRectGetWidth(self.frame)) {
            newRect.origin = CGPointMake(Text_Space, CGRectGetMaxY(previousFrame) + Text_Space);
        }else{
            newRect.origin = CGPointMake(CGRectGetMaxX(previousFrame)+Text_Space, (i==0)?Text_Space:CGRectGetMinY(previousFrame));
        }
        newRect.size = CGSizeMake(itemWidth, Text_Height);
        button.frame = newRect;
        previousFrame = button.frame;
         
        
        if (_is_can_addTag && i == tagArray.count -1) {
            [button setBackgroundImage:[UIImage imageNamed:@"jpush_addbtn"]  forState:UIControlStateNormal];
//            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.hidden = editStatus?YES:NO;
            button.backgroundColor = [UIColor clearColor];
        }else{
            [button setTitle:tag forState:UIControlStateNormal];
            
            UIImageView *removeImage = [[UIImageView alloc] init];
            removeImage.frame = CGRectMake(CGRectGetMaxX(button.frame)-Image_Width/2, CGRectGetMinY(button.frame)-Image_Height/2, Image_Width, Image_Height);
            removeImage.image = [UIImage imageNamed:@"tag_close"];
            removeImage.hidden = editStatus?NO:YES;
            removeImage.tag = i;
            removeImage.userInteractionEnabled = YES;
            [self addSubview:removeImage];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [removeImage addGestureRecognizer:tap];
            [tap addTarget:self action:@selector(tapIconView:)];
        }
    }
    [self setHight:self andHight:CGRectGetMaxY(previousFrame) + Text_Space];
}
- (void)tapIconView:(UITapGestureRecognizer *)tap {
    id temp = tap.view;
    if ([temp isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)temp;

        if (self.deleteBlock) {
            self.deleteBlock(imageView.tag,tagArray[imageView.tag]);
        }
        [self deleteTagsView:imageView.tag];
    }
}
- (void)intoEditStatus:(BOOL)edit {
    editStatus = edit;
    for (id temp in self.subviews) {
        if ([temp isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)temp;
            imageView.hidden = !editStatus;
        }
        if (_is_can_addTag) {
            if ([temp isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)temp;
                if (btn.tag == tagArray.count -1) {
                    btn.hidden = editStatus;
                }
            }
        }
    }
}
- (void)updateTagBackgroundColor:(UIColor *)color {
    if (!color) {
        return;
    }
    self.tagBackgroundColor = color;
    for (id temp in self.subviews) {
        if ([temp isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)temp;
            if (_is_can_addTag) {
                if (btn.tag == tagArray.count -1) {
                    continue;
                }
            }
            btn.backgroundColor = self.tagBackgroundColor;
        }
    }
}

- (void)setHight:(UIView *)view andHight:(CGFloat)height {
    if (height > self.minimumHeight) {
        
        CGRect tempFrame = view.frame;
        tempFrame.size.height = height;
        view.frame = tempFrame;
        
    }
    NSInteger count = tagArray.count;
    if (_is_can_addTag) {
        count = count-1;
    }
    if (self.updateFrameBlock) {
        self.updateFrameBlock(view.frame,count);
    }
}

- (void)clickTagButton:(TagItemView *)button {
    if (button.tag == tagArray.count -1) {
        if (_is_can_addTag) {
            if (self.addBlock) {
                self.addBlock(button.tag);
                return;
            }
        }
    }
    if (editStatus) {
        if (self.deleteBlock) {
            self.deleteBlock(button.tag,tagArray[button.tag]);
        }
        [self deleteTagsView:button.tag];
    }
}
- (void)deleteTagsView:(NSInteger)index {
    if (editStatus) {
//        for (id temp in self.subviews) {
////            if ([temp isKindOfClass:[UIImageView class]]) {
////                UIImageView *imageView = (UIImageView *)temp;
////                if (imageView.tag == index) {
////                    [imageView removeFromSuperview];
////                }
////            }
//            if ([temp isKindOfClass:[UIButton class]]) {
//                UIButton *btn = (UIButton *)temp;
//                if (btn.tag == index) {
//                    [btn removeFromSuperview];
//                    [tagArray removeObjectAtIndex:index];
//                    break;
//                }
//            }
//        }
        NSMutableArray *temp = [NSMutableArray arrayWithArray:tagArray];
        [temp removeObjectAtIndex:index];
        for (int i = 0; i < temp.count; i++) {
            NSString *tt = temp[i];
            if ([tt isEqualToString:@""]) {
                [temp removeObject:tt];
                break;
            }
        }
        [self reloadData:temp];
    }
    
}

@end
