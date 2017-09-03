//
//  LiveCollectionViewCell.h
//  HongTongDele
//
//  Created by Zhouhoo on 2017/8/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerimg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *StatusImage;
@property (weak, nonatomic) IBOutlet UILabel *typelabel;
@property (weak, nonatomic) IBOutlet UILabel *numbeiLabel;

@end
