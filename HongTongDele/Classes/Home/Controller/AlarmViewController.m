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
#define Bound_Width  [[UIScreen mainScreen] bounds].size.width
#define Bound_Height [[UIScreen mainScreen] bounds].size.height
// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface AlarmViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeMenuViewDelegate,UpdateAlertDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *AllView;
@property (nonatomic,strong) UIView *OneView;
@property (nonatomic,strong) UIView *TwoView;
@property (nonatomic,strong) UIView *ThreeView;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) OneScrollViewBar *scroView;
@property (nonatomic ,strong)MenuView      *menu;
@property (nonatomic ,strong)AlarmPopView      *popView;
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSegmentMenu];
    [self setMenu];
    [self CreatPopView];
    // Do any additional setup after loading the view.
}
- (void)setMenu{
    LeftMenuViewDemo *demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width * 0.2, 20, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height-20)];
    demo.customDelegate = self;
    
    MenuView *menu = [MenuView MenuViewWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    //    MenuView *menu = [[MenuView alloc]initWithDependencyView:self.view MenuView:demo isShowCoverView:YES];
    self.menu = menu;
    
}

- (void)CreatPopView{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"AlarmPopView" owner:nil options:nil];
    self.popView = [nibContents lastObject];
    self.popView.delegate = self;
    [self.view addSubview:self.popView];
    self.popView.hidden = YES;
}

- (void)cancelBtnClick{
    self.popView.hidden = YES;
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
            UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake((KWidth-270)/4*(i+1)+90*i, 10, 90, 40)];
            if (i==0) {
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-20"] forState:0];
                [topButton setTitle:@"     排 序" forState:0];
            }else if (i==1){
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-21-拷贝"] forState:0];
                [topButton setTitle:@"     今 日" forState:0];
            }else{
                [topButton setBackgroundImage:[UIImage imageNamed:@"图层-19"] forState:0];
                [topButton setTitle:@"     筛 选" forState:0];
                [topButton addTarget:self action:@selector(ShaiXuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
            }
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
    for (int i=0; i<4; i++) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KWidth, 300)];
        bgImage.userInteractionEnabled = YES;
        bgImage.image = [UIImage imageNamed:@"首页背景框"];
        if (i==0) {
            [self.AllView addSubview:bgImage];
        }else if (i==1){
            [self.OneView addSubview:bgImage];
        }else if(i==2){
            [self.TwoView addSubview:bgImage];
        }else{
            [self.ThreeView addSubview:bgImage];
        }
        
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
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
    [OneScrollViewBar setViewIndex:index];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.popView.hidden = NO;
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
