//
//  XiaoLvHuViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/11/29.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "XiaoLvHuViewController.h"
#import "JHTableChart.h"
#import "ErrorListtwo.h"
#import "JHPickView.h"
#import "XiaoLvTownListModel.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "XiaoLvTownDataModel.h"
@interface XiaoLvHuViewController ()<UIScrollViewDelegate,TableButDelegate,yichangDelegate,JHPickerDelegate>
@property (nonatomic,strong)UIScrollView *bgscrollview;
@property (nonatomic,strong)UIScrollView *bgscrollview1;
@property (nonatomic,strong)UIScrollView *bg;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)JHTableChart *table3;
@property (nonatomic,strong)JHTableChart *table33;
@property (nonatomic,strong)JHTableChart *table4;
@property (nonatomic,strong)JHTableChart *table44;
@property (nonatomic,strong)ErrorListtwo *errorList;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)XiaoLvTownListModel *listModel;
@property (nonatomic,strong)XiaoLvTownDataModel *townModel;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,copy)NSString *selectID;
@property (nonatomic,copy)NSString *selectName;
@property (nonatomic,strong) UIImageView *biaogeBg;
@property (nonatomic,strong) UIImageView *biaogeBg1;
@property (nonatomic,strong)UILabel *toplabel1;
@property (nonatomic,strong)UILabel *toplabel;
@property (nonatomic,assign)NSInteger jieduan;
@property (nonatomic,copy)NSString *position;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *dianjiStatus;
@property (nonatomic,copy)NSString *selectBid;
@end

@implementation XiaoLvHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发电效率异常电站列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTop];
    
    // Do any additional setup after loading the view.
}

- (void)setTop{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, KWidth/2-1, 44)];
    leftLabel.textAlignment  = NSTextAlignmentCenter;
    leftLabel.text = @"未处理";
    [self.view addSubview:leftLabel];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, KWidth/2-1, 44)];
    [self.view addSubview:leftBtn];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 64, KWidth/2, 44)];
    rightLabel.textAlignment  = NSTextAlignmentCenter;
    rightLabel.text = @"处理中";
    [self.view addSubview:rightLabel];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2, 64, KWidth/2, 44)];
    [self.view addSubview:rightBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2-1, 64, 1, 44)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    [self setScroll];
}

- (void)setScroll{
    self.bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, KWidth, KHeight-94)];
    self.bg.delegate = self;
    //    self.bgscrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.bg.pagingEnabled = YES;
    self.bg.contentSize = CGSizeMake(KWidth*2, KHeight-94);
    [self.view addSubview:self.bg];
    
    UIImageView *leftbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-94)];
    leftbg.image = [UIImage imageNamed:@"未处理1"];
    leftbg.userInteractionEnabled = YES;
    [self.bg addSubview:leftbg];
    
    UIImageView *rightbg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, KHeight-94)];
    rightbg.image = [UIImage imageNamed:@"处理中1"];
    rightbg.userInteractionEnabled = YES;
    [self.bg addSubview:rightbg];
    
    self.bgscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, KWidth, KHeight-94)];
    self.bgscrollview.delegate = self;
    self.bgscrollview.backgroundColor = [UIColor clearColor];
    self.bgscrollview.pagingEnabled = NO;
    self.bgscrollview.contentSize = CGSizeMake(KWidth, 900);
    [leftbg addSubview:self.bgscrollview];
    
    self.bgscrollview1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, KWidth, KHeight-94)];
    self.bgscrollview1.delegate = self;
    self.bgscrollview1.backgroundColor = [UIColor clearColor];
    self.bgscrollview1.pagingEnabled = NO;
    self.bgscrollview1.contentSize = CGSizeMake(KWidth, 900);
    [rightbg addSubview:self.bgscrollview1];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 900)];
    self.leftView.backgroundColor = [UIColor clearColor];
    [self.bgscrollview addSubview:self.leftView];
    
    
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 900)];
    self.rightView.backgroundColor = [UIColor clearColor];
    [self.bgscrollview1 addSubview:self.rightView];
    
    [self requesttownList];
    
