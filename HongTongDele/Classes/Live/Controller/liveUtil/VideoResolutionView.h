//
//  VideoResolutionView.h
//  GotyeLiveApp
//
//  Created by Jim on 16/8/22.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagDefault                 1
#define kTagHighDefinition          2
#define kTagSuperHighDefinition     3


@interface VideoResolutionView : UIView

@property (strong, nonatomic) IBOutlet UIButton *buttonDefault;
@property (strong, nonatomic) IBOutlet UIButton *buttonHighDefinition;
@property (strong, nonatomic) IBOutlet UIButton *buttonSuperHighDefinition;
@end
