//
//  DragButton.h
//  GotyeLiveApp
//
//  Created by Jim on 16/7/19.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragButton : UIButton

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end
