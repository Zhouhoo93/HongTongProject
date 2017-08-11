//
//  GLCoreErrorCode.h
//  GotyeLiveCore
//
//  Created by Nick on 15/10/29.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#ifndef GLCoreErrorCode_h
#define GLCoreErrorCode_h

/**
 失败回调中，error参数的状态码
 */
typedef NS_ENUM(NSInteger, GLCoreErrorCode) {
    /**
     *  验证失败，或者是没有验证成功的情况下调用了别的接口
     */
    GLCoreErrorCodeVerifyFailed = 401,
    /**
     *  JSON解析出错
     */
    GLCoreErrorCodeJSONError = -101,
    /**
     *  网络错误
     */
    GLCoreErrorCodeNetworkDisconnect = -102,
    /**
     *  超时
     */
    GLCoreErrorCodeTimeout = -106,
    /**
     *  未知错误
     */
    GLCoreErrorCodeUnknwon = -999
};

#endif /* GLCoreErrorCode_h */
