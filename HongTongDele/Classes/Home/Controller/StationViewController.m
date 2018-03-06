//
//  StationViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "StationViewController.h"
#import "TwoScrollView.h"
#import "ThiredTableViewCell.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "ZYSideSlipFilterController.h"
#import "ZYSideSlipFilterRegionModel.h"
#import "CommonItemModel.h"
#import "AddressModel.h"
#import "PriceRangeModel.h"
#import "SideSlipCommonTableViewCell.h"
#import "LoginOneViewController.h"
#import "AppDelegate.h"
#import "StationListModel.h"
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface StationViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate>
@property (strong, nonatomic) ZYSideSlipFilterController *filterController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *OneView;
@property (nonatomic,strong) UIView *TwoView;
@property (nonatomic,strong) UIView *ThreeView;
@property (nonatomic,strong) UIView *FourView;
@property (nonatomic,strong) UIView *FiveView;
@property (nonatomic,strong) TwoScrollView *scroView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UITableView *table1;
@property (nonatomic,strong) UITableView *table2;
@property (nonatomic,strong) UITableView *table3;
@property (nonatomic,strong) UITableView *table4;
@property (nonatomic ,strong)MenuView      *menu;
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)NSMutableArray *dataArr2;
@property (nonatomic,strong)NSMutableArray *dataArr3;
@property (nonatomic,strong)NSMutableArray *dataArr4;
@property (nonatomic,strong)StationListModel *model;
@property (nonatomic,strong)NSMutableArray *provinceArr;
@property (nonatomic,strong)NSMutableArray *cityArr;
@property (nonatomic,strong)NSMutableArray *townArr;
@property (nonatomic,strong)NSMutableArray *addressArr;
@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grade = @"province";
    [self requestShaiXuanData];
    [self createSegmentMenu];
    [self setMenu];
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
                                                                         [self requestStationData];                                                                                      //Common Region
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

- (void)createSegmentMenu{
    
    //数据源
    NSArray *array = @[@"在线",@"离线",@"正常",@"异常",@"故障"];
    
    _scroView = [TwoScrollView setTabBarPoint:CGPointMake(0, 0)];
    [_scroView setData:array NormalColor
                      :kColor(16, 16, 16) SelectColor
                      :[UIColor whiteColor] Font
                      :[UIFont systemFontOfSize:15]];
    [self.view addSubview:_scroView];
    
    //设置默认值
//        [TwoScrollView setViewIndex:[_index integerValue]];
//    
//    
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
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 30)];
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
        }else if(i==3){
            self.FourView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.FourView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.FourView];
        }else if(i==4){
            
            self.ThreeView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.ThreeView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.ThreeView];
            
        }
    }
    [self setTopButton];
    [_scroView setViewIndex1:[_index integerValue]];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake([_index integerValue] * Bound_Width, 0);
    }];
//    [TwoScrollView setViewIndex:[_index integerValue]];
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTopButton{
    for (int j=0; j<5; j++) {
        UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-120, 10, 90, 40)];
        
        [topButton setBackgroundImage:[UIImage imageNamed:@"图层-20"] forState:0];
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
        }else if(j==3){
            [self.ThreeView addSubview:topButton];
        }else{
            [self.FourView addSubview:topButton];
        }
        
    }
    [self setTableView];
}

- (void)ShaiXuanBtnClick{
    [_filterController show];
}

