//
//  JPushTagAliasViewController.m
//  JiguangDemo
//
//  Created by JIGUANG on 2020/11/5.
//

#import "JPushTagAliasViewController.h"
#import "JPushPopView.h"
#import "JPUSHService.h"
#import "JPushTagListView.h"
#import "Toast.h"
#import "UIButton+JXPostion.h"


#define default_addview_height 108.0
#define JiguangMobile @"JiguangMobile"

@interface JPushTagAliasViewController ()
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIView *contentView;

@property(strong, nonatomic) UIView *tagsBgView;/**<tags 容器视图 */
@property(strong, nonatomic) UIView *tagsDefaultView;/**<tags 没有设置时的默认视图 */
@property(strong, nonatomic) JPushTagListView *tagListView;/**<已经设置的 tags 视图 */

@property(strong, nonatomic) UIButton *tagsEditButton;

@property(strong, nonatomic) UIView *mobileBgView;
@property(strong, nonatomic) UIButton *mobileEditBtn;

@property(strong, nonatomic) UIView *aliasBgView;/**<alias 容器视图 */
@property(strong, nonatomic) UIButton *aliasEditButton;
@property(strong, nonatomic) NSString *deviceAlias;
@property(strong, nonatomic) NSString *mobile;

@end

@implementation JPushTagAliasViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent= true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送高级功能";
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    //导航栏
    UIImage *itemImage = [UIImage imageNamed:@"glaryArrow"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // UIScrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_contentView];
    

    // 子视图
    [self initTagsView];
    [self initMobileView];
    [self initAliasView];
    
    [_mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tagsBgView.mas_bottom).offset(Scale(10));
        make.left.width.equalTo(_tagsBgView);
        make.height.mas_equalTo(Scale(56));
    }];
    [_aliasBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mobileBgView.mas_bottom);
        make.left.width.equalTo(_tagsBgView);
        make.height.mas_equalTo(Scale(56));
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(1);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView.mas_width);
        make.bottom.equalTo(_aliasBgView.mas_bottom).offset(20);
    }];
    
    [self getMobile];
    [self getAllTags];
    [self getAlias];
    
}

- (void)initTagsView {
    _tagsBgView = [[UIView alloc] init];
    _tagsBgView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_tagsBgView];
    
    [_tagsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top);
        make.left.equalTo(_contentView.mas_left);
        make.right.equalTo(_contentView.mas_right);
        //make.height.mas_greaterThanOrEqualTo(Scale(160));
    }];
    
    UIImageView *tagImageView = [[UIImageView alloc] init];
    tagImageView.image = [UIImage imageNamed:@"tag"];
    [_tagsBgView addSubview:tagImageView];
    [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(Scale(20));
        make.left.equalTo(_tagsBgView.mas_left).offset(Scale(16));
        make.top.equalTo(_tagsBgView.mas_top).offset(Scale(17));
    }];
     
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.numberOfLines = 0;
    tagLabel.text = @"设置标签（Tag）";
    tagLabel.font = [UIFont systemFontOfSize:16.0];
    tagLabel.textColor = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
    [_tagsBgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagImageView.mas_centerY);
        make.left.equalTo(tagImageView.mas_right).offset(Scale(1));
        make.height.mas_equalTo(Scale(22));
    }];
    
    _tagsEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tagsEditButton setImage:[UIImage imageNamed:@"jpush_edit_btn"] forState:UIControlStateNormal];
    [_tagsEditButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_tagsEditButton setTitleColor:RGB(0, 132, 246) forState:UIControlStateNormal];
    _tagsEditButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _tagsEditButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _tagsEditButton.tag = 1;
    _tagsEditButton.hidden = YES;
    [_tagsEditButton addTarget:self action:@selector(editTagOrAliasOrMobile:) forControlEvents:UIControlEventTouchUpInside];
    [_tagsBgView addSubview:_tagsEditButton];
    [_tagsEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tagLabel.mas_centerY);
        make.right.equalTo(_tagsBgView.mas_right).offset(-16);
        make.height.mas_offset(30);
        make.width.mas_offset(60);
    }];
    
    _tagsDefaultView = [[UIView alloc] init];
    _tagsDefaultView.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    [_tagsBgView addSubview:_tagsDefaultView];
    
    // 加载空状态的默认视图
    [_tagsDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagImageView.mas_bottom).offset(Scale(14));
        make.left.equalTo(tagImageView.mas_left);
        make.right.equalTo(_tagsBgView.mas_right).offset(Scale(-16));
        make.height.mas_equalTo(Scale(default_addview_height));
    }];
    [self initDefaultSubviews];
    self.tagsDefaultView.hidden = YES;
    
    // 加载tags list view = self.tagListView
    [self reloadTagsView:nil];
    [self.tagListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagImageView.mas_bottom).offset(Scale(14));
        make.left.equalTo(tagImageView.mas_left);
        make.right.equalTo(_tagsBgView.mas_right).offset(Scale(-16));
        make.height.mas_equalTo(Scale(default_addview_height));
    }];
    
    UIImageView *tipImageView = [[UIImageView alloc] init];
    tipImageView.image = [UIImage imageNamed:@"jpush_tip"];
    [_tagsBgView addSubview:tipImageView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"设置用户标签后，可分群体针对性推送，有效提升点击率";
    tipLabel.font = [UIFont systemFontOfSize:13.0];
    tipLabel.textColor =RGB(141, 147, 157);
    [_tagsBgView addSubview:tipLabel];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_top);
        make.left.equalTo(self.tagListView.mas_left);
        make.width.and.height.mas_equalTo(Scale(14));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagListView.mas_bottom).offset(Scale(10));
        make.left.equalTo(tipImageView.mas_right).offset(1);
        make.right.equalTo(self.tagListView.mas_right);
        make.height.mas_greaterThanOrEqualTo(Scale(17));
    }];
    
    [_tagsBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tipLabel.mas_bottom).offset(Scale(10));
    }];
    
}

