//
//  FilterCommonCollectionViewCell.h
//  ZYSideSlipFilter
//
//  Created by lzy on 16/10/15.
//  Copyright © 2016年 zhiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBaseCollectionViewCell.h"
@protocol SecretGardenPicPopViewDelegate <NSObject>

- (void)buttonClick:(UIButton *)sender;

@end
@interface FilterCommonCollectionViewCell : FilterBaseCollectionViewCell
@property (nonatomic, assign) id<SecretGardenPicPopViewDelegate> delegate;  
@end
