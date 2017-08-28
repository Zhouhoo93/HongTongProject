//
//  UseIdLoginController.h
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/8.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UseIdLoginController : UIViewController

@property (nonatomic ,assign) BOOL fromQRScan;
@property (nonatomic,copy)NSString *roomID;
@property (nonatomic,copy)NSString *roomWord;
@property (nonatomic,copy)NSString *nickName;
@end
