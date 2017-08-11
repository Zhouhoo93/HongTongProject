//
//  GLLiveContext.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/29.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GLShareContent;

@interface GLLiveContext : NSObject
/**
 *  当前直播状态。1-录制中 0-停录中
 */
@property (nonatomic, assign) NSInteger recordingStatus;

/**
 *  当前直播停止状态。0-异常停止 1-正常停止 2-重连时停止 3-手机来电 4-用户自定义停止状态
 */
@property (nonatomic, assign) NSInteger stopType;

/**
 *  当前播放视频人数
 */
@property (nonatomic, assign) NSInteger playUserCount;


/**
 *  当前视频虚拟人数
 */
@property (nonatomic, assign) NSInteger virPlayUserCount;

@end
