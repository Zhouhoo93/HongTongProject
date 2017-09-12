//
//  AlarmViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "AlarmViewController.h"
#import "OneScrollViewBar.h"
#import "SecondTwoTableViewCell.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "AlarmPopView.h"
#import "ZYSideSlipFilterController.h"
#import "ZYSideSlipFilterRegionModel.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "PriceRangeModel.h"
#import "SideSlipCommonTableViewCell.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "AlarmListModel.h"
#import "addPosListModel.h"
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface AlarmViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate,UpdateAlertDelegate>
@property (strong, nonatomic) ZYSideSlipFilterController *filterController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *OneView;
@property (nonatomic,strong) UIView *TwoView;
@property (nonatomic,strong) UIView *ThreeView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) OneScrollViewBar *scroView;
@property (nonatomic ,strong)MenuView      *menu;
@property (nonatomic ,strong)AlarmPopView      *popView;

@property (nonatomic,copy) NSString *grade;
@property (nonatomic,strong)NSMutableArray *provinceArr;
@property (nonatomic,strong)NSMutableArray *cityArr;
@property (nonatomic,strong)NSMutableArray *townArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)NSMutableArray *dataArr2;
@property (nonatomic,strong)NSMutableArray *dataArr3;
@property (nonatomic,strong)NSMutableArray *addressArr0;
@property (nonatomic,strong)NSMutableArray *addressArr1;
@property (nonatomic,strong)NSMutableArray *addressArr2;
@property (nonatomic,strong)NSMutableArray *addressArr3;
@property (nonatomic,strong)AlarmListModel *model;
@property (nonatomic,strong)addPosListModel *addmodel;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *position;
@property (nonatomic,strong) UIButton *timeSelectBtn;
@property (nonatomic,strong) UIButton *timeSelectBtn1;
@property (nonatomic,strong) UIButton *timeSelectBtn2;
@property (nonatomic,strong) UIButton *timeSelectBtn3;
@property (nonatomic,copy) NSString *timeBtn;
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSegmentMenu];
    [self setMenu];
    [self CreatPopView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress:) name:@"changeAddress" object:nil];
    // Do any additional setup after loading the view.
    
}

- (void)setMenu{
    
    self.filterController = [[ZYSideSlipFilterController alloc] initWithSponsor:self
                                                                     resetBlock:^(NSArray *dataList) {
                                                                         for (ZYSideSlipFilterRegionModel *model in dataList) {
                                                                             //selectedStatus
                                                                             for (CommonItemModel *itemModel in model.itemList) {
                                                                                 [itemModel setSelected:NO];
                                                                             }
                                                                             //selectedItem
                                                                             model.selectedItemList = nil;
                                                                         }
                                                                     }                                                               commitBlock:^(NSArray *dataList) {
                                                                         [self requestAlarmData];                                                                                      //Common Region
                                                                         NSMutableString *commonRegionString = [NSMutableString string];
                                                                         for (int i = 0; i < dataList.count; i ++) {
                                                                             ZYSideSlipFilterRegionModel *commonRegionModel = dataList[i];
                                                                             [commonRegionString appendFormat:@"\n%@:", commonRegionModel.regionTitle];
                                                                             NSMutableArray *commonItemSelectedArray = [NSMutableArray array];
                                                                             for (CommonItemModel *itemModel in commonRegionModel.itemList) {
                                                                                 if (itemModel.selected) {
                                                                                     [commonItemSelectedArray addObject:[NSString stringWithFormat:@"%@-%@", itemModel.itemId, itemModel.itemName]];
                                                                                     if (i==0) {
                                                                                         self.province = itemModel.itemName;
                                                                                     }else if (i==1){
                                                                                         self.city = itemModel.itemName;
                                                                                     }else if (i==2){
                                                                                         self.town = itemModel.itemName;
                                                                                     }else if (i==3){
                                                                                         self.address = itemModel.itemName;
                                                                                     }
                                                                                 }
                                                                             }
                                                                             [commonRegionString appendString:[commonItemSelectedArray componentsJoinedByString:@", "]];
                                                                         }
                                                                         NSLog(@"%@", commonRegionString);
                                                                         [_filterController dismiss];
                                                                     }];
    _filterController.animationDuration = .3f;
    _filterController.sideSlipLeading = 0.15*[UIScreen mainScreen].bounds.size.width;
    _filterController.dataList = [self packageDataList];
}