//    [self setLeftTable];
//    [self setRightTable];
}


- (void)setLeftTable{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, KWidth-100, 30)];
    topTable.userInteractionEnabled = YES;
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.leftView addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    self.toplabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    self.toplabel.font = [UIFont systemFontOfSize:15];
    self.toplabel.textColor = [UIColor darkGrayColor];
    //    self.toplabel.text = @"分公司一:20户 平均降效比:30%";
    self.toplabel.text = [NSString stringWithFormat:@"%@:%ld户 平均降效:30%%",_selectName,self.dataArr.count];
    [topTable addSubview:self.toplabel];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth-100, 30)];
    [leftBtn addTarget:self action:@selector(leftTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [topTable addSubview:leftBtn];
    
    if (self.dataArr.count<10) {
        if (self.dataArr.count==0) {
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.dataArr.count*40+35)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.leftView addSubview:self.biaogeBg];
        }else{
            self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.dataArr.count*40+33)];
            self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
            [self.leftView addSubview:self.biaogeBg];
        }
    }else{
        self.biaogeBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
        self.biaogeBg.image = [UIImage imageNamed:@"表格bg"];
        [self.leftView addSubview:self.biaogeBg];
    }
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.leftView addSubview:fourTable];
    
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
//    self.table1.delegate = self;
    self.table1.typeCount = 88;
    self.table1.small = YES;
    self.table1.isblue = NO;
    self.table1.bodyTextColor = [UIColor blackColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table1.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"容量(kW)",@"降效(%)",@"发生时间"];
    
    
    self.table1.colWidthArr = @[@30.0,@40.0,@120.0,@50.0,@50.0,@50.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table1.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table1.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table1.lineColor = [UIColor lightGrayColor];
    
    self.table1.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table1 showAnimation];
    [fourTable addSubview:self.table1];
    /*        Automatic calculation table height        */
    self.table1.frame = CGRectMake(0, 0, KWidth, [self.table1 heightFromThisDataSource]);
    
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable1.frame = CGRectMake(0, 81, KWidth, 364);
    oneTable1.bounces = NO;
    [self.leftView addSubview:oneTable1];
    self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table11.typeCount = 88;
    self.table11.isblue = NO;
    self.table11.delegate = self;
    self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    if (self.dataArr.count>0) {
        _townModel = _dataArr[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.ID]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.home]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.addr]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.brand_specifications]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.reduce_effect]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.date]];
    }
    self.table11.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table11.colWidthArr = @[@30.0,@40.0,@120.0,@50.0,@50.0,@50.0];
    self.table11.bodyTextColor = [UIColor blackColor];
    self.table11.minHeightItems = 36;
    self.table11.lineColor = [UIColor lightGrayColor];
    self.table11.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _townModel = _dataArr[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.ID]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.home]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.addr]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.brand_specifications]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.reduce_effect]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.date]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table11.dataArr = newArr1;
    [self.table11 showAnimation];
    [oneTable1 addSubview:self.table11];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table11.frame = CGRectMake(0, 0, KWidth, [self.table11 heightFromThisDataSource]);
    
    
}



- (void)setRightTable{
    UIImageView *topTable = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, KWidth-100, 30)];
    topTable.image = [UIImage imageNamed:@"发电bgt"];
    [self.rightView addSubview:topTable];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 12, 17)];
    leftImg.image = [UIImage imageNamed:@"tbx"];
    [topTable addSubview:leftImg];
    
    self.toplabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, KWidth-70, 24)];
    self.toplabel1.font = [UIFont systemFontOfSize:15];
    self.toplabel1.textColor = [UIColor darkGrayColor];
    //    self.toplabel1.text = @"分公司一:20户 平均降效比:30%";
    self.toplabel1.text = [NSString stringWithFormat:@"%@:%ld户 平均降效:30%%",_selectName,self.dataArr1.count];
    [topTable addSubview:self.toplabel1];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 17, KWidth-100, 30)];
    [rightBtn addTarget:self action:@selector(leftTitleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:rightBtn];
    
    if (self.dataArr1.count<10) {
        if (self.dataArr1.count==0) {
            self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.dataArr1.count*40+35)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.rightView addSubview:self.biaogeBg1];
        }else{
            self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, self.dataArr1.count*40+33)];
            self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
            [self.rightView addSubview:self.biaogeBg1];
        }
    }else{
        self.biaogeBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, KWidth-20, 400)];
        self.biaogeBg1.image = [UIImage imageNamed:@"表格bg"];
        [self.rightView addSubview:self.biaogeBg1];
    }
    
    UIView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, KWidth, 400)];
    //    fourTable.bounces = NO;
    [self.rightView addSubview:fourTable];
    
    self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 400)];
