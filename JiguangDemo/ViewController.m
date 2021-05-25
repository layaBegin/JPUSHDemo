//
//  ViewController.m
//  TargetProject
//
//  Created by ys on 2020/8/20.
//

#import "ViewController.h"
#import "HomeCollectionCell.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIView *contentView;

@property (nonatomic, assign, nullable) Class jpushClass;
@property (nonatomic, assign, nullable) Class jshareClass;
@property (nonatomic, assign, nullable) Class jmlinkClass;
@property (nonatomic, assign, nullable) Class jverificationClass;
@property (nonatomic, assign, nullable) Class junionClass;
@property (nonatomic, strong, nullable) NSArray *datas;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
    return NO;
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    // 解决右滑返回失效问题
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.jpushClass = NSClassFromString(@"JPushHomeViewController");
    self.jshareClass = NSClassFromString(@"JShareHomeViewController");
    self.jmlinkClass = NSClassFromString(@"JMLinkViewController");
    self.jverificationClass = NSClassFromString(@"JVerificationViewController");
    self.junionClass = NSClassFromString(@"JUnionViewController");

    
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    // UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:247/255.0 alpha:1.0];
    [_scrollView addSubview:_contentView];
    
    
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JBack"]];
    backImageView.frame = CGRectMake(0, 0, Scale(375), Scale(320));
    [_contentView addSubview:backImageView];
    
    UIView * whiteRoundView = [[UIView alloc] init];
    whiteRoundView.backgroundColor = UIColor.whiteColor;
    whiteRoundView.layer.cornerRadius = 6;
    whiteRoundView.layer.masksToBounds = true;
    [_contentView addSubview:whiteRoundView];
    [whiteRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).offset(Scale(234));
        make.width.mas_equalTo(DeviceSize.width);
        make.left.right.equalTo(_contentView);
    }];
    

    UIView *itemView1 = [self createItmeViewTitle:@"极光推送" imageName:@"JPush" action:NSSelectorFromString(@"toJPush") class:self.jpushClass];
    UIView *itemView2 = [self createItmeViewTitle:@"极光认证" imageName:@"JVerification" action:NSSelectorFromString(@"toJVerification") class:self.jverificationClass];
    UIView *itemView3 = [self createItmeViewTitle:@"极光联盟" imageName:@"JUnion" action:NSSelectorFromString(@"toJUnion") class:self.junionClass];
    UIView *itemView4 = [self createItmeViewTitle:@"极光分享" imageName:@"JShare" action:NSSelectorFromString(@"toJShare") class:self.jshareClass];
    UIView *itemView5 = [self createItmeViewTitle:@"极光魔链" imageName:@"JMLink" action:NSSelectorFromString(@"toJMLink") class:self.jmlinkClass];
    [whiteRoundView addSubview:itemView1];
    [whiteRoundView addSubview:itemView2];
    [whiteRoundView addSubview:itemView3];
    [whiteRoundView addSubview:itemView4];
    [whiteRoundView addSubview:itemView5];
    
    float spaceing = 16;
    float itemWidth = (SCREEN_WIDTH - spaceing*3)/2;
    float itemHeight = Scale(115);
    [itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
        make.top.equalTo(whiteRoundView.mas_top).offset(26);
        make.left.equalTo(whiteRoundView.mas_left).offset(spaceing);
    }];
    
    [itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
        make.top.equalTo(itemView1.mas_top);
        make.left.equalTo(itemView1.mas_right).offset(spaceing);
    }];
    
    [itemView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
        make.top.equalTo(itemView1.mas_bottom).offset(16);
        make.left.equalTo(itemView1.mas_left);
    }];
    
    [itemView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
        make.top.equalTo(itemView3.mas_top);
        make.left.equalTo(itemView3.mas_right).offset(16);
    }];
    
    [itemView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
        make.top.equalTo(itemView3.mas_bottom).offset(16);
        make.left.equalTo(itemView3.mas_left);
    }];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feet_logo"]];
    [whiteRoundView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Scale(104));
        make.height.mas_equalTo(Scale(16));
        make.centerX.equalTo(whiteRoundView.mas_centerX);
        make.top.greaterThanOrEqualTo(itemView5.mas_bottom).offset(16);
        make.bottom.equalTo(whiteRoundView.mas_bottom).offset(-20);
    }];
    
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(_scrollView);
        make.height.mas_greaterThanOrEqualTo(self.view.frame.size.height);
        make.bottom.equalTo(whiteRoundView.mas_bottom);
    }];
}

- (UIView *)createItmeViewTitle:(NSString *)title imageName:(NSString *)imageName action:(SEL)action class:(Class)class{
      
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.layer.cornerRadius = 4;
    itemView.layer.masksToBounds = YES;
    itemView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:239/255.0 blue:247/255.0 alpha:1.0].CGColor;
    itemView.layer.borderWidth = 1;
    
    UIImageView *icon2 = [[UIImageView alloc] init];
    icon2.image = [UIImage imageNamed:imageName];
    [itemView addSubview:icon2];
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(42);
        make.top.equalTo(itemView.mas_top).offset(21);
        make.centerX.equalTo(itemView.mas_centerX);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:15];
    label2.textColor = RGB(72, 81, 98);
    label2.text = title;
    [itemView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon2.mas_bottom).offset(10);
        make.bottom.equalTo(itemView.mas_bottom).offset(-21);
        make.centerX.equalTo(itemView.mas_centerX);
    }];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(itemView.mas_width);
        make.height.equalTo(itemView.mas_height);
        make.top.equalTo(itemView.mas_top);
        make.left.equalTo(itemView.mas_left);
    }];
    
    if (class) {
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    } else {
        label2.textColor = UIColor.lightGrayColor;
    }
    
    return itemView;
}

- (void)toJPush {
    UIViewController * jpushVC = [[self.jpushClass alloc] init];
    [self.navigationController pushViewController:jpushVC animated:YES];
}

- (void)toJShare {
    UIViewController * jshareVC = [[self.jshareClass alloc] init];
    [self.navigationController pushViewController:jshareVC animated:YES];
}

- (void)toJMLink {
    UIViewController * jmlinkVC = [[self.jmlinkClass alloc] init];
    [self.navigationController pushViewController:jmlinkVC animated:YES];
}

- (void)toJVerification {
    UIStoryboard *table = [UIStoryboard storyboardWithName:@"JVMain" bundle:nil];
    //加载 对应的viewcontroller
    UIViewController *controler = table.instantiateInitialViewController;
    [self.navigationController pushViewController:controler animated:YES];
}
-(void)toJUnion{
    UIViewController * junionVC = [[self.junionClass alloc] init];
    [self.navigationController pushViewController:junionVC animated:YES];
}
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;

}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSDictionary *content = self.datas[indexPath.row];
    cell.icon.image = [UIImage imageNamed:content[@"image"]];
    cell.label.text = content[@"title"];

    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *content = self.datas[indexPath.row];
    NSString *selStr = content[@"selector"];
    SEL selector = NSSelectorFromString(selStr);
    [self performSelector:selector withObject:nil];
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end