- (void)CreatPopView{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"AlarmPopView" owner:nil options:nil];
    self.popView = [nibContents lastObject];
    self.popView.frame = CGRectMake(0, 0, KWidth, KHeight);
    self.popView.delegate = self;
    [self.view addSubview:self.popView];
    self.popView.hidden = YES;
}

- (void)cancelBtnClick{
    self.popView.hidden = YES;
}

- (void)changeAddress:(NSNotification *)notification{
    
    NSLog(@"接受到通知，改变地址:%@",notification);
    
    NSDictionary *dic = notification.userInfo;
    if ([dic[@"grade"] isEqualToString:@"province"]) {
        self.grade = @"city";
        self.city = dic[@"province"];
        [self requestShaiXuanData];
        
    }else if ([dic[@"grade"] isEqualToString:@"city"]) {
        self.grade = @"town";
        self.town = dic[@"city"];
        [self requestShaiXuanData];
        
    }else if ([dic[@"grade"] isEqualToString:@"town"]) {
        self.grade = @"address";
        self.address = dic[@"town"];
        [self requestShaiXuanData];
        
    }else if ([dic[@"grade"] isEqualToString:@"address"]) {
        self.grade = @"province";
        self.address = dic[@"address"];
    }
}


-(void)bohaoBtnClick{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:18813189235"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)xinxiBtnClick{
    NSURL *url = [NSURL URLWithString:@"sms://18813189235"];
    
    [[UIApplication sharedApplication] openURL:url];
    
    
}

-(void)daohangBtnClick{
    [self mapBtnClick];
}

-(void)weichuliBtnClick{
    self.status = @"未处理";
    [self putStatus];
}

-(void)chulizhongBtnClick{
    self.status = @"处理中";
    [self putStatus];
}

-(void)yichuliBtnClick{
    self.status = @"已处理";
    [self putStatus];
    
}
- (void)createSegmentMenu{
    
    //数据源
    NSArray *array = @[@"全部",@"未处理",@"处理中",@"已处理"];
    
    _scroView = [OneScrollViewBar setTabBarPoint:CGPointMake(0, 0)];
    [_scroView setData:array NormalColor
                      :kColor(16, 16, 16) SelectColor
                      :[UIColor whiteColor] Font
                      :[UIFont systemFontOfSize:15]];
    
    
    [self.view addSubview:_scroView];
    
    //设置默认值
    [OneScrollViewBar setViewIndex:0];
    
    
    //TabBar回调
    [_scroView getViewIndex:^(NSString *title, NSInteger index) {
        
        NSLog(@"title:%@ - index:%li",title,index);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(index * Bound_Width, 0);
        }];
        
        /***********************【回调】***********************/
        //
        //         如果是tabbleView。这里可以写刷新操作
        //
        /***********************【回调】***********************/
    }];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:leftBtn];
    
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, Bound_Width, Bound_Height - 108)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*Bound_Width, 0);
    [self.view addSubview:self.scrollView];
    
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            self.AllView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.AllView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.AllView];
        }else if (i==1){
            self.OneView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.OneView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.OneView];
        }else if(i==2){
            self.TwoView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.TwoView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.TwoView];
        }else{
            self.ThreeView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.ThreeView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.ThreeView];
        }
        
    }
    [self setTopButton];
    
}