- (void)initMobileView {
    _mobileBgView = [[UIView alloc] init];
    _mobileEditBtn = [[UIButton alloc] init];
    [self factoryMobileAndAlias:_mobileBgView img:@"mobile" title:@"手机号码" editBtn:_mobileEditBtn tag:3];
}

- (void)initAliasView {
    _aliasBgView = [[UIView alloc] init];
    _aliasEditButton = [[UIButton alloc] init];
    [self factoryMobileAndAlias:_aliasBgView img:@"card" title:@"设备别名" editBtn:_aliasEditButton tag:2];
}

- (void)factoryMobileAndAlias:(UIView *)bgView
                          img:(NSString *)img
                        title:(NSString*)title
                      editBtn:(UIButton*)editBtn
                          tag:(NSInteger)tag{
    bgView.backgroundColor = UIColor.whiteColor;
    [_scrollView addSubview:bgView];
    
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = [UIImage imageNamed:img];
    [bgView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(Scale(20));
        make.left.equalTo(bgView.mas_left).offset(Scale(16));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
     
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(iv.mas_right).offset(Scale(1));
        make.height.mas_equalTo(Scale(22));
    }];
    
    editBtn.tag = tag;
    [editBtn setTitle:@"请填写" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithRed:141/255.0 green:147/255.0 blue:157/255.0 alpha:1.0] forState:UIControlStateNormal];
    [editBtn setImagePosition:LXMImagePositionRight spacing:4.0];
    [editBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(editTagOrAliasOrMobile:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-Scale(20));
        make.centerY.equalTo(bgView);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(Scale((10)));
        make.right.equalTo(bgView).offset(-Scale((10)));
        make.bottom.equalTo(bgView.mas_bottom);
        make.height.mas_equalTo(Scale(1));
    }];
}

/// 设置默认标签视图
- (void)initDefaultSubviews {
    UIView *view = _tagsDefaultView;
    NSString *tipTitle = @"您还没有添加任何标签";
    NSString *btnTitle = @"添加标签";
    UIImageView *editImageView = [[UIImageView alloc] init];
    editImageView.image = [UIImage imageNamed:@"jpush_edit"];
    [view addSubview:editImageView];
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(view.mas_left).offset(Scale(50));
        make.width.and.height.mas_equalTo(73);
        //make.bottom.equalTo(view.mas_bottom).offset(-18);
    }];
    
    UILabel *editabel = [[UILabel alloc] init];
    editabel.text = tipTitle;
    editabel.font = [UIFont systemFontOfSize:13.0];
    editabel.textColor = [UIColor colorWithRed:141/255.0 green:147/255.0 blue:157/255.0 alpha:1.0];
    [view addSubview:editabel];
    [editabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(editImageView.mas_top).offset(5);
        make.left.equalTo(editImageView.mas_right).offset(18);
        make.height.mas_equalTo(Scale(20));
    }];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addBtn setTitle:btnTitle forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    addBtn.backgroundColor = RGB(0, 132, 246);
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 4;
    addBtn.tag = 1;
    [addBtn addTarget:self action:@selector(addTagOrAlias:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(editabel.mas_bottom).offset(10);
        make.left.equalTo(editImageView.mas_right).offset(18);
        make.height.mas_equalTo(Scale(31));
        make.width.mas_equalTo(Scale(85));
    }];
}

