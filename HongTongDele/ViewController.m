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
@interface ViewController ()<UIScrollViewDelegate,ChangeName>
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIButton *selectBtn2;
@property (nonatomic,strong) UIButton *selectBtn3;
@property (nonatomic,strong) UIButton *selectBtn4;
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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self setUI];
    [self requestData];
    [self setUITwo];
    [self setUIThree];
    [self setUIFour];
    [self setUIFive];
    [self getRongYunToken];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)InfoNotificationAction:(NSNotification *)notification{
    AlarmViewController *vc = [[AlarmViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"---接收到通知---");
    
}
- (void)setUI{
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, KWidth, KHeight)];
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bgScrollView.contentSize = CGSizeMake(KWidth, 1000);
    [self.view addSubview:self.bgScrollView];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 64)];
    bgImage.image = [UIImage imageNamed:@"形状-3"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    for (int i=0; i<4; i++) {
        if (i==0) {
            UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 30, (KWidth-100)/4, 24)];
            addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [addressBtn setTitleColor:[UIColor blackColor] forState:0];
            [addressBtn setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [addressBtn setTitle:@"全部" forState:0];
            addressBtn.tag = 10000;
            [addressBtn addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:addressBtn];
        }else if (i==1){
            self.selectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 30, (KWidth-100)/4, 24)];
            self.selectBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn2 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn2 setTitle:@"浙江省" forState:0];
            self.selectBtn2.tag = 10001;
            [self.selectBtn2 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn2];
        }else if (i==2){
            self.selectBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 30, (KWidth-100)/4, 24)];
            self.selectBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn3 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn3 setTitle:@"杭州江干" forState:0];
            self.selectBtn3.tag = 10002;
            [self.selectBtn3 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn3];
        }else{
            self.selectBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 30, (KWidth-100)/4, 24)];
            self.selectBtn4.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn4 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn4 setTitle:@"白杨街道" forState:0];
            self.selectBtn4.tag = 10003;
            [self.selectBtn4 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn4];
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
    self.downLabel.text = @"100KW/100户";
    self.downLabel.font = [UIFont systemFontOfSize:14];
    self.downLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.downLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 15, KWidth/2, 37)];
    rightTopLabel.text = @"全额上网/户数";
    rightTopLabel.font = [UIFont systemFontOfSize:14];
    rightTopLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightTopLabel];
    self.rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 38, KWidth/2, 37)];
    self.rightTopLabel1.text = @"50KW/50户";
    self.rightTopLabel1.font = [UIFont systemFontOfSize:14];
    self.rightTopLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.rightTopLabel1];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2,80, KWidth/2, 37)];
    rightDownLabel.text = @"余电上网/户数";
    rightDownLabel.font = [UIFont systemFontOfSize:14];
    rightDownLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightDownLabel];
    self.rightDownLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 103, KWidth/2, 37)];
    self.rightDownLabel1.text = @"50KW/50户";
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
            vc.dataArr = @[@"浙江省",@"河南省",@"江西省",@"河北省",@"山东省",@"福建省"];
        }else if (sender.tag == 10002) {
            self.selectIndex  = 2;
            vc.dataArr = @[@"杭州江干",@"杭州下城",@"杭州拱墅",@"杭州滨江",@"杭州萧山",@"杭州西湖"];
        }else if (sender.tag == 10003) {
            self.selectIndex  = 3;
            vc.dataArr = @[@"白杨街道",@"下沙街道",@"啊啊街道",@"啊啊街道",@"啊啊街道",@"没有街道"];
        }
        vc.hidesBottomBarWhenPushed = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//协议要实现的方法
