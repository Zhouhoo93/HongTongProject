//
//  UserListCell.m
//  GotyeLiveApp
//
//  Created by Jim on 16/7/21.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import "UserListCell.h"
#import "GLUser.h"
#import "MessageCell.h"
#import "GotyeLiveConfig.h"

@interface UserListCell()

@property (nonatomic , strong) id object;

@property (nonatomic, strong) UIImageView * zhubo;

@property (nonatomic, strong) UIImageView * header;

@property (nonatomic, assign) NSInteger  level;

@end

@implementation UserListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 75, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize: 11.f];
        [self addSubview:_nameLabel];
        
        _zhubo = [[UIImageView alloc] initWithFrame:CGRectMake(80, 5, 20, 20)];
        _zhubo.backgroundColor = [UIColor clearColor];
        _zhubo.image = [UIImage imageNamed:@"anchor"];
        _header = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
        _header.backgroundColor = [UIColor clearColor];
        _header.image = [UIImage imageNamed:@"crown"];

        _muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 20, 20)];
        _muteBtn.backgroundColor = [UIColor clearColor];
        _muteBtn.tag = 6;
        [_muteBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [_muteBtn addTarget:self action:@selector(mute:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.object) {
        return;
    }
    GLUser *user = [[GLUser alloc] init];
    user = self.object;
    CGSize titleSize = [GotyeLiveConfig labelAutoCalculateRectWith:user.nickname FontSize:11.f MaxSize:CGSizeMake(MAXFLOAT, 30)];
    NSInteger titleWidth;
    titleWidth = titleSize.width;
    if (titleWidth>55) {
        titleWidth = 55;
    }
    _nameLabel.frame = CGRectMake(10, 0, titleWidth, 30);
    
    [_zhubo removeFromSuperview];
    [_header removeFromSuperview];
    [_muteBtn removeFromSuperview];
    
    if (self.level == 2) {
        [self addSubview:_zhubo];
        [self addSubview:_header];
        _nameLabel.textColor = MakeRGB(255, 156, 158);
        _zhubo.frame = CGRectMake(titleWidth+10, 8, 15, 15);
        _header.frame = CGRectMake(titleWidth+30, 8, 15, 15);
    }else {
        if (self.level == 3) {
            _nameLabel.textColor = MakeRGB(246, 235, 147);
        } else {
            _nameLabel.textColor = [UIColor whiteColor];
        }
        [self addSubview:_muteBtn];
//        _muteBtn.frame = CGRectMake(titleSize.width+20, 5, 20, 20);

    }
    
    _nameLabel.text = user.nickname;
}

- (void)fillCellWithObject:(id)object level:(NSInteger)level
{
    self.object = object;
    self.level = level;
    
    [self setNeedsLayout];
}

- (void)mute:(id)seder
{
    UIButton *button = seder;
    if (self.didSelectedButton != nil) {
        self.didSelectedButton(button);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
