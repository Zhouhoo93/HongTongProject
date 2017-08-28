//
//  LivePlayerViewController.h
//  LiveLinkAnchor
//
//  Created by Jim on 16/7/8.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLRoomPublisher.h"

@interface LivePlayerViewController : UIViewController

@property (nonatomic, assign) BOOL isLiveMode;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *password;
@property (nonatomic,assign)BOOL isZhuBo;
@property (nonatomic, strong) GLRoomPublisher *publisher;

@end
