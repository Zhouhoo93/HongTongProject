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
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface StationViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *OneView;
@property (nonatomic,strong) UIView *TwoView;
@property (nonatomic,strong) UIView *ThreeView;
@property (nonatomic,strong) UIView *FourView;
@property (nonatomic,strong) UIView *FiveView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic ,strong)MenuView      *menu;

@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentMenu];
    [self setMenu];
    // Do any additional setup after loading the view.
}

- (void)setMenu{
    LeftMenuViewDemo *demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.2, 20, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height-20)];
    demo.customDelegate = self;
    
    MenuView *menu = [MenuView MenuViewWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    //    MenuView *menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    self.menu = menu;
    
}


- (void)createSegmentMenu{
    
    //数据源
    NSArray *array = @[@"全部",@"在线",@"离线",@"故障",@"异常"];
    
    TwoScrollView *scroView = [TwoScrollView setTabBarPoint:CGPointMake(0, 0)];
    [scroView setData:array NormalColor
                     :kColor(16, 16, 16) SelectColor
                     :[UIColor whiteColor] Font
                     :[UIFont systemFontOfSize:15]];
    
    
    [self.view addSubview:scroView];
    
    //设置默认值
    [TwoScrollView setViewIndex:0];
    
    
    //TabBar回调
    [scroView getViewIndex:^(NSString *title, NSInteger index) {
        
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
    [leftBtn setImage:[UIImage imageNamed:@"向右箭头"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scroView addSubview:leftBtn];
    
    
    
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
    [self.menu show];
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
