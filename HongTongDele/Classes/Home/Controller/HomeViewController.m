//
//  HomeViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *table;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self setTopView];
    // Do any additional setup after loading the view.
}

- (void)setTopView{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight) style:UITableViewStylePlain];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.table.mj_header = header;
    self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64)];
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, KHeight-64);
    [self.table addSubview:self.bgScrollView];
    
    for (int i=0; i<3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
        if (i==0) {
            [btn setTitle:@"总公司" forState:UIControlStateNormal];
        }else if(i==1){
            [btn setTitle:@"分公司" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"运维小组" forState:UIControlStateNormal];
        }
        [btn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
        [self.bgScrollView addSubview:btn];
    }
    
    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"HomeOneTabel" owner:self options:nil]objectAtIndex:0];
    view.frame = CGRectMake(0, KHeight/667*55, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view];
    
    UIView *view1 = [[[NSBundle mainBundle]loadNibNamed:@"HomeTwoTabel" owner:self options:nil]objectAtIndex:0];
    view1.frame = CGRectMake(0, KHeight/667*185, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view1];
    
    UIView *view2 = [[[NSBundle mainBundle]loadNibNamed:@"HomeThreeTabel" owner:self options:nil]objectAtIndex:0];
    view2.frame = CGRectMake(0, KHeight/667*310, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view2];
    
    UIView *view3 = [[[NSBundle mainBundle]loadNibNamed:@"HomeFourTabel" owner:self options:nil]objectAtIndex:0];
    view3.frame = CGRectMake(0, KHeight/667*435, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view3];
}

- (void)refresh{
    [self.table.mj_header endRefreshing];
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