-(void)backBtnClick{
    _scroView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopButton{
    for (int j=0; j<4; j++) {
        
        for (int i=0; i<4; i++) {
            
            if (i==0) {
                UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-20"] forState:0];
                [topButton setTitle:@"     排 序" forState:0];
                [topButton setTitleColor:[UIColor whiteColor] forState:0];
                topButton.titleLabel.font = [UIFont systemFontOfSize:14];
                if (j==0) {
                    [self.AllView addSubview:topButton];
                }else if(j==1){
                    [self.OneView addSubview:topButton];
                }else if(j==2){
                    [self.TwoView addSubview:topButton];
                }else{
                    [self.ThreeView addSubview:topButton];
                }
                
            }else if (i==1){
                if (j==0) {
                    self.timeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn];
                    }else if(j==1){
                        [self.OneView addSubview:self.timeSelectBtn];
                    }else if(j==2){
                        [self.TwoView addSubview:self.timeSelectBtn];
                    }else{
                        [self.ThreeView addSubview:self.timeSelectBtn];
                    }
                    
                }else if (j==1){
                    self.timeSelectBtn1 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn1 setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn1 setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn1 addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn1 setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn1];
                    }else if(j==1){
                        [self.OneView addSubview:self.timeSelectBtn1];
                    }else if(j==2){
                        [self.TwoView addSubview:self.timeSelectBtn1];
                    }else{
                        [self.ThreeView addSubview:self.timeSelectBtn1];
                        
                    }
                }else if(j==2){
                    self.timeSelectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn2 setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn2 setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn2 addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn2 setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn2];
                    }else if(j==1){
                        [self.OneView addSubview:self.timeSelectBtn2];
                    }else if(j==2){
                        [self.TwoView addSubview:self.timeSelectBtn2];
                    }else{
                        [self.ThreeView addSubview:self.timeSelectBtn2];
                    }
                }else{
                    self.timeSelectBtn3 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                    [self.timeSelectBtn3 setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                    [self.timeSelectBtn3 setTitle:@"     今 日" forState:0];
                    [self.timeSelectBtn3 addTarget:self action:@selector(shijianBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [self.timeSelectBtn3 setTitleColor:[UIColor whiteColor] forState:0];
                    self.timeSelectBtn3.titleLabel.font = [UIFont systemFontOfSize:14];
                    if (j==0) {
                        [self.AllView addSubview:self.timeSelectBtn3];
                    }else if(j==1){
                        [self.OneView addSubview:self.timeSelectBtn3];
                    }else if(j==2){
                        [self.TwoView addSubview:self.timeSelectBtn3];
                    }else{
                        [self.ThreeView addSubview:self.timeSelectBtn3];
                    }
                    
                }
                
            }else{
                UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-19"] forState:0];
                [topButton setTitle:@"     筛 选" forState:0];
                [topButton addTarget:self action:@selector(ShaiXuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [topButton setTitleColor:[UIColor whiteColor] forState:0];
                topButton.titleLabel.font = [UIFont systemFontOfSize:14];
                if (j==0) {
                    [self.AllView addSubview:topButton];
                }else if(j==1){
                    [self.OneView addSubview:topButton];
                }else if(j==2){
                    [self.TwoView addSubview:topButton];
                }else{
                    [self.ThreeView addSubview:topButton];
                }
                
            }
        }
    }
    [self setTableView];
}

- (void)shijianBtnClick{
    UIActionSheet *actionsheet03 = [[UIActionSheet alloc] initWithTitle:@"选择时间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"今日", @"本月",@"本年",  nil];
    // 显示
    [actionsheet03 showInView:self.view];
    
}
// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex=%ld", buttonIndex);
    
    
    if (0 == buttonIndex)
    {
        NSLog(@"点击了小戴按钮");
        self.timeBtn = @"今日";
        [self.timeSelectBtn setTitle:@"     今 日" forState:0];
        [self.timeSelectBtn1 setTitle:@"     今 日" forState:0];
        [self.timeSelectBtn2 setTitle:@"     今 日" forState:0];
        [self requestAlarmData];
    }
    else if (1 == buttonIndex)
    {
        NSLog(@"点击了中带按钮");
        self.timeBtn = @"本月";
        [self.timeSelectBtn setTitle:@"     本 月" forState:0];
        [self.timeSelectBtn1 setTitle:@"     本 月" forState:0];
        [self.timeSelectBtn2 setTitle:@"     本 月" forState:0];
        [self requestAlarmData];
    }
    else if (2 == buttonIndex)
    {
        NSLog(@"点击了大袋按钮");
        self.timeBtn = @"本年";
        [self.timeSelectBtn setTitle:@"     本 年" forState:0];
        [self.timeSelectBtn1 setTitle:@"     本 年" forState:0];
        [self.timeSelectBtn2 setTitle:@"     本 年" forState:0];
        [self requestAlarmData];
    }else if (3 == buttonIndex)
    {
        NSLog(@"点击了取消按钮");
    }
    
}


- (void)ShaiXuanBtnClick{
    self.grade = @"province";
    [self requestShaiXuanData];
    [_filterController show];
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    NSString *tagstr = [NSString stringWithFormat:@"%d",tag];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:tagstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


- (void)setTableView{
    for (int i=0; i<4; i++) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KWidth, 300)];
        bgImage.userInteractionEnabled = YES;
        bgImage.image = [UIImage imageNamed:@"首页背景框"];
        if (i==0) {
            [self.AllView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipViewTwo" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            
            self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table.backgroundColor = [UIColor clearColor];
            self.table.delegate = self;
            self.table.dataSource = self;
            self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table];
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table.mj_header = header;
            self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
            
        }else if (i==1){
            [self.OneView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipViewTwo" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            
            self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table1.backgroundColor = [UIColor clearColor];
            self.table1.delegate = self;
            self.table1.dataSource = self;
            self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table1];
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table1.mj_header = header;
            self.table1.mj_header.ignoredScrollViewContentInsetTop = self.table1.contentInset.top;
            
        }else if(i==2){
            [self.TwoView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipViewTwo" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            
            self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table2.backgroundColor = [UIColor clearColor];
            self.table2.delegate = self;
            self.table2.dataSource = self;
            self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table2];
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table2.mj_header = header;
            self.table2.mj_header.ignoredScrollViewContentInsetTop = self.table2.contentInset.top;
            
        }else{
            [self.ThreeView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableTipViewTwo" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            
            self.table3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table3.backgroundColor = [UIColor clearColor];
            self.table3.delegate = self;
            self.table3.dataSource = self;
            self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
            [bgImage addSubview:self.table3];
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table3.mj_header = header;
            self.table3.mj_header.ignoredScrollViewContentInsetTop = self.table3.contentInset.top;
            
        }
        
        
    }
    [self requestAlarmData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count  ;
    if (tableView==self.table) {
        count = _dataArr.count;
    }else if (tableView==self.table1){
        count =  _dataArr1.count;
    }else if (tableView==self.table2){
        count =  _dataArr2.count;
    }else {
        count =  _dataArr3.count;
    }
    return count;
}
- (void)refresh{
    [self requestAlarmData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"SecondTwoTableViewCell";
    // 2.从缓存池中取出cell
    SecondTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SecondTwoTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        if (tableView==self.table) {
            _model = _dataArr[indexPath.row];
        }else if (tableView == self.table1){
            _model = _dataArr1[indexPath.row];
        }else if (tableView == self.table2){
            _model = _dataArr2[indexPath.row];
        }else if (tableView == self.table3){
            _model = _dataArr3[indexPath.row];
        }
        
        cell.houseID.text = _model.home;
        cell.statusLabel.text = _model.nature;
        cell.reasonLabel.text = _model.cause;
        cell.happendTime.text = _model.happen_time;
        if ([_model.nature isEqualToString:@"离线"]) {
            cell.onLineLabel.text = @"离线";
        }else {
            cell.onLineLabel.text = @"在线";
        }
        
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView ==_scrollView) {
        //scrollView
        NSInteger index = scrollView.contentOffset.x / Bound_Width;
        //设置Bar的移动位置
        [OneScrollViewBar setViewIndex:index];
        [self.scroView setlineFrame:index];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.table) {
        _model = self.dataArr[indexPath.row];
        _addmodel = self.addressArr0[indexPath.row];
    }else if (tableView==self.table1){
        _model = self.dataArr1[indexPath.row];
        _addmodel = self.addressArr1[indexPath.row];
    }else if (tableView==self.table2){
        _model = self.dataArr2[indexPath.row];
        _addmodel = self.addressArr2[indexPath.row];
    }else if (tableView==self.table3){
        _model = self.dataArr3[indexPath.row];
        _addmodel = self.addressArr3[indexPath.row];
    }
    self.position = _addmodel.position;
    self.ID = _model.ID;
    self.popView.huhaoLabel.text = _model.home;
    self.popView.telLabel.text = _model.tel;
    self.popView.addressLabel.text = _addmodel.area;
    self.popView.xiangqingLabel.text = _model.cause;
    self.popView.zhuangtaiLabel.text = _model.nature;
    self.popView.gonglvLabel.text = _model.power;
    self.popView.fadianliangLabel.text = _model.ele_gen;
    if ([_model.nature isEqualToString:@"离线"]) {
        self.popView.zaixianLabel.text = @"离线";
        self.popView.zaixianLabel.textColor = [UIColor redColor];
    }else{
        self.popView.zaixianLabel.text = @"在线";
        self.popView.zaixianLabel.textColor = [UIColor greenColor];
        
    }
    
    self.popView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 模拟数据源
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"省" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"市" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"区(乡镇)" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"街道" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"发电方式" selectionType:BrandTableViewCellSelectionTypeSingle]];
    
    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    if ([keyword isEqualToString:@"省"]) {
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.provinceArr.count; i++) {
            [dataArr addObject: [self createItemModelWithTitle:self.provinceArr[i][@"area"] itemId:[NSString stringWithFormat:@"%d",i+1000] selected:NO]];
        }
        model.itemList = dataArr;
    }else if([keyword isEqualToString:@"市"]){
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.cityArr.count; i++) {
            [dataArr addObject: [self createItemModelWithTitle:self.cityArr[i][@"area"] itemId:[NSString stringWithFormat:@"%d",i+2000] selected:NO]];
        }
        model.itemList = dataArr;
    }else if([keyword isEqualToString:@"区(乡镇)"]){
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.townArr.count; i++) {
            [dataArr addObject: [self createItemModelWithTitle:self.townArr[i][@"area"] itemId:[NSString stringWithFormat:@"%d",i+3000] selected:NO]];
        }
        model.itemList = dataArr;
        
    }else if([keyword isEqualToString:@"街道"]){
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.addressArr.count; i++) {
            [dataArr addObject: [self createItemModelWithTitle:self.addressArr[i][@"area"] itemId:[NSString stringWithFormat:@"%d",i+4000] selected:NO]];
        }
        model.itemList = dataArr;
        
    }else if([keyword isEqualToString:@"发电方式"]){
        model.itemList = @[[self createItemModelWithTitle:[NSString stringWithFormat:@"全额上网"] itemId:@"0000" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"余电上网"] itemId:@"0001" selected:NO]
                           ];
    }
    
    return model;
}

