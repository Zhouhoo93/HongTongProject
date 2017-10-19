//
//  ViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/3.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "ViewController.h"
#import "HomeSelectViewController.h"
#import "InstallViewController.h"
#import "ElectricityViewController.h"
#import "AlarmViewController.h"
#import "StationViewController.h"
#import "MainModel.h"
#import "AppDelegate.h"
#import "LoginOneViewController.h"
#import "MainModel.h"
#import <RongIMKit/RongIMKit.h>
#import "JHTableChart.h"
@interface ViewController ()<UIScrollViewDelegate,ChangeName>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIButton *selectBtn2;
@property (nonatomic,strong) UIButton *selectBtn3;
@property (nonatomic,strong) UIButton *selectBtn4;
@property (nonatomic,strong) UIButton *selectBtn5;
@property (nonatomic,strong) MainModel *model;
@property (nonatomic,strong) UILabel *downLabel; //总装机量
@property (nonatomic,strong) UILabel *rightTopLabel1; //全额上网
@property (nonatomic,strong) UILabel *rightDownLabel1; //余电上网
@property (nonatomic,strong) UILabel *fadianliang; //发电量
@property (nonatomic,strong) UILabel *shangwangdianliang; //上网电量
@property (nonatomic,strong) UILabel *zifaziyong; //自发自用
@property (nonatomic,strong) UILabel *pingjungonglv; //平均功率
@property (nonatomic,strong) UILabel *weichuliLabel;
@property (nonatomic,strong) UILabel *chulizhongLabel;
@property (nonatomic,strong) UILabel *yichuliLabel;
@property (nonatomic,strong) UILabel *zhengchangLabel;
@property (nonatomic,strong) UILabel *lixianLabel;
@property (nonatomic,strong) UILabel *yichangLabel;
@property (nonatomic,strong) UILabel *guzhangLabel;
@property (nonatomic,strong) UILabel *zaixianLabel;
@property (nonatomic,strong)NSMutableArray *provinceArr;
@property (nonatomic,strong)NSMutableArray *cityArr;
@property (nonatomic,strong)NSMutableArray *townArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *town;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UIImageView *imageHeader;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLive:) name:@"Live" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.grade = @"province";
    [self setUI];
    [self requestData];
    [self setUITwo];
    [self setUIThree];
    [self setUIFour];
    [self setUIFive];
    [self setUISix];
    [self getRongYunToken];
    [self requestShaiXuanData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jinru:) name:@"jinru" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)jinru:(NSNotification *)text{
//    [self refresh];
    [self.imageView removeFromSuperview];
    [self.imageHeader removeFromSuperview];
    [self setUISix];
}
- (void)gotoLive:(NSNotification *)text{
    NSLog(@"接收直播推送:%@",text);
    self.tabBarController.selectedIndex = 3;
//    NSNotification *notice = [NSNotification notificationWithName:@"OpenLive" object:text];
//    [[NSNotificationCenter defaultCenter] postNotification:notice];
}
- (void)refresh{
    [self requestData];
    [self requestAlarmData];
    [self requestStationData];
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    AlarmViewController *vc = [[AlarmViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"---接收到通知---");
    
}
- (void)setUI{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, KWidth, KHeight) style:UITableViewStylePlain];
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

    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, 1000);
    [self.table addSubview:self.bgScrollView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 66)];
    bgImage.image = [UIImage imageNamed:@"形状-3"];
    bgImage.userInteractionEnabled = YES;
    [self.table addSubview:bgImage];
    
    for (int i=0; i<5; i++) {
        if (i==0) {
            UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 30, (KWidth-100)/5, 24)];
            addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [addressBtn setTitleColor:[UIColor blackColor] forState:0];
            [addressBtn setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [addressBtn setTitle:@"全部" forState:0];
            addressBtn.tag = 10000;
            [addressBtn addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:addressBtn];
        }else if (i==1){
            self.selectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 30, (KWidth-100)/5, 24)];
            self.selectBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn2 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn2 setTitle:@"" forState:0];
            self.selectBtn2.tag = 10001;
            [self.selectBtn2 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn2];
        }else if (i==2){
            self.selectBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 30, (KWidth-100)/5, 24)];
            self.selectBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn3 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn3 setTitle:@"" forState:0];
            self.selectBtn3.tag = 10002;
            [self.selectBtn3 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn3];
        }else if(i==3){
            self.selectBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 30, (KWidth-100)/5, 24)];
            self.selectBtn4.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn4 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn4 setTitle:@"" forState:0];
            self.selectBtn4.tag = 10003;
            [self.selectBtn4 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn4];
        }else{
            self.selectBtn5 = [[UIButton alloc] initWithFrame:CGRectMake(16*(i+1)+(KWidth-100)/5*i, 30, (KWidth-100)/5, 24)];
            self.selectBtn5.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn5 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn5 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn5 setTitle:@"" forState:0];
            self.selectBtn5.tag = 10004;
            [self.selectBtn5 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn5];
        }
        
    }
    
    UIImageView *bgImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
    bgImage1.userInteractionEnabled = YES;
    bgImage1.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:bgImage1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2, 0, 1, 150)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgImage1 addSubview:line];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2, 75, KWidth/2, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgImage1 addSubview:line1];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,62 , 35, 25)];
    leftImage.image = [UIImage imageNamed:@"图层-13"];
    [bgImage1 addSubview:leftImage];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 55, KWidth/2-50, 20)];
    topLabel.text = @"总装机量/总户数";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:topLabel];
    self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, KWidth/2-50, 20)];
    self.downLabel.text = @" KW/ 户";
    self.downLabel.font = [UIFont systemFontOfSize:14];
    self.downLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.downLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 15, KWidth/2, 37)];
    rightTopLabel.text = @"全额上网/户数";
    rightTopLabel.font = [UIFont systemFontOfSize:14];
    rightTopLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightTopLabel];
    self.rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 38, KWidth/2, 37)];
    self.rightTopLabel1.text = @" KW/ 户";
    self.rightTopLabel1.font = [UIFont systemFontOfSize:14];
    self.rightTopLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.rightTopLabel1];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2,80, KWidth/2, 37)];
    rightDownLabel.text = @"余电上网/户数";
    rightDownLabel.font = [UIFont systemFontOfSize:14];
    rightDownLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightDownLabel];
    self.rightDownLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 103, KWidth/2, 37)];
    self.rightDownLabel1.text = @" KW/ 户";
    self.rightDownLabel1.font = [UIFont systemFontOfSize:14];
    self.rightDownLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.rightDownLabel1];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
    [button addTarget:self action:@selector(FirstBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImage1 addSubview:button];
    
    
}
- (void)selctBtnClick:(UIButton *)sender{
    if(sender.tag!=10000){
        
        HomeSelectViewController *vc = [[HomeSelectViewController alloc] init];
        if (sender.tag == 10001) {
            self.selectIndex  = 1;
            //            vc.dataArr = @[@"浙江省",@"河南省",@"江西省",@"河北省",@"山东省",@"福建省"];
            vc.dataArr = self.provinceArr;
        }else if (sender.tag == 10002) {
            self.selectIndex  = 2;
            self.selectBtn3.titleLabel.textColor = [UIColor blackColor];
           
            //            vc.dataArr = @[@"杭州江干",@"杭州下城",@"杭州拱墅",@"杭州滨江",@"杭州萧山",@"杭州西湖"];
            vc.dataArr = self.cityArr;
        }else if (sender.tag == 10003) {
            self.selectIndex  = 3;
            //            vc.dataArr = @[@"白杨街道",@"下沙街道",@"啊啊街道",@"啊啊街道",@"啊啊街道",@"没有街道"];
            vc.dataArr = self.townArr;
            self.selectBtn4.titleLabel.textColor = [UIColor blackColor];
        }else {
            self.selectIndex = 4;
            self.selectBtn5.titleLabel.textColor = [UIColor blackColor];
            vc.dataArr = self.addressArr;
        }
        vc.hidesBottomBarWhenPushed = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.selectBtn2.titleLabel.textColor = [UIColor grayColor];
        self.selectBtn3.titleLabel.textColor = [UIColor grayColor];
        self.selectBtn4.titleLabel.textColor = [UIColor grayColor];
        self.selectBtn5.titleLabel.textColor = [UIColor grayColor];
        self.city = @"";
        self.town = @"";
        self.address = @"";
        self.grade = @"city";
        [self.cityArr removeAllObjects];
        [self.townArr removeAllObjects];
        [self.addressArr removeAllObjects];
    }
}
//协议要实现的方法
-(void)changeName:(NSString *)string
{
    if(self.selectIndex==1){
        [self.selectBtn2 setTitle:string forState:0];
        [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.grade = @"city";
        self.province = string;
        [self requestShaiXuanData];
    }else if(self.selectIndex==2){
        [self.selectBtn3 setTitle:string forState:0];
        [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.grade = @"town";
        self.city = string;
        [self requestShaiXuanData];
    }else if (self.selectIndex ==3){
        [self.selectBtn4 setTitle:string forState:0];
        [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.town = string;
        self.grade = @"address";
        [self requestShaiXuanData];
    }else if (self.selectIndex ==4){
        self.address = string;
        [self.selectBtn5 setTitle:string forState:0];
        [self.selectBtn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn5 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.grade = @"province";
        //        [self requestShaiXuanData];
        [self refresh];
        
    }}
- (void)setUITwo{
    UIImageView *bgImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, KWidth, 150)];
    bgImage1.userInteractionEnabled = YES;
    bgImage1.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:bgImage1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2, 0, 1, 150)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgImage1 addSubview:line];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2, 75, KWidth/2, 1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgImage1 addSubview:line1];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(17,62 , 30, 25)];
    leftImage.image = [UIImage imageNamed:@"图层-16"];
    [bgImage1 addSubview:leftImage];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 55, KWidth/2-50, 20)];
    topLabel.text = @"今日发电量/收益";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:topLabel];
    self.fadianliang = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, KWidth/2-50, 40)];
    self.fadianliang.numberOfLines = 0;
    self.fadianliang.text = @" MW·h/ 元";
    self.fadianliang.font = [UIFont systemFontOfSize:14];
    self.fadianliang.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.fadianliang];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 15, KWidth/2, 37)];
    rightTopLabel.text = @"上网电量/现金收入";
    rightTopLabel.font = [UIFont systemFontOfSize:14];
    rightTopLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightTopLabel];
    self.shangwangdianliang = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 38, KWidth/2, 37)];
    self.shangwangdianliang.text = @" MW·h/ 元";
    self.shangwangdianliang.font = [UIFont systemFontOfSize:14];
    self.shangwangdianliang.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.shangwangdianliang];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2,80, KWidth/2, 37)];
    rightDownLabel.text = @"自发自用电量/价值";
    rightDownLabel.font = [UIFont systemFontOfSize:14];
    rightDownLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightDownLabel];
    self.zifaziyong = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 103, KWidth/2, 37)];
    self.zifaziyong.text = @" MW·h/ 元";
    self.zifaziyong.font = [UIFont systemFontOfSize:14];
    self.zifaziyong.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.zifaziyong];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
    [button addTarget:self action:@selector(SecondBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImage1 addSubview:button];
}

