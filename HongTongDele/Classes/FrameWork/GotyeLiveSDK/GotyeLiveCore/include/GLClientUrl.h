//
//  GLClientUrl.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/29.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLClientUrl : NSObject


/**
 *  直播观看地址。可用于分享
 */
@property (nonatomic, copy) NSString * educVisitorUrl;
/**
 *  课件观看端页面地址
 */
@property (nonatomic, copy) NSString * modVisitorShareUrl;

@end