//    self.table3.delegate = self;
    self.table3.typeCount = 88;
    self.table3.small = YES;
    self.table3.isblue = NO;
    self.table3.bodyTextColor = [UIColor blackColor];
    self.table3.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table3.colTitleArr = @[@"类别|序号",@"户号",@"地址",@"容量(kW)",@"降效(%)",@"发生时间"];
    
    
    self.table3.colWidthArr = @[@30.0,@40.0,@120.0,@50.0,@50.0,@50.0];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table3.bodyTextColor = [UIColor blackColor];
    /*        Minimum grid height         */
    self.table3.minHeightItems = 36;
    //    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table3.lineColor = [UIColor lightGrayColor];
    
    self.table3.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    
    //        self.table.dataArr = array2d2;
    
    
    /*        show   */
    //    fourTable.contentSize = CGSizeMake(KWidth, 46);
    [self.table3 showAnimation];
    [fourTable addSubview:self.table3];
    /*        Automatic calculation table height        */
    self.table3.frame = CGRectMake(0, 0, KWidth, [self.table3 heightFromThisDataSource]);
    
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    //        if (self.dayFeeArr.count>11) {
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/664*(300));
    //        }else{
    //            oneTable1.frame = CGRectMake(0,KHeight/667*92, k_MainBoundsWidth, KHeight/667*46*self.dayFeeArr.count);
    //        }
    oneTable1.frame = CGRectMake(0, 81, KWidth, 364);
    oneTable1.bounces = NO;
    [self.rightView addSubview:oneTable1];
    self.table33 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 364)];
    self.table33.typeCount = 88;
    self.table33.isblue = NO;
    self.table33.delegate = self;
    self.table33.tableTitleFont = [UIFont systemFontOfSize:14];
    NSMutableArray *tipArr = [[NSMutableArray alloc] init];
    if (self.dataArr1.count>0) {
        _townModel = _dataArr1[0];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.ID]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.home]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.addr]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.brand_specifications]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.reduce_effect]];
        [tipArr addObject:[NSString stringWithFormat:@"%@",_townModel.date]];
    }
    self.table33.colTitleArr = tipArr;
    //        self.table44.colWidthArr = colWid;
    self.table33.colWidthArr = @[@30.0,@40.0,@120.0,@50.0,@50.0,@50.0];
    self.table33.bodyTextColor = [UIColor blackColor];
    self.table33.minHeightItems = 36;
    self.table33.lineColor = [UIColor lightGrayColor];
    self.table33.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *newArr1 = [[NSMutableArray alloc] init];
    for (int i=0; i<_dataArr1.count; i++) {
        if (i>0) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr removeAllObjects];
            _townModel = _dataArr1[i];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.ID]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.home]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.addr]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.brand_specifications]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.reduce_effect]];
            [newArr addObject:[NSString stringWithFormat:@"%@",_townModel.date]];
            [newArr1 addObject:newArr];
        }
        
    }
    self.table33.dataArr = newArr1;
    [self.table33 showAnimation];
    [oneTable1 addSubview:self.table33];
    oneTable1.contentSize = CGSizeMake(KWidth, 360);
    self.table33.frame = CGRectMake(0, 0, KWidth, [self.table33 heightFromThisDataSource]);
    
    
}
- (void)leftTitleClick{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_listArr.count; i++) {
        _listModel = _listArr[i];
        [list addObject:_listModel.townname];
    }
    JHPickView *picker = [[JHPickView alloc]initWithFrame:self.view.bounds];
    picker.classArr = list;
    picker.delegate = self ;
    picker.arrayType = weightArray;
    [self.view addSubview:picker];
}
-(void)PickerSelectorIndixString:(NSString *)str:(NSInteger)row
{
    for (int i=0; i<_listArr.count; i++) {
        _listModel = _listArr[i];
        if ([str isEqualToString:_listModel.townname]) {
            self.selectID = _listModel.ID;
            self.selectName = str;
        }
    }
    [self.table1 removeFromSuperview];
    [self.table11 removeFromSuperview];
    [self.table3 removeFromSuperview];
    [self.table33 removeFromSuperview];
    [self.biaogeBg1 removeFromSuperview];
    [self.biaogeBg removeFromSuperview];
    [self.toplabel removeFromSuperview];
    [self.toplabel1 removeFromSuperview];
    [self.dataArr removeAllObjects];
    [self.dataArr1 removeAllObjects];
    [self requestList];
    [self requestList1];
    NSLog(@"%@,%ld",str,row);
    
}

