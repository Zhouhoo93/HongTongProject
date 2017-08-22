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
@property (nonatomic ,strong)MenuView      *menu;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *town;

@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentMenu];
    [self setMenu];
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
                                                                                                                                                 //Common Region
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


- (void)createSegmentMenu{
    
    //数据源
    NSArray *array = @[@"全部",@"在线",@"离线",@"故障",@"异常"];
    
    _scroView = [TwoScrollView setTabBarPoint:CGPointMake(0, 0)];
    [_scroView setData:array NormalColor
                     :kColor(16, 16, 16) SelectColor
                     :[UIColor whiteColor] Font
                     :[UIFont systemFontOfSize:15]];
    
    
    [self.view addSubview:_scroView];
    
    //设置默认值
    [TwoScrollView setViewIndex:0];
    
    
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
        }else if(i==3){
            self.ThreeView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.ThreeView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.ThreeView];
        }else if(i==4){
            self.FourView = [[UIView alloc]initWithFrame:CGRectMake(i*Bound_Width, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
            self.FourView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.FourView];
        }        
    }
    [self setTopButton];
    
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
        }else if (i==1){
            [self.OneView addSubview:bgImage];
        }else if(i==2){
            [self.TwoView addSubview:bgImage];
        }else if(i==3){
            [self.ThreeView addSubview:bgImage];
        }else{
            [self.FourView addSubview:bgImage];
        }
        
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
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
        
    }
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / Bound_Width;
    
    //设置Bar的移动位置
    [TwoScrollView setViewIndex:index];
    [self.scroView setlineFrame:index];
}
#pragma mark - 模拟数据源
- (NSArray *)packageDataList {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"省" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"县(市、区)" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"乡镇(街道)" selectionType:BrandTableViewCellSelectionTypeSingle]];
    [dataArray addObject:[self commonFilterRegionModelWithKeyword:@"发电方式" selectionType:BrandTableViewCellSelectionTypeSingle]];
    
    return [dataArray mutableCopy];
}

- (ZYSideSlipFilterRegionModel *)commonFilterRegionModelWithKeyword:(NSString *)keyword selectionType:(CommonTableViewCellSelectionType)selectionType {
    ZYSideSlipFilterRegionModel *model = [[ZYSideSlipFilterRegionModel alloc] init];
    model.containerCellClass = @"SideSlipCommonTableViewCell";
    model.regionTitle = keyword;
    model.customDict = @{REGION_SELECTION_TYPE:@(selectionType)};
    if ([keyword isEqualToString:@"省"]) {
        model.itemList = @[[self createItemModelWithTitle:[NSString stringWithFormat:@"浙江省"] itemId:@"0000" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"湖南省"] itemId:@"0001" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"江苏省"] itemId:@"0002" selected:NO]
                           ];
        
    }else if([keyword isEqualToString:@"县(市、区)"]){
        model.itemList = @[[self createItemModelWithTitle:[NSString stringWithFormat:@"杭州下城"] itemId:@"0000" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"宁波慈溪"] itemId:@"0001" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"杭州江干"] itemId:@"0002" selected:NO]
                           ];
        
    }else if([keyword isEqualToString:@"乡镇(街道)"]){
        model.itemList = @[[self createItemModelWithTitle:[NSString stringWithFormat:@"下沙街道"] itemId:@"0000" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"白杨街道"] itemId:@"0001" selected:NO],
                           [self createItemModelWithTitle:[NSString stringWithFormat:@"没有街道"] itemId:@"0002" selected:NO]
                           ];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
