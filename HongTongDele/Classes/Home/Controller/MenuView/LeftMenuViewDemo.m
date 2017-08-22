//
//  LeftMenuViewDemo.m
//  MenuDemo
//
//  Created by Lying on 16/6/12.
//  Copyright © 2016年 Lying. All rights reserved.
//
#define ImageviewWidth    18
#define Frame_Width       self.frame.size.width//200

#import "LeftMenuViewDemo.h"
#import "MenuTableViewCell.h"
@interface LeftMenuViewDemo ()<UITableViewDataSource,UITableViewDelegate,TopButtonDelegate>

@property (nonatomic ,strong)UITableView    *contentTableView;
@property (nonatomic,assign) NSInteger selectTag;
@end

@implementation LeftMenuViewDemo

 
-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{
    self.selectTag = nil;
    //添加头部
    UIView *headerView     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Frame_Width, 44)];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//    CGFloat width          = 90/2;
    
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(12, (90 - width) / 2, width, width)];
////    [imageview setBackgroundColor:[UIColor redColor]];
//    imageview.layer.cornerRadius = imageview.frame.size.width / 2;
//    imageview.layer.masksToBounds = YES;
//    [imageview setImage:[UIImage imageNamed:@"HeadIcon"]];
//    [headerView addSubview:imageview];
//    
//    
//    width                  = 15;
//    UIImageView *arrow     = [[UIImageView alloc]initWithFrame:CGRectMake(Frame_Width - width - 10, (90 - width)/2, width, width)];
//    arrow.contentMode      = UIViewContentModeScaleAspectFit;
//    [arrow setImage:[UIImage imageNamed:@"person-icon0"]];
//    [headerView addSubview:arrow];
    
    UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    [NameLabel setText:@"筛选"];
    NameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:NameLabel];
    
    [self addSubview:headerView];
    
    
    //中间tableview
    UITableView *contentTableView        = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, Frame_Width, self.frame.size.height - headerView.frame.size.height * 2)
                                                                       style:UITableViewStylePlain];
    [contentTableView setBackgroundColor:[UIColor whiteColor]];
    contentTableView.dataSource          = self;
    contentTableView.delegate            = self;
    contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [contentTableView setBackgroundColor:[UIColor whiteColor]];
    contentTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    contentTableView.tableFooterView = [UIView new];
    self.contentTableView = contentTableView;
    [self addSubview:contentTableView];
    
//    //添加尾部
//    width              = 90;
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - headerView.frame.size.height, Frame_Width, self.frame.size.height)];
//    [footerView setBackgroundColor:[UIColor lightGrayColor]];
//    
//    UIImageView *LoginImageview = [[UIImageView alloc]initWithFrame:CGRectMake(8 + 5, (width - ImageviewWidth)/2, ImageviewWidth, ImageviewWidth)];
//    [LoginImageview setImage:[UIImage imageNamed:@"person-icon8"]];
//    [footerView addSubview:LoginImageview];
//    width = 30;
//
//    
//    [self addSubview:footerView];
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectTag-1000) {
        return 25;
    }else {
        return 94 ;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MenuTableViewCell";
    // 2.从缓存池中取出cell
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = 1000+indexPath.row;
        cell.delegate = self;
        //        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    if (indexPath.row == 0) {
        cell.titleTipLabel.text = @"省";
        [cell.FirstBtn setTitle:@"浙江省" forState:0];
        [cell.SecondBtn setTitle:@"湖南省" forState:0];
        [cell.ThiredBtn setTitle:@"江苏省" forState:0];
    }else if (indexPath.row == 1) {
        cell.titleTipLabel.text = @"县(市、区)";
        [cell.FirstBtn setTitle:@"杭州下城" forState:0];
        [cell.SecondBtn setTitle:@"宁波慈溪" forState:0];
        [cell.ThiredBtn setTitle:@"杭州江干" forState:0];
    }else if (indexPath.row == 2) {
        cell.titleTipLabel.text = @"乡镇(街道)";
        [cell.FirstBtn setTitle:@"下沙街道" forState:0];
        [cell.SecondBtn setTitle:@"白杨街道" forState:0];
        [cell.ThiredBtn setTitle:@"没有街道" forState:0];
    }else if (indexPath.row == 3) {
        cell.titleTipLabel.text = @"发电方式";
        [cell.FirstBtn setTitle:@"全额上网" forState:0];
        [cell.SecondBtn setTitle:@"余电上网" forState:0];
//        [cell.ThiredBtn setTitle:@"江苏省" forState:0];
        cell.ThiredBtn.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}

-(void)hideCell:(NSInteger)tag{
//    if (self.selectTag ==tag) {
//        self.selectTag = 0;
//    }else{
//        self.selectTag = tag;
//        [self.contentTableView reloadData];
//    }
}

@end
