//
//  GLPublisherErrorCode.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/12/26.
//
//

#ifndef GLPublisherErrorCode_h
#define GLPublisherErrorCode_h

/**
 *  错误码枚举
 */
typedef NS_ENUM(NSInteger, GLPublisherErrorCode) {
    /**
     *  token无效
     */
    GLPublisherErrorCodeVerifyFailed = 401,
    /**
     *  当前账号已经有人登录了
     */
    GLPublisherErrorCodeOccupied = 1011,
    /**
     *  当前已经有人在直播了
     */
    GLPublisherErrorCodeAlreadyPublished = -101,
    /**
     *  网络断开
     */
    GLPublisherErrorCodeNetworkDisconnect = -102,
    /**
     *  获取当前直播状态出错
     */
    GLPublisherErrorCodeGetPublishStateFailed = -103,
    /**
     *  无法获取摄像头，请检查权限
     */
    GLPublisherErrorCodeNeedAccessForCamera = -104,
    /**
     *  获取直播Url出错
     */
    GLPublisherErrorCodeGetUploadUrlFailed = -105,
    /**
     *  当前状态无效
     */
    GLPublisherErrorCodeIllegalState = -106,
    /**
     *  用户未登录
     */
    GLPublisherErrorCodeNotLogin = -107,
    /**
     *  获取登录url失败
     */
    GLPublisherErrorCodeGetLoginUrlFailed = -108,
    /**
     *  录制时长过短（少于两分钟）
     */
    GLPublisherErrorCodeDurationTooShort = -109,
};

#endif /* GLPublisherErrorCode_h */