- (void)transButIndex:(NSInteger)index
{
    NSLog(@"代理方法%ld",index);
    CGPoint offset = _bgscrollview.contentOffset;
    
    if (offset.x == 0) {
        _townModel = _dataArr[index];
        _selectID = _townModel.ID;
        self.jieduan = 0;
    }else{
        _townModel = _dataArr1[index];
        _selectID = _townModel.ID;
        self.jieduan = 1;
    }
    [self requesterror];
    
}
-(void)requesterror{
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/town/info/%@",kUrl,self.selectID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setValue:self.selectID forKey:@"id"];
//    [parameters setValue:self.selectBid forKey:@"bid"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",URL);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取故障列表正确%@",responseObject);
        
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
            
            self.address = responseObject[@"content"][@"address"];
            NSString *house_id = responseObject[@"content"][@"house_id"];
            NSString *name = responseObject[@"content"][@"name"];
            self.phone = responseObject[@"content"][@"phone"];
            self.selectBid = responseObject[@"content"][@"bid"];
            NSString *power = responseObject[@"content"][@"power"];
            NSString *today_gen = responseObject[@"content"][@"today_gen"];
            NSString *position = responseObject[@"content"][@"position"];
            self.position = position;
            self.errorList = [[[NSBundle mainBundle]loadNibNamed:@"ErrorListTwoList" owner:self options:nil]objectAtIndex:0];
            //    view.Topdelegate = self;
            self.errorList.frame = CGRectMake(0, 64, KWidth, KHeight);
            self.errorList.delegate = self;
           
            self.errorList.huhao.text = house_id;
            self.errorList.phone.text = self.phone;
            self.errorList.address.text = self.address;
            self.errorList.gonglv.text = [NSString stringWithFormat:@"%@kW",power];
            self.errorList.fadianliang.text = [NSString stringWithFormat:@"%@度",today_gen];;
            self.errorList.huhao.text = house_id;
//            if (self.jieduan==0) {
//                self.errorList.jieduan.text = @"未处理";
//            }else{
//                self.errorList.jieduan.text = @"处理中";
//            }
            NSInteger status = responseObject[@"content"][@"status"];
            if (status == 0) {
                self.errorList.jieduan.text = @"未处理";
            }else if (status==1){
                self.errorList.jieduan.text = @"处理中";
            }else{
                self.errorList.jieduan.text = @"已处理";
            }
           
            [self.view addSubview:self.errorList];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CloseClick{
    [self.errorList removeFromSuperview];
}
-(void)LeftClick{
    [self.errorList removeFromSuperview];
}
-(void)RightClick{
    NSString *str = self.errorList.jieduan.text;
    NSLog(@"str:%@ %@",str,self.dianjiStatus);
    [self requestchangge];
    [self.errorList removeFromSuperview];
}
-(void)bohaoBtnClick{
    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone];
    //    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:18813189235"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)xinxiBtnClick{
    NSString *str = [NSString stringWithFormat:@"sms://%@",self.phone];
    NSURL *url = [NSURL URLWithString:str];
    
    [[UIApplication sharedApplication] openURL:url];
    
    
}
-(void)weichuliClick{
    self.dianjiStatus = @"0";
}
-(void)chulizhongClick{
    self.dianjiStatus = @"1";
}
-(void)yichuliClick{
    self.dianjiStatus = @"2";
}