- (CommonItemModel *)createItemModelWithTitle:(NSString *)itemTitle
                                       itemId:(NSString *)itemId
                                     selected:(BOOL)selected {
    CommonItemModel *model = [[CommonItemModel alloc] init];
    model.itemId = itemId;
    model.itemName = itemTitle;
    model.selected = selected;
    return model;
}

- (ZYSideSlipFilterRegionModel *)spaceFilterRegionModel {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipSpaceTableViewCell";
    return model;
}



- (AddressModel *)createAddressModelWithAddress:(NSString *)address addressId:(NSString *)addressId {
    AddressModel *model = [[AddressModel alloc] init];
    model.addressString = address;
    model.addressId = addressId;
    return model;
}
- (void)mapBtnClick{
    NSArray *newArray3 = [self.position componentsSeparatedByString:@","];
    BOOL hasBaiduMap = NO;
    BOOL hasGaodeMap = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        hasBaiduMap = YES;
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }
    
    
    if (hasBaiduMap)
    {
        //        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",currentLat, currentLon,_shopLat,_shopLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:30.833708884292438,119.9267578125|name:我的位置&destination=latlng:%@,%@|name:终点&mode=driving",newArray3[0],newArray3[1]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else if (hasGaodeMap)
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%@&lon=%@&dev=1&style=2",@"红彤代理端", @"123123123", @"终点",newArray3[0],newArray3[1]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else{
        [MBProgressHUD showText:@"请先安装百度地图或者高德地图"];
    }
}

