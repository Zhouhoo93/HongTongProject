//
//  GotyeLivePlayer.h
//  GLPlayer
//
//  Created by Nick on 15/11/11.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GLPlayerDelegate.h"
#import "GLPlayerErrorCode.h"
#import "GLPlayerView.h"

/**
 *  播放器的状态
 */
typedef NS_ENUM(NSInteger, GLPlayerState) {
    /**
     *  初始化时的默认状态
     */
    GLPlayerStateNone,
    /**
     *  调用pause之后的状态
     */
    GLPlayerStatePaused,
    /**
     *  播放器已停止
     */
    GLPlayerStateStopped,
    /**
     *  播放器发生错误
     */
    GLPlayerStateError,
    /**
     *  正在重新尝试播放视频
     */
    GLPlayerStateReConnecting,
    /**
     *  正在第一次尝试播放视频
     */
    GLPlayerStateStarting,
    /**
     *  成功开始播放视频
     */
    GLPlayerStateStarted,
};

@class GLRoomSession;

@interface GLPlayer : NSObject

/**
 *  初始化播放器模块
 *
 *  @param url rtmp拉流url
 */
- (instancetype)initWithUrl:(NSString *)url;

/**
 *  播放视频
 *
 *  @param playView 显示视频的view。视频的渲染视图将会以子view的方式显示在playView上，并且大小跟playView一样
 */
- (void)playWithView:(GLPlayerView *)playerView;

- (void)pause;

- (void)resume;

/**
 *  停止播放视频
 */
- (void)stop;

/**
 *  直播间的session信息，默认为空。如果设置了这个值，当前流的观看统计将会统计到当前直播间
 */
@property (nonatomic, strong) GLRoomSession * roomSession;

/**
 *  视频观看url
 */
@property (nonatomic, copy) NSString * playUrl;
/**
 *  当前视频是否静音。可以通过setter函数改变当前的静音状态
 */
@property (nonatomic, assign) BOOL mute;
/**
 *  视频的渲染视图。如果在调用play接口时，传入的view参数为nil，那么这个属性也为nil。
 *  可以将videoView添加到任意的父view上。默认的背景色为透明色。
 *  只有在播放开始时才会创建这个对象。
 */
@property (nonatomic, strong) GLPlayerView * playerView;
/**
 *  播放器状态的监听对象
 */
@property (nonatomic, weak) id<GLPlayerDelegate> delegate;
/**
 *  当前播放器的状态
 */
@property (nonatomic, readonly) GLPlayerState state;

/**
 *  播放器连接时间。每次连接成功后都会更新该时间，单位毫秒。
 */
@property (nonatomic, readonly) NSInteger connectionTime;
/**
 *  当前视频播放的码率。视频连接成功后1秒钟更新一次，单位kbps。
 */
@property (nonatomic, readonly) NSInteger bps;
/**
 *  当前视频播放的视频缓冲大小。1秒钟更新一次
 */
@property (nonatomic, readonly) NSInteger numOfVideoBuffer;
/**
 *  当前视频播放的音频缓冲大小。1秒钟更新一次
 */
@property (nonatomic, readonly) NSInteger numOfAudioBuffer;
/**
 *  当前视频延时，单位为毫秒，1秒钟更新一次。该延时的计算方法为，视频开始播放时记录一个本地时间，然后根据本地时钟得到的时长减去视频播放的时长，即为该延时。有可能为负值
 */
@property (nonatomic, readonly) NSInteger delay;

@end

