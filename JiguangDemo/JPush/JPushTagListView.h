//
//  JPushTagListView.h
//  JiguangDemo
//
//  Created by xudong.rao on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^JPushTagListViewDeleteBlock)(NSInteger index,NSString *tag);
typedef void (^JPushTagListViewAddBlock)(NSInteger index);
typedef void (^JPushTagListViewUpdateFrameBlock)(CGRect rect,NSInteger tagsCount);

@interface JPushTagListView : UIView



/////如果传入的数组的tag里包含的是字典的话，那么key是必传得，不然获取不到Value
//@property (nonatomic, strong) NSString *tagArrkey;

///标签文字大小
@property (nonatomic, assign) float tagFont;

///标签文字颜色
@property (nonatomic, strong) UIColor *tagTextColor;

///标签背景颜色
@property (nonatomic, strong) UIColor *tagBackgroundColor;

///标签对齐方式
@property (nonatomic) NSTextAlignment tagTextAlignment;

///标签圆角的值
@property (nonatomic, assign) float tagCornerRadius;

///标签边框的宽度
@property (nonatomic, assign) float tagBorderWidth;
///标签边框的颜色
@property (nonatomic, strong) UIColor *tagBorderColor;
///是否在编辑状态
@property (nonatomic, readonly) BOOL isEditStatus;
/// 标签的长度
@property (nonatomic, assign) CGFloat tagWidth;
/// 自适应标签宽度，与 maximumTagWidth 属性一同设置。
@property (nonatomic, assign) BOOL autoTagWidth;
/// 标签的最大长度，与 autoTagWidth 属性一同设置
@property (nonatomic, assign) CGFloat maximumTagWidth;

/// 视图的最小高度
@property (nonatomic, assign) CGFloat minimumHeight;

/////状态（编辑状态下可以点击删除）
//@property (nonatomic, assign) TagStateType tagStateType;
//
///**
// *  是否可以添加标签（yes的时候最后一个按钮为添加按钮）
// */
@property (nonatomic, assign) BOOL is_can_addTag;
//
///**
// *  如果可以添加标签，那么最后一个添加按钮的title
// */
//@property (nonatomic, strong) NSString *addTagStr;

///获取标签数量
@property (nonatomic, readonly) NSInteger tagsCount;
///获取标签数组
@property (nonatomic, readonly) NSArray *tagsArray;

@property(nonatomic, strong) JPushTagListViewAddBlock addBlock;
@property(nonatomic, strong) JPushTagListViewDeleteBlock deleteBlock;
@property(nonatomic, strong) JPushTagListViewUpdateFrameBlock updateFrameBlock;

/**
 *  初始话UI
 *
 *  @param tagArr Tag数组
 */
-(void)creatUI:(NSArray *)tagArr;

/**
 *  刷新数据
 *
 *  @param newTagArr 新的Tag数组
 */
- (void)reloadData:(NSArray *)newTagArr;

- (void)intoEditStatus:(BOOL)edit;

/// 更新全部标签的背景颜色
- (void)updateTagBackgroundColor:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END