- (void)FirstBtnClick{
    InstallViewController *vc = [[InstallViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)SecondBtnClick{
    ElectricityViewController *vc = [[ElectricityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUIThree{
    UIImageView *bgImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 306, KWidth, 75)];
    bgImage1.userInteractionEnabled = YES;
    bgImage1.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:bgImage1];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,24 , 25, 25)];
    leftImage.image = [UIImage imageNamed:@"图层-23"];
    [bgImage1 addSubview:leftImage];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, KWidth/2, 35)];
    topLabel.text = @"今日平均功率/即时功率";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:topLabel];
    self.pingjungonglv = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2+50, 20, KWidth/2-50, 35)];
    self.pingjungonglv.text = @" KW/ KW";
    self.pingjungonglv.font = [UIFont systemFontOfSize:14];
    self.pingjungonglv.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.pingjungonglv];
    
    
}

- (void)setUIFour{
    UIImageView *imageHeader = [[UIImageView alloc] initWithFrame:CGRectMake(8, 396, 130, 20)];
    imageHeader.image = [UIImage imageNamed:@"圆角矩形-4"];
    [self.bgScrollView addSubview:imageHeader];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
    titleLabel.text = @"当前电站运行情况";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [imageHeader addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 409, KWidth, 130)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:imageView];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KWidth/5*2, 20)];
    leftLabel.text = @"监测设备";
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/5*2, 10, KWidth/5*3, 20)];
    rightLabel.text = @"逆变器";
    rightLabel.textColor = [UIColor grayColor];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:rightLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/5*2, 3, 1, 124)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [imageView addSubview:line];
    for (int i=0; i<5; i++) {
        
        
        if (i==0) {
            UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth/5*2-100)/3*(i+1)+50*i, 40, 50, 50)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((KWidth/5*2-100)/3*(i+1)+50*i, 40, 50, 50)];
            imagePic.image = [UIImage imageNamed:@"在线"];
            self.zaixianLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth/5*2-140)/3*(i+1)+70*i, 95,70, 20)];
            self.zaixianLabel.textAlignment = NSTextAlignmentCenter;
            self.zaixianLabel.textColor = RGBColor(35, 134, 2);
            self.zaixianLabel.text = @"";
            [imageView addSubview:self.zaixianLabel];
            [button addTarget:self action:@selector(zaixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imagePic];
            [imageView addSubview:button];
        }else if (i==1) {
            UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth/5*2-100)/3*(i+1)+50*i, 40, 50, 50)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((KWidth/5*2-100)/3*(i+1)+50*i, 40, 50, 50)];
            imagePic.image = [UIImage imageNamed:@"离线"];
            self.lixianLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth/5*2-140)/3*(i+1)+70*i, 95,70, 20)];
            self.lixianLabel.textAlignment = NSTextAlignmentCenter;
            self.lixianLabel.textColor = [UIColor lightGrayColor];
            self.lixianLabel.text = @"";
            [imageView addSubview:self.lixianLabel];
            [button addTarget:self action:@selector(lixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imagePic];
            [imageView addSubview:button];
        }else if (i==2) {
            UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            self.zhengchangLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-210)/4*(i-2+1)+70*(i-2)), 95,70, 20)];
            self.zhengchangLabel.textAlignment = NSTextAlignmentCenter;
            imagePic.image = [UIImage imageNamed:@"正常"];
            self.zhengchangLabel.textColor = RGBColor(35, 134, 2);
            self.zhengchangLabel.text = @"";
            [imageView addSubview:self.zhengchangLabel];
            [button addTarget:self action:@selector(zhengchangBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imagePic];
            [imageView addSubview:button];
        }else if(i==3){
            UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            self.yichangLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-210)/4*(i-2+1)+70*(i-2)), 95,70, 20)];
            self.yichangLabel.textAlignment = NSTextAlignmentCenter;
            imagePic.image = [UIImage imageNamed:@"异常"];
            self.yichangLabel.textColor = RGBColor(255, 219, 37);
            self.yichangLabel.text = @"";
            [imageView addSubview:self.yichangLabel];
            [button addTarget:self action:@selector(yichangBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imagePic];
            [imageView addSubview:button];
        }else{
            UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-150)/4*(i-2+1)+50*(i-2)), 40, 50, 50)];
            self.guzhangLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/5*2+((KWidth/5*3-210)/4*(i-2+1)+70*(i-2)), 95,70, 20)];
            self.guzhangLabel.textAlignment = NSTextAlignmentCenter;
            imagePic.image = [UIImage imageNamed:@"故障"];
            self.guzhangLabel.textColor = [UIColor redColor];
            self.guzhangLabel.text = @"";
            [imageView addSubview:self.guzhangLabel];
            [button addTarget:self action:@selector(guzhangBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:imagePic];
            [imageView addSubview:button];

        }
       
    }
    [self requestStationData];
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
    //    [button addTarget:self action:@selector(FourBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [imageView addSubview:button];
    
}