/// 点击添加 标签 或者  别名
- (void)addTagOrAlias:(UIButton *)button {
    [self addTagOrAliasAction:button.tag];
}
- (void)addTagOrAliasAction:(NSInteger)type{
    if (type == 1) {
        NSInteger count = self.tagListView.tagsCount;
        if (self.tagListView.is_can_addTag) {
            count = count -1;//减去最后一个加按钮
        }
        if (count >= 10) {
            [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"最多可添加10个标签" superView:self.view];
            return;
        }
    }
    
    JPushPopView *popView = [[JPushPopView alloc] init];
    popView.type = type;
    popView.maxCount  = 40;
    if (type == 1) {
        NSLog(@"添加标签");
        popView.title = @"新建标签";
        popView.placeholder = @"请输入标签内容";
        popView.tipMessage = @"标签为大小写字母、数字、下划线、中文，单个标签字符长度不超过40";
    }else if (type == 2) {
        NSLog(@"添加别名");
        popView.title = @"添加设备别名";
        popView.placeholder = @"请输入设备别名";
        popView.tipMessage = @"设备别名为大小写字母、数字、下划线、中文，单个别名字符长度不超过40";
        if (self.deviceAlias) {
            popView.text = self.deviceAlias;
            popView.title = @"编辑设备别名";
        }
    } else if (type == 3) {
        NSLog(@"添加手机号");
        popView.title = @"添加手机号码";
        popView.placeholder = @"请输入手机号码";
        popView.tipMessage = @"";
        if (self.mobile) {
            popView.text = self.mobile;
        }
    }
    [popView show];
    
    __weak JPushPopView *weakPopView = popView;
    popView.popViewBlock = ^(NSInteger type,NSString *content, BOOL isSuccess) {
        if (type == 1) {
            [self setTag:content popView:weakPopView];
        }else if(type == 2) {
            [self setAlias:content popView:weakPopView];
        } else {
            [self setMobile:content popView:weakPopView];
        }
    };
}
- (void)setTag:(NSString *)tag popView:(JPushPopView *)popView {
    
    for (NSString *t in _tagListView.tagsArray) {
        if ([tag isEqualToString:t]) {
            [popView reminderAction:@"该标签已存在，请重新输入"];
            return;
        }
    }
    
    NSMutableSet * tags = [[NSMutableSet alloc] init];
    [tags addObjectsFromArray:@[tag]];
    //过滤掉无效的tag
    NSSet *newTags = [JPUSHService filterValidTags:tags];
    
    [JPUSHService addTags:newTags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        if (iResCode == 0) {
            [popView dismiss];
            [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"添加成功" superView:self.view];
            
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self getAllTags];
        }else if (iResCode == 6002){
            [Toast showTostWithImage:[UIImage imageNamed:@"Toast_1"] title:@"请求超时" superView:self.view];
        }else{
            //[popView reminderAction:[NSString stringWithFormat:@"设置别名出错，错误码：%@",@(iResCode)]];
        }
    } seq:0];
}
- (void)setAlias:(NSString *)alias popView:(JPushPopView *)popView {
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            [popView dismiss];
            [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"添加成功" superView:self.view];
            
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self getAlias];
        }else if (iResCode == 6002){
            [Toast showTostWithImage:[UIImage imageNamed:@"Toast_1"] title:@"请求超时" superView:self.view];
        }else{
            //[popView reminderAction:[NSString stringWithFormat:@"设置别名出错，错误码：%@",@(iResCode)]];
        }

    } seq:0];
}

- (void)setMobile:(NSString *)mobile popView:(JPushPopView *)popView {
    [JPUSHService setMobileNumber:mobile completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [popView dismiss];
                [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"设置成功" superView:self.view];
                [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:JiguangMobile];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self getMobile];
            } else{
                [Toast showTostWithImage:[UIImage imageNamed:@"Toast_2"] title:@"设置失败" superView:self.view];
            }
        });
    }];
}

- (void)editTagOrAliasOrMobile:(UIButton *)button {
    if (button.tag == 1) {
        NSLog(@"编辑-标签");
        [self.tagListView intoEditStatus:!self.tagListView.isEditStatus];
        if (!self.tagListView.isEditStatus) {
            [self getAllTags];
        }
    }else if (button.tag == 2) {
        NSLog(@"编辑-别名");
        [self addTagOrAliasAction:2];
    } if (button.tag == 3) {
        NSLog(@"编辑-手机号");
        [self addTagOrAliasAction:3];
    }
}

