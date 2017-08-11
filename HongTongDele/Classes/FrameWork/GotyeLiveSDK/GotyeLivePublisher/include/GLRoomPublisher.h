//
//  GLRoomPublisher.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/3/23.
//
//

#import <Foundation/Foundation.h>
#import "GLPublisher.h"
#import "GLRoomPublisherDelegate.h"

@class GLRoomSession;
@class GLUser;

/**
 *  视频发布模块
 */
@interface GLRoomPublisher : GLPublisher

/**
 *  初始化视频发布模块
 *
 *  @param roomSession 聊天室session
 */
- (instancetype)initWithSession:(GLRoomSession *)roomSession;

/**
 *  登录主播账号。需要验证roomSession
 *
 *  @param force   是否强制踢出当前登录账号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)loginWithForce:(BOOL)force success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  退出主播账号登录
 */
- (void)logout;

/**
 *  将当前时间设置为保存直播录像的起点，如果重复调用，那么会忽略上一次的时间点，将起点重置为当前时间。只有在直播过程中调用这个接口才能起作用，这时候接口返回YES。
 *
 *  @return 调用结果。YES表示成功，NO表示失败
 */
- (BOOL)beginRecording;

/**
 *  将当前时间设置为保存直播录像的终点，并向服务器请求保存从起点到终点时间段的视频。如果时长小于两分钟，直接返回失败。如果没有调用过beginRecording，那么直接返回成功
 *
 *  @param completionBlock 操作结果的回调，如果error为nil表示操作成功
 */
- (void)endRecording:(void(^)(NSError *error))completionBlock;

/**
 * 查询在线用户列表
 * @param role 需要查询的角色，2-主播端，3-助理端，4-观看端
 * @param index 列表索引起点，默认0
 * @param total 一次查询多少条数，默认0，最大100
 * @param success 成功回调，返回查询的用户列表
 * @param failure 失败回调
 */
- (void)queryUserListWithRole:(NSInteger)role index:(NSUInteger)index total:(NSUInteger)total onSuccess:(void(^)(NSArray<GLUser *>*))success failure:(void(^)(NSError *error))failure;

/**
 *  设置当前直播状态
 *
 *  @param state   1-录制 0-停录
 *  @param stopType   0-异常停止 1-正常停止 2-重连时停止 3-手机来电 4-用户自定义停止状态
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)setLiveState:(NSInteger)state stopType:(NSInteger)stopType success:(void (^)())success failure:(void (^)(NSError *))failure;
/**
 *  视频发布状态回调
 */
@property (nonatomic, weak) id<GLRoomPublisherDelegate> delegate;
/**
 *  聊天室session
 */
@property (nonatomic, readonly) GLRoomSession * roomSession;

@end

#import "GLRoomPublisher+PeerConnection.h"
