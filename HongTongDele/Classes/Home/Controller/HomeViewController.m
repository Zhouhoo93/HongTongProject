//
//  HomeViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/9.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeOneView.h"
#import "HomeTwoView.h"
#import "SelectFenGongSiViewController.h"
#import "ZhuangtaiListZongViewController.h"
@interface HomeViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,NSTextLayoutOrientationProvider,TopButDelegate,TopButDelegate2>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIActionSheet *actionSheet;
@property (nonatomic,strong)UIActionSheet *actionSheet1;
@property (nonatomic,strong) UIButton *zonggongsibtn;
@property (nonatomic,strong) UIButton *fengongsibtn;
@property (nonatomic,strong) UIButton *yunweixiaozubtn;
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
        
        if (i==0) {
            self.zonggongsibtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.zonggongsibtn setTitle:@"总公司" forState:UIControlStateNormal];
            [self.zonggongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.zonggongsibtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.zonggongsibtn];
        }else if(i==1){
             self.fengongsibtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.fengongsibtn setTitle:@"分公司" forState:UIControlStateNormal];
            [self.fengongsibtn addTarget:self action:@selector(fenfongsiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.fengongsibtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.fengongsibtn];
        }else{
            self.yunweixiaozubtn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((KWidth-60)/3+20), 10, (KWidth-60)/3, 34)];
            [self.yunweixiaozubtn setTitle:@"运维小组" forState:UIControlStateNormal];
            [self.yunweixiaozubtn addTarget:self action:@selector(yunweiBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.yunweixiaozubtn setTitleColor:RGBColor(91, 202, 255) forState:UIControlStateNormal];
            [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top3"] forState:UIControlStateNormal];
            [self.bgScrollView addSubview:self.yunweixiaozubtn];
        }
       
    }
    
    HomeOneView *view = [[[NSBundle mainBundle]loadNibNamed:@"HomeOneTabel" owner:self options:nil]objectAtIndex:0];
    view.Topdelegate = self;
    view.frame = CGRectMake(0, KHeight/667*55, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view];
    
    HomeTwoView *view1 = [[[NSBundle mainBundle]loadNibNamed:@"HomeTwoTabel" owner:self options:nil]objectAtIndex:0];
    view1.Topdelegate = self;
    view1.frame = CGRectMake(0, KHeight/667*185, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view1];
    
    UIView *view2 = [[[NSBundle mainBundle]loadNibNamed:@"HomeThreeTabel" owner:self options:nil]objectAtIndex:0];
    view2.frame = CGRectMake(0, KHeight/667*310, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view2];
    
    UIView *view3 = [[[NSBundle mainBundle]loadNibNamed:@"HomeFourTabel" owner:self options:nil]objectAtIndex:0];
    view3.frame = CGRectMake(0, KHeight/667*435, KWidth, KHeight/667*120);
    [self.bgScrollView addSubview:view3];
}
//执行协议方法
- (void)transButIndex
{
    SelectFenGongSiViewController *vc = [[SelectFenGongSiViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)transButIndex2
{
    ZhuangtaiListZongViewController *vc = [[ZhuangtaiListZongViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)refresh{
    [self.table.mj_header endRefreshing];
}

- (void)fenfongsiBtnClick{
     self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分公司1" otherButtonTitles:@"分公司2",@"分公司3", nil];
    //这里的actionSheetStyle也可以不设置；
    self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet==self.actionSheet) {
        //按照按钮的顺序0-N；
        switch (buttonIndex) {
            case 0:
                NSLog(@"点击了分公司1");
                [self.fengongsibtn setTitle:@"分公司1" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 1:
                NSLog(@"点击了分公司2");
                [self.fengongsibtn setTitle:@"分公司2" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 2:
                NSLog(@"点击了分公司3");
                [self.fengongsibtn setTitle:@"分公司3" forState:UIControlStateNormal];
                [self.fengongsibtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.fengongsibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }else{
        //按照按钮的顺序0-N；
        switch (buttonIndex) {
            case 0:
                NSLog(@"点击了运维小组1");
                [self.fengongsibtn setTitle:@"运维小组1" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 1:
                NSLog(@"点击了运维小组2");
                [self.fengongsibtn setTitle:@"运维小组2" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
                
            case 2:
                NSLog(@"点击了运维小组3");
                [self.fengongsibtn setTitle:@"运维小组3" forState:UIControlStateNormal];
                [self.yunweixiaozubtn setBackgroundImage:[UIImage imageNamed:@"top2"] forState:UIControlStateNormal];
                [self.yunweixiaozubtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    
    
}
- (void)yunweiBtnClick{
    self.actionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"运维小组1" otherButtonTitles:@"运维小组2",@"运维小组3", nil];
    //这里的actionSheetStyle也可以不设置；
    self.actionSheet1.actionSheetStyle = UIActionSheetStyleAutomatic;
    [self.actionSheet1 showInView:self.view];
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