-(void)daohangBtnClick{
    [self mapBtnClick];
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
-(void)requestchangge{
    NSString *URL = [NSString stringWithFormat:@"%@/police/work/handle",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"id"];
    [parameters setValue:self.selectBid forKey:@"bid"];
    [parameters setValue:self.dianjiStatus forKey:@"status"];
    [parameters setValue:self.errorList.beizhu.text forKey:@"opinion"];
    //type:值(handle 和  inhandle)
    NSLog(@"parameters:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传故障正确%@",responseObject);
        
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"3100"])  {
                [MBProgressHUD showText:@"请重新登陆"];
                [self newLogin];
            }else{
//                NSString *str = responseObject[@"result"][@"errorMsg"];
//                [MBProgressHUD showText:str];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text =responseObject[@"result"][@"errorMsg"];
                [hud hideAnimated:YES afterDelay:2.f];
            }
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}
-(XiaoLvTownListModel *)listModel{
    if (!_listModel) {
        _listModel = [[XiaoLvTownListModel alloc] init];
    }
    return _listModel;
}
-(XiaoLvTownDataModel *)townModel {
    if (!_townModel) {
        _townModel = [[XiaoLvTownDataModel alloc] init];
    }
    return _townModel;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
}
-(NSMutableArray *)dataArr1{
    if (!_dataArr1) {
        _dataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr1;
}
-(void)requesttownList{
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/work/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"Handle" forKey:@"type"];
    [parameters setValue:self.workID forKey:@"id"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取镇列表正确%@",responseObject);
        
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
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _listModel = [[XiaoLvTownListModel alloc] initWithDictionary:dic];
                [self.listArr addObject:_listModel];
            }
            _listModel = _listArr[0];
            self.selectID = _listModel.ID;
            self.selectName = _listModel.townname;
//            //            [self setLeftTable];
//            //            [self setRightTable];
            [self requestList];
            [self requestList1];
            //            [self performSelector:@selector(requestList) withObject:nil afterDelay:1.0f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}
-(void)requestList{
    NSString *selectID = [NSString stringWithFormat:@"%@",self.selectID];
    if (selectID.length>0) {
        
    }else{
        _listModel = _listArr[0];
        self.selectID = [NSString stringWithFormat:@"%@",_listModel.ID];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/town/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"town_id"];
    [parameters setValue:@"Handle" forKey:@"type"];
    NSLog(@"parameters:%@",parameters);
    //type:值(handle 和  inhandle)
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取左边数据正确%@",responseObject);
        
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
            [_dataArr removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _townModel = [[XiaoLvTownDataModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_townModel];
            }
//            //            [self setTabel];
            [self setLeftTable];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}

-(void)requestList1{
    NSString *selectID = [NSString stringWithFormat:@"%@",self.selectID];
    if (selectID.length>0) {
        
    }else{
        _listModel = _listArr[0];
        self.selectID = [NSString stringWithFormat:@"%@",_listModel.ID];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@/abnormal/town/list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    NSLog(@"token:%@",token);
    [userDefaults synchronize];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.selectID forKey:@"town_id"];
    [parameters setValue:@"inHandle" forKey:@"type"];
    NSLog(@"parameters:%@",parameters);
    //type:值(handle 和  inhandle)
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取右边数据正确%@",responseObject);
        
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
            [_dataArr1 removeAllObjects];
            for (NSMutableDictionary *dic in responseObject[@"content"]) {
                _townModel = [[XiaoLvTownDataModel alloc] initWithDictionary:dic];
                [self.dataArr1 addObject:_townModel];
            }
//            //            [self setTabel];
            [self setRightTable];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
