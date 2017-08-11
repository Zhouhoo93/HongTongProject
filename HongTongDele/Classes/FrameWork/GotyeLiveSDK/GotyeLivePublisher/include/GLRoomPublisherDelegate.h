//
//  GLRoomPublisherDelegate.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/3/24.
//
//

#import <Foundation/Foundation.h>
#import "GLPublisherDelegate.h"

@class GLRoomPublisher;

@protocol GLRoomPublisherDelegate <GLPublisherDelegate>
@optional
/**
 *  当前账号在别的设备登陆，客户端被强制踢下线
 *
 *  @param publisher 对应的发布端实例
 */
- (void)publisherDidForceLogout:(GLRoomPublisher *)publisher;
@end