- (void)zaixianBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    vc.index = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)zhengchangBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    vc.index = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)lixianBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    vc.index = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)yichangBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    vc.index = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)guzhangBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    vc.index = @"4";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUIFive{
    UIImageView *imageHeader = [[UIImageView alloc] initWithFrame:CGRectMake(8, 541, 70, 20)];
    imageHeader.image = [UIImage imageNamed:@"圆角矩形-4"];
    [self.bgScrollView addSubview:imageHeader];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    titleLabel.text = @"报警信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [imageHeader addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 554, KWidth, 120)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:imageView];
    
    for (int i=0; i<3; i++) {
        UIImageView *imagePic = [[UIImageView alloc] init];
        UIImageView *linePic = [[UIImageView alloc] init];
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            self.weichuliLabel = [[UILabel alloc] init];
            imagePic.frame = CGRectMake(30, 50, 30, 30);
            linePic.frame = CGRectMake(70, 65, KWidth/2-95, 3);
            linePic.image = [UIImage imageNamed:@"形状-6-拷贝-2"];
            imagePic.image = [UIImage imageNamed:@"未处理"];
            titlelabel.frame = CGRectMake(10, 10, 70, 30);
            self.weichuliLabel.frame = CGRectMake(10, 80, 70, 30);
            self.weichuliLabel.text = @"0条";
            self.weichuliLabel.textColor = [UIColor orangeColor];
            titlelabel.text = @"未处理";
            titlelabel.textColor = [UIColor lightGrayColor];
            titlelabel.font = [UIFont systemFontOfSize:12];
            self.weichuliLabel.font = [UIFont systemFontOfSize:12];
            self.weichuliLabel.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:imagePic];
            [imageView addSubview:linePic];
            [imageView addSubview:titlelabel];
            [imageView addSubview:self.weichuliLabel];
            
        }else if (i==1) {
            self.chulizhongLabel = [[UILabel alloc] init];
            imagePic.frame = CGRectMake(KWidth/2-15, 50, 30, 30);
            linePic.frame = CGRectMake(KWidth/2+25, 65, KWidth/2-95, 3);
            linePic.image = [UIImage imageNamed:@"形状-6-拷贝-2"];
            imagePic.image = [UIImage imageNamed:@"图层-18-拷贝"];
            titlelabel.frame = CGRectMake(KWidth/2-35, 10, 70, 30);
            self.chulizhongLabel.frame = CGRectMake(KWidth/2-35, 80, 70, 30);
            self.chulizhongLabel.text = @"0条";
            self.chulizhongLabel.textColor = RGBColor(35, 134, 2);
            titlelabel.text = @"处理中";
            titlelabel.textColor = [UIColor lightGrayColor];
            titlelabel.font = [UIFont systemFontOfSize:12];
            self.chulizhongLabel.font = [UIFont systemFontOfSize:12];
            self.chulizhongLabel.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:imagePic];
            [imageView addSubview:linePic];
            [imageView addSubview:titlelabel];
            [imageView addSubview:self.chulizhongLabel];
            
        }else if (i==2) {
            self.yichuliLabel = [[UILabel alloc] init];
            imagePic.frame = CGRectMake(KWidth-60, 50, 30, 30);
            imagePic.image = [UIImage imageNamed:@"图层-19-拷贝"];
            titlelabel.frame = CGRectMake(KWidth-80, 10, 70, 30);
            self.yichuliLabel.frame = CGRectMake(KWidth-80, 80, 70, 30);
            self.yichuliLabel.text = @"0条";
            self.yichuliLabel.textColor = [UIColor blueColor];
            titlelabel.text = @"已处理";
            titlelabel.textColor = [UIColor lightGrayColor];
            titlelabel.font = [UIFont systemFontOfSize:12];
            self.yichuliLabel.font = [UIFont systemFontOfSize:12];
            self.yichuliLabel.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:imagePic];
            [imageView addSubview:linePic];
            [imageView addSubview:titlelabel];
            [imageView addSubview:self.yichuliLabel];
            
        }
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 120)];
    [button addTarget:self action:@selector(AlarmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    [self requestAlarmData];
}

- (void)AlarmBtnClick{
    AlarmViewController *vc = [[AlarmViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.province.length>0) {
        vc.province = self.province;
    }
    if (self.city.length>0) {
        vc.city = self.city;
    }
    if (self.town.length>0) {
        vc.town = self.town;
    }
    if (self.address.length>0) {
        vc.address = self.address;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setUISix{
    self.imageHeader = [[UIImageView alloc] initWithFrame:CGRectMake(8, 690, 100, 20)];
    self.imageHeader.image = [UIImage imageNamed:@"圆角矩形-4"];
    [self.bgScrollView addSubview:self.imageHeader];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLabel.text = @"运维工作排名表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.imageHeader addSubview:titleLabel];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 715, KWidth, 120)];
    self.imageView.userInteractionEnabled = YES;
    //    imageView.image = [UIImage imageNamed:@"首页背景框"];
    [self.bgScrollView addSubview:self.imageView];
    
    UIScrollView *Table = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 300)];
    Table.bounces = NO;
    [self.imageView addSubview:Table];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, KWidth-30, 34)];
    blueView.backgroundColor = RGBColor(10, 68, 132);
    [Table addSubview:blueView];
    
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 35)];
    table.typeCount = 7;
    table.lineColor = [UIColor blackColor];
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    table.tableTitleFont = [UIFont systemFontOfSize:12];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    table.colTitleArr = @[@"总排名",@"姓名",@"指标1",@"指标2",@"指标3"];
    /*        The width of the column array, starting with the first column         */
    //    table.colWidthArr = @[@100.0,@100.0,@160,@100];
    table.colWidthArr = @[@80.0,@30.0,@70,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    table.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    table.minHeightItems = 35;
    /*        Table line color         */
    table.lineColor = [UIColor whiteColor];
    
    table.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    NSArray *arr = @[@[@"1",@"小明",@"80",@"80",@"80"],@[@"2",@"小刚",@"60",@"60",@"80"],@[@"3",@"小丁",@"70",@"60",@"80"],@[@"4",@"小王",@"60",@"60",@"60"]];
    table.dataArr = arr;
    /*        show   */
    //    Table.contentSize = CGSizeMake(KWidth, 35*(table.dataArr.count+1));
    Table.contentSize = CGSizeMake(KWidth, 35);
    [table showAnimation];
    [Table addSubview:table];
    /*        Automatic calculation table height        */
    table.frame = CGRectMake(0, 0, KWidth, [table heightFromThisDataSource]);
    
    UIScrollView *Table1= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, KWidth, KHeight-246)];
    Table1.bounces = NO;
    [Table addSubview:Table1];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.imageView removeFromSuperview];
    [self.imageHeader removeFromSuperview];
    [self setUISix];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/sites/get-home-page",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    if (self.province.length>0) {
        [parameters setValue:self.province forKey:@"province"];
    }
    if (self.city.length>0) {
        [parameters setValue:self.city forKey:@"city"];
    }
    if (self.town.length>0) {
        [parameters setValue:self.town forKey:@"town"];
    }
    if (self.address.length>0) {
        [parameters setValue:self.address forKey:@"village"];
    }
    NSLog(@"time:%@",parameters);

    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页信息正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            NSArray *full_access = responseObject[@"content"][@"full_access"];
            NSLog(@"full_access:%@",_model.full_access);
            NSArray *installed_gross_capacity = responseObject[@"content"][@"installed_gross_capacity"];
            NSArray *part_access = responseObject[@"content"][@"part_access"];
            NSArray *power = responseObject[@"content"][@"power"];
            NSArray *today_gencap_income = responseObject[@"content"][@"today_gencap_income"];
            NSArray *today_self_occupied = responseObject[@"content"][@"today_self_occupied"];
            NSArray *today_up_ele_income = responseObject[@"content"][@"today_up_ele_income"];
            
            CGFloat num = [installed_gross_capacity[0] floatValue] /1000;
            self.downLabel.text = [NSString stringWithFormat:@"%.2fKW/%@户",num,installed_gross_capacity[1]];
            CGFloat num1 = [full_access[0] floatValue] /1000;
            self.rightTopLabel1.text = [NSString stringWithFormat:@"%.2fKW/%@户",num1,full_access[1]];
            CGFloat num2 = [part_access[0] floatValue] /1000;
            self.rightDownLabel1.text = [NSString stringWithFormat:@"%.2fKW/%@户",num2,part_access[1]];
            CGFloat num22 = [today_gencap_income[1] floatValue];
            CGFloat num222 = [today_gencap_income[0] floatValue];
            self.fadianliang.text = [NSString stringWithFormat:@"%.2fMW·h/%.2f元",num222,num22];
            CGFloat num2233 = [today_up_ele_income[0] floatValue];
            CGFloat num22233 = [today_up_ele_income[1] floatValue];
            self.shangwangdianliang.text = [NSString stringWithFormat:@"%.2fMW·h/%.2f元",num2233,num22233];
            CGFloat num33 = [today_self_occupied[0] floatValue];
            CGFloat num44 = [today_self_occupied[1] floatValue];
            self.zifaziyong.text = [NSString stringWithFormat:@"%.2fMW·h/%.2f元",num33,num44];
            CGFloat num3 = [power[0] floatValue] /1000;
            CGFloat num4 = [power[1] floatValue] /1000;
            self.pingjungonglv.text = [NSString stringWithFormat:@"%.2fKW/%.2fKW",num3,num4];
            if (_table.mj_header.isRefreshing) {
                [_table.mj_header endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

- (void)getRongYunToken{
    NSString *URL = [NSString stringWithFormat:@"%@/getToken",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [userDefaults synchronize];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"登陆融云正确%@",responseObject);
        NSString *rongToken = responseObject[@"content"];
        //----------融云------------
        [[RCIM sharedRCIM] initWithAppKey:@"x18ywvqfx6pzc"];
        [[RCIM sharedRCIM] connectWithToken:rongToken     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%d", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}


-(void)requestAlarmData{
    NSString *URL = [NSString stringWithFormat:@"%@/subscribe/index",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
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
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页报警正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            NSNumber *noHandled = responseObject[@"content"][@"noHandled"];
            NSNumber *inHandled = responseObject[@"content"][@"inHandled"];
            NSNumber *Handled = responseObject[@"content"][@"Handled"];
            //            NSInteger noHandled1 = [noHandled integerValue];
            //            NSInteger inHandled1 = [inHandled integerValue];
            //            NSInteger Handled1 = [Handled integerValue];
            self.weichuliLabel.text =[NSString stringWithFormat:@"%@条",noHandled];
            self.chulizhongLabel.text = [NSString stringWithFormat:@"%@条",inHandled];
            self.yichuliLabel.text = [NSString stringWithFormat:@"%@条",Handled];
            if (_table.mj_header.isRefreshing) {
                [_table.mj_header endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestStationData{
    NSString *URL = [NSString stringWithFormat:@"%@/power/index",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
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
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页电站正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            NSNumber *onLine = responseObject[@"content"][@"onLine"];
            NSNumber *normal = responseObject[@"content"][@"normal"];
            NSNumber *offLine = responseObject[@"content"][@"offLine"];
            NSNumber *abnormal = responseObject[@"content"][@"abnormal"];
            NSNumber *fault = responseObject[@"content"][@"fault"];
            self.zhengchangLabel.text =[NSString stringWithFormat:@"%@户",normal];
            self.lixianLabel.text = [NSString stringWithFormat:@"%@户",offLine];
            self.yichangLabel.text = [NSString stringWithFormat:@"%@户",abnormal];
            self.guzhangLabel.text = [NSString stringWithFormat:@"%@户",fault];
            self.zaixianLabel.text = [NSString stringWithFormat:@"%@户",onLine];
            if (_table.mj_header.isRefreshing) {
                [_table.mj_header endRefreshing];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
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
        [parameters setValue:self.province forKey:@"province"];
    }else if ([self.grade isEqualToString:@"town"]) {
        [parameters setValue:self.city forKey:@"city"];
    }else if ([self.grade isEqualToString:@"address"]) {
        [parameters setValue:self.town forKey:@"town"];
    }
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取地址列表正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
        }else{
            if ([self.grade isEqualToString:@"province"]) {
                [self.provinceArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.provinceArr addObject:str];
                }
                if (self.provinceArr.count>0) {
                    [self.selectBtn2 setTitle:self.provinceArr[0] forState:UIControlStateNormal];
                    [self.selectBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [self.selectBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                    
                    [self.selectBtn2 setTitle:self.provinceArr[0] forState:UIControlStateSelected];
                }
                
                //                [self requestShaiXuanData];
                //                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"city"]){
                [self.cityArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.cityArr addObject:str];
                }
                if (self.cityArr.count>0) {
                    [self.selectBtn3 setTitle:self.cityArr[0] forState:UIControlStateNormal];
                    [self.selectBtn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [self.selectBtn3 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                    [self.selectBtn3 setTitle:self.cityArr[0] forState:UIControlStateSelected];
                }
                
                //                [self requestShaiXuanData];
                
                //                _filterController.dataList = [self packageDataList];
            }else if ([self.grade isEqualToString:@"town"]){
                [self.townArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.townArr addObject:str];
                }
                if (self.townArr.count>0) {
                    [self.selectBtn4 setTitle:self.townArr[0] forState:UIControlStateNormal];
                     [self.selectBtn4 setTitle:self.townArr[0] forState:UIControlStateSelected];
                    [self.selectBtn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [self.selectBtn4 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                }

            }else if ([self.grade isEqualToString:@"address"]){
                [self.addressArr removeAllObjects];
                NSArray *arr = responseObject[@"content"];
                for (int i=0; i<arr.count; i++) {
                    NSString *str = arr[i][@"area"];
                    [self.addressArr addObject:str];
                }
                if (self.addressArr.count>0) {
                    [self.selectBtn5 setTitle:self.addressArr[0] forState:UIControlStateNormal];
                    [self.selectBtn5 setTitle:self.addressArr[0] forState:UIControlStateSelected];
                    [self.selectBtn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [self.selectBtn5 setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                }
                //                _filterController.dataList = [self packageDataList];
            }
            //            [_filterController.mainTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}


-(MainModel *)model{
    if (!_model) {
        _model = [[MainModel alloc] init];
    }
    return  _model;
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

@end
