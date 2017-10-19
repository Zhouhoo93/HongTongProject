//
//  noticeWebViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/9/7.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "noticeWebViewController.h"

@interface noticeWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation noticeWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI{

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64-44)];
    // 2.创建URL
    NSString *str = [NSString stringWithFormat:@"http://agent.xinyuntec.com/admin/comment#/article_show/%@",self.ID];
    NSURL *url = [NSURL URLWithString:str];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [self.webView loadRequest:request];
    self.webView.delegate= self;
    self.webView.tag = 1314;

    // 5.最后将webView添加到界面
    [self.view addSubview:self.webView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