-(void)requestAlarmData{
    for (int i=0; i<4; i++) {
        NSString *URL = [NSString stringWithFormat:@"%@/subscribe/show",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:@"20" forKey:@"limit"];
        if (i==0) {
            
        }else if(i==1){
            [parameters setValue:@"未处理" forKey:@"status"];
        }else if(i==2){
            [parameters setValue:@"处理中" forKey:@"status"];
        }else if(i==3){
            [parameters setValue:@"已处理" forKey:@"status"];
        }
        if (self.grade.length>0) {
            [parameters setValue:self.grade forKey:@"grade"];
        }
        if ([self.grade isEqualToString:@"address"] ) {
            [parameters setValue:self.town forKey:@"area"];
        }else if ([self.grade isEqualToString:@"town"] ) {
            [parameters setValue:self.city forKey:@"area"];
        }else if ([self.grade isEqualToString:@"city"] ) {
            [parameters setValue:self.province forKey:@"area"];
        }else if ([self.grade isEqualToString:@"province"] ) {
            [parameters setValue:self.address forKey:@"area"];
        }
        
        if (self.timeBtn.length>0) {
            [parameters setValue:self.timeBtn forKey:@"time"];
        }
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%d获取报警列表正确%@",i,responseObject);
            
            if ([responseObject[@"result"][@"success"] intValue] ==0) {
                NSNumber *code = responseObject[@"result"][@"errorCode"];
                NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                    [MBProgressHUD showText:@"请重新登陆"];
                    [self newLogin];
                }else{
                    NSString *str = responseObject[@"result"][@"errorMsg"];
                    [MBProgressHUD showText:str];
                }
            }else{
                if (i==0) {
                    [self.dataArr removeAllObjects];
                    for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                        _model = [[AlarmListModel alloc] initWithDictionary:dic];
                        [self.dataArr addObject:_model];
                    }
                    [self.table reloadData];
                }else if (i==1){
                    [self.dataArr1 removeAllObjects];
                    for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                        _model = [[AlarmListModel alloc] initWithDictionary:dic];
                        [self.dataArr1 addObject:_model];
                    }
                    [self.table1 reloadData];
                }else if (i==2){
                    [self.dataArr2 removeAllObjects];
                    for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                        _model = [[AlarmListModel alloc] initWithDictionary:dic];
                        [self.dataArr2 addObject:_model];
                    }
                    [self.table2 reloadData];
                }else if (i==3){
                    [self.dataArr3 removeAllObjects];
                    for (NSMutableDictionary *dic in responseObject[@"content"][@"data"]) {
                        _model = [[AlarmListModel alloc] initWithDictionary:dic];
                        [self.dataArr3 addObject:_model];
                    }
                    [self.table3 reloadData];
                }
                
                
            }
            if (_table.mj_header.isRefreshing ) {
                [_table.mj_header endRefreshing];
            }
            if (_table1.mj_header.isRefreshing ) {
                [_table1.mj_header endRefreshing];
            }
            if (_table2.mj_header.isRefreshing ) {
                [_table2.mj_header endRefreshing];
            }
            if (_table3.mj_header.isRefreshing ) {
                [_table3.mj_header endRefreshing];
            }
            
            [self requestAddListData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
        
    }
    
    
}