-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu hidenWithAnimation];
    NSString *tagstr = [NSString stringWithFormat:@"%d",tag];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:tagstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)setTableView{
    for (int i=0; i<5; i++) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KWidth, 300)];
        bgImage.userInteractionEnabled = YES;
        bgImage.image = [UIImage imageNamed:@"首页背景框"];
        if (i==0) {
            [self.AllView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StationTableHeader" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table.backgroundColor = [UIColor clearColor];
            self.table.delegate = self;
            self.table.dataSource = self;
            self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table.mj_header = header;
            self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
            
            [bgImage addSubview:self.table];
        }else if (i==1){
            [self.OneView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StationTableHeader" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table1.backgroundColor = [UIColor clearColor];
            self.table1.delegate = self;
            self.table1.dataSource = self;
            self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table1.mj_header = header;
            self.table1.mj_header.ignoredScrollViewContentInsetTop = self.table1.contentInset.top;
            
            [bgImage addSubview:self.table1];
        }else if(i==2){
            [self.TwoView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StationTableHeader" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table2.backgroundColor = [UIColor clearColor];
            self.table2.delegate = self;
            self.table2.dataSource = self;
            self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table2.mj_header = header;
            self.table2.mj_header.ignoredScrollViewContentInsetTop = self.table2.contentInset.top;
            
            [bgImage addSubview:self.table2];
        }else if(i==4){
            [self.ThreeView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StationTableHeader" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table3.backgroundColor = [UIColor clearColor];
            self.table3.delegate = self;
            self.table3.dataSource = self;
            self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table3.mj_header = header;
            self.table3.mj_header.ignoredScrollViewContentInsetTop = self.table3.contentInset.top;
            
            [bgImage addSubview:self.table3];
        }else{
            [self.FourView addSubview:bgImage];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"StationTableHeader" owner:nil options:nil];
            UIView *TableTipView = [nibContents lastObject];
            TableTipView.frame = CGRectMake(0, 0, KWidth, 44);
            [bgImage addSubview:TableTipView];
            self.table4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KWidth, 300-80) style:UITableViewStylePlain];
            self.table4.backgroundColor = [UIColor clearColor];
            self.table4.delegate = self;
            self.table4.dataSource = self;
            self.table4.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            // 隐藏时间
            header.lastUpdatedTimeLabel.hidden = YES;
            // 隐藏状态
            //    header.stateLabel.hidden = YES;
            self.table4.mj_header = header;
            self.table4.mj_header.ignoredScrollViewContentInsetTop = self.table4.contentInset.top;
            
            [bgImage addSubview:self.table4];
        }
        
        
    }
        [self requestStationData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count  ;
    if (tableView==self.table) {
        count = _dataArr.count;
    }else if (tableView==self.table1){
        count =  _dataArr1.count;
    }else if (tableView==self.table2){
        count =  _dataArr2.count;
    }else if(tableView==self.table3){
        count =  _dataArr4.count;
    }else{
        count =  _dataArr3.count;
        
    }
    return count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"SecondTwoTableViewCell";
    // 2.从缓存池中取出cell
    ThiredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ThiredTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        //        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        if (tableView==self.table) {
            if (_dataArr.count>0) {
                _model = _dataArr[indexPath.row];
                cell.huhaoLabel.text = _model.home;
                cell.statusLabel.text = @"在线";
                cell.statusLabel.textColor = RGBColor(35, 134, 2);
                
            }
        }else if (tableView == self.table1){
            if (_dataArr1.count>0) {
                _model = _dataArr1[indexPath.row];
                cell.huhaoLabel.text = _model.home;
                cell.statusLabel.text = @"离线";
                cell.statusLabel.textColor = [UIColor grayColor];
            }
        }else if (tableView == self.table2){
            if (_dataArr2.count>0) {
                _model = _dataArr2[indexPath.row];
                cell.huhaoLabel.text = _model.home;
                cell.statusLabel.text = @"正常";
                cell.statusLabel.textColor = RGBColor(35, 134, 2);
            }
        }else if (tableView == self.table4){
            if (_dataArr3.count>0) {
                _model = _dataArr3[indexPath.row];
                cell.huhaoLabel.text = _model.home;
                cell.statusLabel.text = @"异常";
                cell.statusLabel.textColor = RGBColor(255, 219, 37);
            }
        }else{
            if (_dataArr4.count>0) {
                _model = _dataArr4[indexPath.row];
                cell.huhaoLabel.text = _model.home;
                cell.statusLabel.text = @"故障";
                cell.statusLabel.textColor = [UIColor redColor];
            }
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
        [TwoScrollView setViewIndex:index];
        [self.scroView setlineFrame:index];
    }
}

- (void)refresh{
    [self requestStationData];
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
-(void)requestStationData{
    for (int i=0; i<5; i++) {
        NSString *URL = [NSString stringWithFormat:@"%@/home/status",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        NSLog(@"token:%@",token);
        [userDefaults synchronize];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
//        if (i==0) {
//            
//        }else if(i==1){
//            [parameters setValue:@"正常" forKey:@"nature"];
//        }else if(i==2){
//            [parameters setValue:@"离线" forKey:@"nature"];
//        }else if(i==3){
//            [parameters setValue:@"故障" forKey:@"nature"];
//        }else{
//            [parameters setValue:@"异常" forKey:@"nature"];
//        }
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
//        if (self.address.length>0) {
//            [parameters setValue:self.address forKey:@"area"];
//        }
        NSLog(@"%@",parameters);
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%d获取电站列表正确%@",i,responseObject);
            
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
                
               
                if (i==0) {
                    [self.dataArr removeAllObjects];
                 
                    for (NSDictionary *dic in responseObject[@"content"][@"onLine"]) {
                        _model = [[StationListModel alloc] initWithDictionary:dic];
                        [self.dataArr addObject:_model];
                    }
                    
                    _filterController.dataList = [self packageDataList];
                    
                    
                    [self.table reloadData];
                }else if (i==1){
                    [self.dataArr1 removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"content"][@"offLine"]) {
                        _model = [[StationListModel alloc] initWithDictionary:dic];
                        [self.dataArr1 addObject:_model];
                        
                    }
                    _filterController.dataList = [self packageDataList];
                    [self.table1 reloadData];
                }else if (i==2){
                    [self.dataArr2 removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"content"][@"normal"]) {
                        _model = [[StationListModel alloc] initWithDictionary:dic];
                        [self.dataArr2 addObject:_model];
                    }
                    _filterController.dataList = [self packageDataList];
                    [self.table2 reloadData];
                }else if (i==3){
                    [self.dataArr3 removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"content"][@"abnormal"]) {
                        _model = [[StationListModel alloc] initWithDictionary:dic];
                        [self.dataArr3 addObject:_model];
                    }
                    _filterController.dataList = [self packageDataList];
                    [self.table4 reloadData];
                }else{
                    [self.dataArr4 removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"content"][@"fault"]) {
                        _model = [[StationListModel alloc] initWithDictionary:dic];
                        [self.dataArr4 addObject:_model];
                    }
                    _filterController.dataList = [self packageDataList];
                    [self.table3 reloadData];
                }
                
                
            }
            [_filterController.mainTableView reloadData];
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
            if (_table4.mj_header.isRefreshing ) {
                [_table4.mj_header endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];
        
    }
    
    
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
-(StationListModel *)model{
    if (!_model) {
        _model = [[StationListModel alloc] init];
    }
    return _model;
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
-(NSMutableArray *)dataArr4{
    if (!_dataArr4) {
        _dataArr4 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr4;
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
