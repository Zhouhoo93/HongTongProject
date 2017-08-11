//
//  UserListCell.h
//  GotyeLiveApp
//
//  Created by Jim on 16/7/21.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectedButton)(UIButton *button);

@interface UserListCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UIButton * muteBtn;

@property (nonatomic, copy) DidSelectedButton didSelectedButton;

- (void)fillCellWithObject:(id)object level:(NSInteger)level;

@end