-(void)putStatus{
    NSString *URL = [NSString stringWithFormat:@"%@/update/status",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.status forKey:@"status"];
    [parameters setValue:self.ID forKey:@"id"];
    [manager PUT:URL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改状态正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            [MBProgressHUD showText:@"修改成功"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
    }];
}

- (void)requestShaiXuanData{
    NSString *URL = [NSString stringWithFormat:@"%@/getArea",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.grade forKey:@"grade"];
    if ([self.grade isEqualToString:@"province"]) {
        //        [parameters setValue:self.province forKey:@"province"];
    }else if ([self.grade isEqualToString:@"city"]) {
        [parameters setValue:self.city forKey:@"province"];
    }else if ([self.grade isEqualToString:@"town"]) {
        [parameters setValue:self.town forKey:@"city"];
    }else if ([self.grade isEqualToString:@"address"]) {
        [parameters setValue:self.address forKey:@"town"];
    }
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取地址列表正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            if ([self.grade isEqualToString:@"province"]) {
                self.provinceArr = responseObject[@"content"];
                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"city"]){
                self.cityArr = responseObject[@"content"];
                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"town"]){
                self.townArr = responseObject[@"content"];
                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"address"]){
                self.addressArr = responseObject[@"content"];
                _filterController.dataList = [self packageDataList];
            }
            [_filterController.mainTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}

