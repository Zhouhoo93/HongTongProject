//
//  InstallViewController.m
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/4.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "InstallViewController.h"
#import "HomeSelectViewController.h"
#import "InstallTableViewCell.h"
@interface InstallViewController ()<ChangeName,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UIButton *selectBtn2;
@property (nonatomic,strong) UIButton *selectBtn3;
@property (nonatomic,strong) UIButton *selectBtn4;
@property (nonatomic,strong) UITableView *table;
@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self SetSelectBtn];
    [self setTable];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SetSelectBtn{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 128)];
    bgImage.image = [UIImage imageNamed:@"形状-3"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    UIImageView *backButtonImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 35, 10, 18)];
    backButtonImg.userInteractionEnabled = YES;
    backButtonImg.image = [UIImage imageNamed:@"ab_ic_back"];
    [bgImage addSubview:backButtonImg];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImage addSubview:backButton];
    
    for (int i=0; i<4; i++) {
        if (i==0) {
            UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 94, (KWidth-100)/4, 24)];
            addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [addressBtn setTitleColor:[UIColor blackColor] forState:0];
            [addressBtn setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [addressBtn setTitle:@"全部" forState:0];
            addressBtn.tag = 10000;
            [addressBtn addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:addressBtn];
        }else if (i==1){
            self.selectBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 94, (KWidth-100)/4, 24)];
            self.selectBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn2 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn2 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn2 setTitle:@"浙江省" forState:0];
            self.selectBtn2.tag = 10001;
            [self.selectBtn2 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn2];
        }else if (i==2){
            self.selectBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 94, (KWidth-100)/4, 24)];
            self.selectBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn3 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn3 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn3 setTitle:@"杭州江干" forState:0];
            self.selectBtn3.tag = 10002;
            [self.selectBtn3 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn3];
        }else{
            self.selectBtn4 = [[UIButton alloc] initWithFrame:CGRectMake(20*(i+1)+(KWidth-100)/4*i, 94, (KWidth-100)/4, 24)];
            self.selectBtn4.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.selectBtn4 setTitleColor:[UIColor blackColor] forState:0];
            [self.selectBtn4 setBackgroundImage:[UIImage imageNamed:@"形状-5-拷贝"] forState:0];
            [self.selectBtn4 setTitle:@"白杨街道" forState:0];
            self.selectBtn4.tag = 10003;
            [self.selectBtn4 addTarget:self action:@selector(selctBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgImage addSubview:self.selectBtn4];
        }
        
    }

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

- (void)setTable{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, KWidth, 300)];
    bgImage.userInteractionEnabled = YES;
    bgImage.image = [UIImage imageNamed:@"首页背景框"];
    [self.view addSubview:bgImage];
    
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 44)];
    titleHeaderView.backgroundColor = [UIColor clearColor];
    [bgImage addSubview:titleHeaderView];
    
    for (int i=0; i<3; i++) {
        UILabel *title = [[UILabel alloc] init];
        if (i==0) {
            title.frame = CGRectMake(20, 25, 50, 24);
            title.text = @"户号";
        }else if(i==1){
            title.frame = CGRectMake(KWidth/2-25, 25, 50, 24);
//            title.textAlignment = NSTextAlignmentCenter;
            title.text = @"地址";
        }else if(i==2){
            title.frame = CGRectMake(KWidth-100, 25, 80, 24);
            title.text = @"装机量(kW)";
        }
        title.font = [UIFont systemFontOfSize:14];
        [titleHeaderView addSubview:title];
    }
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, KWidth, 300-68) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    [bgImage addSubview:self.table];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"InstallTableViewCell";
    // 2.从缓存池中取出cell
    InstallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"InstallTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
//        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
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