///获取所有tag
- (void)getAllTags {
    NSLog(@"getAllTags");
    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"iTags=%@",iTags);
        NSArray *allTags = nil;
        if (iResCode == 0) {
            allTags = [NSArray arrayWithArray:iTags.allObjects];
        }
        [self reloadTagsView:allTags];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } seq:1];
}

- (void)reloadTagsView:(NSArray *)tags {
    if (!self.tagListView) {
        
        self.tagListView = [[JPushTagListView alloc] init];
        self.tagListView.backgroundColor =  RGB(246, 247, 248);
        self.tagListView.tagCornerRadius = 4.0;  //标签圆角的大小，默认10
        self.tagListView.tagFont = 12.0;
        self.tagListView.tagTextColor = RGB(72, 81, 98);
        self.tagListView.tagBackgroundColor = RGB(228, 230, 232);
        self.tagListView.tagTextAlignment = NSTextAlignmentCenter;
        self.tagListView.is_can_addTag = YES;
        [self.tagsBgView addSubview:self.tagListView];
    }
    
    if (!tags || tags.count <= 0) {
        self.tagListView.hidden = YES;
        self.tagsDefaultView.hidden = NO;
        self.tagsEditButton.hidden = YES;
        
        [self.tagsEditButton setTitle:@"编辑" forState:UIControlStateNormal];
        
        // 没有数据时，更新为初始高度，和默认视图一样高
        [self.tagListView reloadData:@[]];
        return;
    }
    
    CGFloat width = self.tagListView.frame.size.width;
    NSInteger itemCount = 4;//固定每行显示4个标签
    CGFloat itemWidth = (width - 5*10)/itemCount;
    self.tagListView.tagWidth = itemWidth;
    
    self.tagsEditButton.hidden = NO;
    self.tagListView.hidden = NO;
    self.tagsDefaultView.hidden = YES;
    [self.tagsEditButton setTitle:self.tagListView.isEditStatus?@"完成":@"编辑" forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    self.tagListView.addBlock = ^(NSInteger index) {
        NSLog(@"add tag block");
        [weakSelf addTagOrAliasAction:1];
    };
    self.tagListView.deleteBlock = ^(NSInteger index,NSString *tag) {
        NSLog(@"delete tag block");
        
        NSMutableSet * tagsSet = [[NSMutableSet alloc] init];
        [tagsSet addObjectsFromArray:@[tag]];
        
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [JPUSHService deleteTags:tagsSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            if (iResCode == 0) {
                [weakSelf getAllTags];
            }else{
                //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } seq:1];
    };
    self.tagListView.updateFrameBlock = ^(CGRect rect,NSInteger tagsCount) {
        NSLog(@"tag list view update frame block");
        NSLog(@"tagsDefaultView height = %0.f",CGRectGetHeight(weakSelf.tagsDefaultView.frame));
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tagListView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (tagsCount <= 0) {
                    make.height.mas_equalTo(Scale(default_addview_height));
                    weakSelf.tagListView.hidden = YES;
                    weakSelf.tagsDefaultView.hidden = NO;
                    weakSelf.tagsEditButton.hidden = YES;
                }else{
                    make.height.mas_offset(rect.size.height);
                }
            }];
        });
    };
    [self.tagListView reloadData:tags];   //传入Tag数组初始化界面
}
- (void)getAlias {
    NSLog(@"getAlias");
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iAlias=%@",iAlias);
        NSString *alias = nil;
        if (iResCode == 0 && iAlias.length > 0) {
            alias = iAlias;
        }
        self.deviceAlias = alias;
        [self reloadAliasView:alias?alias:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } seq:1];
}

- (void)getMobile {
    _mobile = [[NSUserDefaults standardUserDefaults] objectForKey:JiguangMobile];
    [self reloadMobilView:_mobile];
}

- (void)reloadAliasView:(NSString *)alias {
    [self updateEditBtnWith:alias btn:_aliasEditButton];
}
 
- (void)reloadMobilView:(NSString *)mobile {
    [self updateEditBtnWith:mobile btn:_mobileEditBtn];
}

- (void)updateEditBtnWith:(NSString*)content btn:(UIButton *)btn{
    if (!content || content.length == 0) {
        [btn setTitle:@"请填写" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:141/255.0 green:147/255.0 blue:157/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    } else {
        [btn setTitle:content forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:37/255.0 green:48/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"jpush_edit_btn"] forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    [btn setImagePosition:LXMImagePositionRight spacing:4.0];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:true];
}



@end