- (void)requestAddListData{
    for (int i=0; i<4; i++) {
        if (i==0) {
            for (int i=0; i<self.dataArr.count; i++) {
                _model = self.dataArr[i];
                NSString *URL = [NSString stringWithFormat:@"%@/getAddress/%@",kUrl,_model.addr];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [userDefaults valueForKey:@"token"];
                [userDefaults synchronize];
                [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
                [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"获取对应地址列表正确%@",responseObject);
                    if ([responseObject[@"result"][@"success"] intValue] ==0) {
                        NSNumber *code = responseObject[@"result"][@"errorCode"];
                        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                        if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                            [MBProgressHUD showText:@"请重新登陆"];
                            [self newLogin];
                        }else{
                            NSString *str = responseObject[@"result"][@"errorMsg"];
                            [MBProgressHUD showText:str];
                        }
                    }else{
                        //                        NSArray *arr = responseObject[@"content"];
                        //                        if (arr.count>0) {
                        //                            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                        //                                _addmodel = [[addPosListModel alloc] initWithDictionary:dic];
                        //                                [self.addressArr0 addObject:_addmodel];
                        //                            }
                        //                        }
                        NSString *area=responseObject[@"content"][@"area"];
                        NSString *position=responseObject[@"content"][@"position"];
                        NSLog(@"%@ %@",area,position);
                        self.addmodel.area = area;
                        self.addmodel.position = position;
                        [self.addressArr0 addObject:_addmodel];
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"失败%@",error);
                    //        [MBProgressHUD showText:@"%@",error[@"error"]];
                }];
                
            }
        }else if (i==1){
            for (int i=0; i<self.dataArr1.count; i++) {
                _model = self.dataArr1[i];
                NSString *URL = [NSString stringWithFormat:@"%@/getAddress/%@",kUrl,_model.addr];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [userDefaults valueForKey:@"token"];
                [userDefaults synchronize];
                [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
                [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"获取对应地址列表正确%@",responseObject);
                    if ([responseObject[@"result"][@"success"] intValue] ==0) {
                        NSNumber *code = responseObject[@"result"][@"errorCode"];
                        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                        if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                            [MBProgressHUD showText:@"请重新登陆"];
                            [self newLogin];
                        }else{
                            NSString *str = responseObject[@"result"][@"errorMsg"];
                            [MBProgressHUD showText:str];
                        }
                    }else{
                        //                        NSArray *arr = responseObject[@"content"];
                        //                        if (arr.count>0) {
                        //                        for (NSMutableDictionary *dic in responseObject[@"content"]) {
                        //                            _addmodel = [[addPosListModel alloc] initWithDictionary:dic];
                        //                            [self.addressArr1 addObject:_addmodel];
                        //                        }
                        //                        }
                        NSString *area=responseObject[@"content"][@"area"];
                        NSString *position=responseObject[@"content"][@"position"];
                        NSLog(@"%@ %@",area,position);
                        self.addmodel.area = area;
                        self.addmodel.position = position;
                        
                        [self.addressArr1 addObject:_addmodel];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"失败%@",error);
                    //        [MBProgressHUD showText:@"%@",error[@"error"]];
                }];
                
            }
            
        }else if (i==2){
            for (int i=0; i<self.dataArr2.count; i++) {
                _model = self.dataArr2[i];
                NSString *URL = [NSString stringWithFormat:@"%@/getAddress/%@",kUrl,_model.addr];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [userDefaults valueForKey:@"token"];
                [userDefaults synchronize];
                [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
                [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"获取对应地址列表正确%@",responseObject);
                    if ([responseObject[@"result"][@"success"] intValue] ==0) {
                        NSNumber *code = responseObject[@"result"][@"errorCode"];
                        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                        if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                            [MBProgressHUD showText:@"请重新登陆"];
                            [self newLogin];
                        }else{
                            NSString *str = responseObject[@"result"][@"errorMsg"];
                            [MBProgressHUD showText:str];
                        }
                    }else{
                        //                        NSArray *arr = responseObject[@"content"];
                        //                        if (arr.count>0) {
                        //                        for (NSMutableDictionary *dic in responseObject[@"content"]) {
                        //                            _addmodel = [[addPosListModel alloc] initWithDictionary:dic];
                        //                            [self.addressArr2 addObject:_addmodel];
                        //                        }
                        //                        }
                        NSString *area=responseObject[@"content"][@"area"];
                        NSString *position=responseObject[@"content"][@"position"];
                        NSLog(@"%@ %@",area,position);
                        self.addmodel.area = area;
                        self.addmodel.position = position;
                        
                        [self.addressArr2 addObject:_addmodel];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"失败%@",error);
                    //        [MBProgressHUD showText:@"%@",error[@"error"]];
                }];
                
            }
            
        }else if (i==3){
            for (int i=0; i<self.dataArr3.count; i++) {
                _model = self.dataArr3[i];
                NSString *URL = [NSString stringWithFormat:@"%@/getAddress/%@",kUrl,_model.addr];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [userDefaults valueForKey:@"token"];
                [userDefaults synchronize];
                [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
                [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"获取对应地址列表正确%@",responseObject);
                    if ([responseObject[@"result"][@"success"] intValue] ==0) {
                        NSNumber *code = responseObject[@"result"][@"errorCode"];
                        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
                        if ([errorcode isEqualToString:@"4100"]||[errorcode isEqualToString:@"3100"])  {
                            [MBProgressHUD showText:@"请重新登陆"];
                            [self newLogin];
                        }else{
                            NSString *str = responseObject[@"result"][@"errorMsg"];
                            [MBProgressHUD showText:str];
                        }
                    }else{
                        //                        NSArray *arr = responseObject[@"content"];
                        //                        if (arr.count>0) {
                        //                        for (NSMutableDictionary *dic in responseObject[@"content"]) {
                        //                            _addmodel = [[addPosListModel alloc] initWithDictionary:dic];
                        //                            [self.addressArr3 addObject:_addmodel];
                        //                        }
                        //                        }
                        NSString *area=responseObject[@"content"][@"area"];
                        NSString *position=responseObject[@"content"][@"position"];
                        NSLog(@"%@ %@",area,position);
                        self.addmodel.area = area;
                        self.addmodel.position = position;
                        [self.addressArr3 addObject:_addmodel];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"失败%@",error);
                    //        [MBProgressHUD showText:@"%@",error[@"error"]];
                }];
                
            }
            
        }
        
    }
    
    
}

- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}
-(void)backTo{
    [self clearLocalData];
    //    LoginViewController *VC =[[LoginViewController alloc] init];
    //    VC.hidesBottomBarWhenPushed = YES;
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    //    app2.window.rootViewController = VC;
    //    [self.navigationController pushViewController:VC animated:YES];
    LoginOneViewController *loginViewController = [[LoginOneViewController alloc] initWithNibName:@"LoginOneViewController" bundle:nil];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    app2.window.rootViewController = navigationController;
}
- (void)clearLocalData{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:nil forKey:@"phone"];
    [userDefaults setValue:nil forKey:@"passWord"];
    [userDefaults setValue:nil forKey:@"token"];
    //    [userDefaults setValue:nil forKey:@"registerid"];
    [userDefaults synchronize];
    
}
-(AlarmListModel *)model{
    if (!_model) {
        _model = [[AlarmListModel alloc] init];
    }
    return _model;
}
-(addPosListModel *)addmodel{
    if (!_addmodel) {
        _addmodel = [[addPosListModel alloc] init];
    }
    return _addmodel;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArr1{
    if (!_dataArr1) {
        _dataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr1;
}
-(NSMutableArray *)dataArr2{
    if (!_dataArr2) {
        _dataArr2 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr2;
}
-(NSMutableArray *)dataArr3{
    if (!_dataArr3) {
        _dataArr3 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr3;
}
-(NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _provinceArr;
}
-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cityArr;
}
-(NSMutableArray *)townArr{
    if (!_townArr) {
        _townArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _townArr;
}
-(NSMutableArray *)addressArr{
    if (!_addressArr) {
        _addressArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr;
}
-(NSMutableArray *)addressArr0{
    if (!_addressArr0) {
        _addressArr0 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr0;
}
-(NSMutableArray *)addressArr1{
    if (!_addressArr1) {
        _addressArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr1;
}
-(NSMutableArray *)addressArr2{
    if (!_addressArr2) {
        _addressArr2 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr2;
}
-(NSMutableArray *)addressArr3{
    if (!_addressArr3) {
        _addressArr3 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressArr3;
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
