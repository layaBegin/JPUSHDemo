//
//  JPushWebViewController.m
//  JiguangDemo
//
//  Created by raoxudong on 2020/11/25.
//

#import "JPushWebViewController.h"
#import <WebKit/WKWebView.h>
@interface JPushWebViewController ()

@property(nonatomic, strong) WKWebView *webView;

@end

@implementation JPushWebViewController
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
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    self.title = @"极光";
    //导航栏
    UIImage *itemImage = [UIImage imageNamed:@"glaryArrow"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
