//
//  GLRoomPlayer.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/3/18.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLPlayer.h"
#import "GLRoomPlayerDelegate.h"

/**
 *  视频质量
 */
typedef NS_ENUM(NSInteger, GLVideoQuality) {
    /**
     *  在没开始播放前的默认值
     */
    GLVideoQualityNone,
    /**
     *  原始视频
     */
    GLVideoQualityOriginal,
    /**
     *  高清视频
     */
    GLVideoQualityHigh,
    /**
     *  标清视频
     */
    GLVideoQualityMedium,
    /**
     *  流畅视频
     */
    GLVideoQualityLow
};

@class GLRoomSession;

@interface GLRoomPlayer : GLPlayer
/**
 *  初始化播放器模块
 *
 *  @param roomSession 聊天室session
 */
- (instancetype)initWithRoomSession:(GLRoomSession *)roomSession;

/**
 *  选择某一个清晰度进行播放
 *
 *  @param playerView   视频渲染视图
 *  @param videoQuality 视频清晰度
 */
- (void)playWithView:(GLPlayerView *)playerView quality:(GLVideoQuality)videoQuality;

/**
 *  切换清晰度。如果没有该清晰度，那么会由高到低选择一个最高的清晰度进行播放
 *
 *  @param videoQuality 视频清晰度
 *
 *  @return 如果当前房间没有该清晰度的视频或者希望切换的清晰度与当前清晰度相等，那么返回NO。成功切换返回YES
 */
- (BOOL)switchToQuality:(GLVideoQuality)videoQuality;

/**
 *  切换到下一个播放地址。如果当前播放地址是最后一个，则会重新切换回第一个播放地址。
 *
 *  @return 如果当前播放器是停止状态或者当前房间没有配置多cdn地址，那么返回NO。切换成功返回YES
 */
- (BOOL)switchToNextPlayUrl;

/**
 *  当调用play接口时，有可能直播还未开始，这时候会返回错误。如果没有调用stop接口，当直播开始并且autoPlay的值为YES时，视频会自动开始播放。
 *  默认情况下autoPlay的值为YES。
 */
@property (nonatomic, assign) BOOL autoPlay;
/**
 *  播放器状态的监听对象
 */
@property (nonatomic, weak) id<GLRoomPlayerDelegate> delegate;
/**
 *  当前正在播放的视频清晰度
 */
@property (nonatomic, assign, readonly) GLVideoQuality videoQuality;
/**
 *  当前可用的视频清晰度列表。在播放器连接服务器成功后可获得
 */
@property (nonatomic, strong, readonly) NSArray<NSNumber*> * availableVideoQualities;
/**
 *  当当前地址播放失败时，是否自动切换到下一个cdn播放地址。默认值为YES
 */
@property (nonatomic, assign) BOOL autoSwitchPlayUrl;
/**
 *  连接超时时间。单位为秒，默认值为10。
 */
@property (nonatomic, assign) NSInteger connectTimeout;
@end

#import "GLRoomPlayer+PeerConnection.h"

