//
//  GLPeerClient.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/6/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GLVideoRendererView.h"
#import "GLPeerConnectionProtocol.h"

@class GLPeerClient;
@protocol GLPeerClientDelegate <NSObject>

@optional
/**
 *  成功打开本地摄像头的回调
 *
 *  @param client 当前视频通话的客户端
 */
- (void)peerClientDidReceiveLocalVideo:(GLPeerClient *)client;

/**
 *  成功连接视频房间的回调
 *
 *  @param client 当前视频通话的客户端
 *  @param roomId 房间ID
 */
- (void)peerClient:(GLPeerClient *)client didConnectToRoom:(NSString *)roomId;

/**
 *  跟远端用户连接成功的回调
 *
 *  @param client 当前视频通话的客户端
 *  @param userId 远端用户ID
 */
- (void)peerClient:(GLPeerClient *)client didReceiveStreamFrom:(NSString *)userId;

/**
 *  远端用户结束当前视频通话的回调
 *
 *  @param client 当前视频通话的客户端
 *  @param userId 远端用户ID
 */
- (void)peerClient:(GLPeerClient *)client didReceiveHangUpFrom:(NSString *)userId;

/**
 *  发生错误时的回调
 *
 *  @param client 当前视频通话的客户端
 *  @param error  错误详细信息
 */
- (void)peerClient:(GLPeerClient *)client didOccurError:(NSError *)error;

/**
 *  连接中断
 *
 *  @param client 当前视频通话的客户端
 */
- (void)peerClientDisconnected:(GLPeerClient *)client;

@end

@class GLPublisher;

@interface GLPeerClient : NSObject <GLPeerConnectionProtocol>

/**
 *  初始化视频通话客户端。当调用者是主播端时，需要传入当然当前的GLPublisher实例；当调用者是观看端时，传入nil
 *
 *  @param publisher 当前正在直播的GLPublisher实例
 *
 *  @return 一个初始化的GLPeerClient实例
 */
- (instancetype)initWithPublisher:(GLPublisher *)publisher;

/**
 *  连接视频通话房间。
 *
 *  @param roomId 需要连接的房间ID，可以是任意字符串
 *  @param userId 当前连接的用户ID
 */
- (void)connectToRoom:(NSString *)roomId withUserId:(NSString *)userId;

/**
 *  断开与视频通话房间的连接，结束当前视频通话
 */
- (void)disconnect;

/**
 *  视频通话事件的回调
 */
@property (nonatomic, weak) id<GLPeerClientDelegate> delegate;

/**
 *  本地视频的显示view
 */
@property (nonatomic, strong) GLVideoRendererView *localVideoView;

/**
 *  对端视频的显示view
 */
@property (nonatomic, strong) GLVideoRendererView *remoteVideoView;

/**
 *  当前正在通话的对端用户ID。可以提前设置指定与房间中的某个用户进行通话，如果不指定，那么将会会房间里已存在的用户或者第一个进房间的用户进行通话
 */
@property(nonatomic, copy) NSString *remoteUserId;

@end