-(void)changeName:(NSString *)string
{
    if(self.selectIndex==1){
        [self.selectBtn2 setTitle:string forState:0];
    }else if(self.selectIndex==2){
        [self.selectBtn3 setTitle:string forState:0];
    }else if (self.selectIndex ==3){
        [self.selectBtn4 setTitle:string forState:0];
    }
}
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
    self.fadianliang = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, KWidth/2-50, 20)];
    self.fadianliang.text = @"0.1MW·h/100元";
    self.fadianliang.font = [UIFont systemFontOfSize:14];
    self.fadianliang.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.fadianliang];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 15, KWidth/2, 37)];
    rightTopLabel.text = @"上网电量/现金收入";
    rightTopLabel.font = [UIFont systemFontOfSize:14];
    rightTopLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightTopLabel];
    self.shangwangdianliang = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 38, KWidth/2, 37)];
    self.shangwangdianliang.text = @"0.1MW·h/100元";
    self.shangwangdianliang.font = [UIFont systemFontOfSize:14];
    self.shangwangdianliang.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:self.shangwangdianliang];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2,80, KWidth/2, 37)];
    rightDownLabel.text = @"自发自用电量/价值";
    rightDownLabel.font = [UIFont systemFontOfSize:14];
    rightDownLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage1 addSubview:rightDownLabel];
    self.zifaziyong = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 103, KWidth/2, 37)];
    self.zifaziyong.text = @"0.1MW·h/100元";
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)SecondBtnClick{
    ElectricityViewController *vc = [[ElectricityViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
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
    self.pingjungonglv.text = @"1100KW/1100KW";
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
    
    for (int i=0; i<4; i++) {
        UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth-200)/5*(i+1)+50*i, 30, 50, 50)];
        
        
        if (i==0) {
            imagePic.image = [UIImage imageNamed:@"正常"];
            self.zhengchangLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*(i+1)+70*i, 90,70, 20)];
            self.zhengchangLabel.textAlignment = NSTextAlignmentCenter;
            self.zhengchangLabel.textColor = [UIColor greenColor];
            self.zhengchangLabel.text = @"";
            [imageView addSubview:self.zhengchangLabel];
        }else if (i==1) {
            imagePic.image = [UIImage imageNamed:@"离线"];
            self.lixianLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*(i+1)+70*i, 90,70, 20)];
            self.lixianLabel.textAlignment = NSTextAlignmentCenter;
            self.lixianLabel.textColor = [UIColor lightGrayColor];
            self.lixianLabel.text = @"";
            [imageView addSubview:self.lixianLabel];
        }else if (i==2) {
            self.yichangLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*(i+1)+70*i, 90,70, 20)];
            self.yichangLabel.textAlignment = NSTextAlignmentCenter;
            imagePic.image = [UIImage imageNamed:@"异常"];
            self.yichangLabel.textColor = [UIColor yellowColor];
            self.yichangLabel.text = @"";
            [imageView addSubview:self.yichangLabel];
        }else {
            self.guzhangLabel = [[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*(i+1)+70*i, 90,70, 20)];
            self.guzhangLabel.textAlignment = NSTextAlignmentCenter;
            imagePic.image = [UIImage imageNamed:@"故障"];
            self.guzhangLabel.textColor = [UIColor redColor];
            self.guzhangLabel.text = @"";
            [imageView addSubview:self.guzhangLabel];
        }
        [imageView addSubview:imagePic];
    }
    [self requestStationData];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
    [button addTarget:self action:@selector(FourBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
}

-(void)FourBtnClick{
    StationViewController *vc = [[StationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
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
            self.chulizhongLabel.textColor = [UIColor greenColor];
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
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页信息正确%@",responseObject);
        
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
            self.fadianliang.text = [NSString stringWithFormat:@"%@MW·h/%.2f元",today_gencap_income[0],num22];
            self.shangwangdianliang.text = [NSString stringWithFormat:@"%@MW·h/%@元",today_up_ele_income[0],today_up_ele_income[1]];
            self.zifaziyong.text = [NSString stringWithFormat:@"%@MW·h/%@元",today_self_occupied[0],today_self_occupied[1]];
            CGFloat num3 = [power[0] floatValue] /1000;
            CGFloat num4 = [power[1] floatValue] /1000;
            self.pingjungonglv.text = [NSString stringWithFormat:@"%.2fKW/%.2fKW",num3,num4];
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
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页报警正确%@",responseObject);
        
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
            NSNumber *noHandled = responseObject[@"content"][@"noHandled"];
            NSNumber *inHandled = responseObject[@"content"][@"inHandled"];
            NSNumber *Handled = responseObject[@"content"][@"Handled"];
//            NSInteger noHandled1 = [noHandled integerValue];
//            NSInteger inHandled1 = [inHandled integerValue];
//            NSInteger Handled1 = [Handled integerValue];
            self.weichuliLabel.text =[NSString stringWithFormat:@"%@条",noHandled];
            self.chulizhongLabel.text = [NSString stringWithFormat:@"%@条",inHandled];
            self.yichuliLabel.text = [NSString stringWithFormat:@"%@条",Handled];
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
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取首页电站正确%@",responseObject);
        
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
            NSNumber *normal = responseObject[@"content"][@"normal"];
            NSNumber *offLine = responseObject[@"content"][@"offLine"];
            NSNumber *abnormal = responseObject[@"content"][@"abnormal"];
            NSNumber *fault = responseObject[@"content"][@"fault"];
            self.zhengchangLabel.text =[NSString stringWithFormat:@"%@户",normal];
            self.lixianLabel.text = [NSString stringWithFormat:@"%@户",offLine];
            self.yichangLabel.text = [NSString stringWithFormat:@"%@户",abnormal];
            self.guzhangLabel.text = [NSString stringWithFormat:@"%@户",fault];
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

@end
