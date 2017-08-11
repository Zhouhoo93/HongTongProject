//
//  GLPublisherVideoPreset.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/12/26.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, GLPublisherVideoResolution) {
    /**
     *  自定义的预设类型。该类型下可以自由更改视频分辨率，帧率以及比特率
     */
    GLPublisherVideoResolutionCustom,    
    //16:9
    /**
     *  480kbps, 20fps
     */
    GLPublisherVideoResolution480x272,
    /**
     *  640kbps, 20fps
     */
    GLPublisherVideoResolution640x360,
    /**
     *  720kbps, 20fps
     */
    GLPublisherVideoResolution854x480,
    
    //4:3
    /**
     *  480kbps, 20fps
     */
    GLPublisherVideoResolution320x240,
    /**
     *  640kbps, 20fps
     */
    GLPublisherVideoResolution640x480,
    /**
     *  720kbps, 20fps
     */
    GLPublisherVideoResolution768x576,
    /*
     * 640kbps, 20fps
     */
    GLPublisherVideoResolution360x640
};

@interface GLPublisherVideoPreset : NSObject

/**
 *  根据枚举值创建一个视频预设实例
 *
 *  @param resolution 一个GLPublisherVideoResolution类型的枚举值，对应不同的视频分辨率以及比特率
 *
 *  @return 对应的GLPublisherVideoPreset实例
 */
+ (instancetype)presetWithResolution:(GLPublisherVideoResolution)resolution;

/**
 *  视频分辨率
 */
@property (nonatomic, assign) CGSize videoSize;
/**
 *  视频帧率
 */
@property (nonatomic, assign) NSInteger fps;
/**
 *  视频比特率
 */
@property (nonatomic, assign) NSInteger bps;
/**
 *  预设参数的类型。只有在该值为GLPublisherVideoResolutionCustom的情况下，才能对videoSize，fps以及bps属性赋值，其它情况下的赋值都不会有任何效果
 */
@property (nonatomic, assign) GLPublisherVideoResolution resolution;

@end
