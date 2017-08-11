//
//  GLPublisher.h
//  GotyeLiveSDK
//
//  Created by Nick on 15/11/26.
//
//

#import <Foundation/Foundation.h>
#import "GLPublisherDelegate.h"
#import "GLPublisherVideoPreset.h"
#import "GLPublisherErrorCode.h"
#import "GLSmoothSkinFilter.h"

@interface GLPublisher : NSObject

/**
 *  摄像头状态枚举
 */
typedef NS_ENUM(NSInteger, GLCameraState) {
    /**
     *  前置摄像头
     */
    GLCameraStateFront,
    /**
     *  后置摄像头
     */
    GLCameraStateBack
};


/**
 *  发布端状态枚举
 */
typedef NS_ENUM(NSInteger, GLPublisherState) {
    /**
     *  初始化状态
     */
    GLPublisherStateNone,
    /**
     *  调用stop之后的状态
     */
    GLPublisherStateStopped,
    /**
     *  出现错误时的状态
     */
    GLPublisherStateError,
    /**
     *  正在开启预览
     */
    GLPublisherStatePreviewStarting,
    /**
     *  预览成功开启
     */
    GLPublisherStatePreviewStarted,
    /**
     *  正在开始发布
     */
    GLPublisherStatePublishing,
    /**
     *  发布成功
     */
    GLPublisherStatePublished,
    /**
     *  正在重连
     */
    GLPublisherStateReconnecting
};

/**
 *  初始化视频发布模块
 *
 *  @param url rtmp推流url
 */
- (instancetype)initWithUrl:(NSString *)url;

/**
 *  添加视频水印
 *
 *  @param watermark 水印图片
 *  @param rect      水印位置。水印的位置是以视频分辨率为参考坐标系的，也就是说，同样的位置和大小，在不同的视频分辨率上显示效果是不同的
 */
- (void)addWatermark:(UIImage *)watermark withFrame:(CGRect)rect;

/**
 *  清除当前水印。需要在下一次直播中才会生效
 */
- (void)clearWatermark;

/**
 *  开启视频预览，默认开启前置摄像头
 *
 *  @param superViewOfPreview 视频预览的视图
 *  @param success            成功回调
 *  @param failure            失败回调。失败原因一般是由于没有开启摄像头权限
 */
- (void)startPreview:(UIView *)superViewOfPreview success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  用选定的摄像头开启视频预览
 *
 *  @param superViewOfPreview 视频预览的视图
 *  @param cameraState        选定的摄像头
 *  @param success            成功回调
 *  @param failure            失败回调
 */
- (void)startPreview:(UIView *)superViewOfPreview withCameraState:(GLCameraState)cameraState success:(void(^)())success failure:(void(^)(NSError *error))failure;

/**
 *  开始发布视频
 */
- (void)publish;

/**
 *  停止发布视频
 */
- (void)unpublish;

/**
 *  停止发布视频并停止预览
 */
- (void)stop;

/**
 *  切换摄像头
 */
- (void)toggleCamera;

/**
 *  视频发布url
 */
@property (nonatomic, copy) NSString * publishUrl;
/**
 *  视频发布状态回调
 */
@property (nonatomic, weak) id<GLPublisherDelegate> delegate;
/**
 *  摄像头状态，可以通过设置该变量的值来切换前后摄像头
 */
@property (nonatomic, assign) GLCameraState cameraState;
/**
 *  当前发布端的状态
 */
@property (nonatomic, readonly) GLPublisherState state;
/**
 *  闪光灯状态。开启摄像头后，可通过设置该变量的值来尝试打开/关闭闪光灯。
 *  当摄像头为前置摄像头时，打开闪光灯会失败，torchOn的值将不会改变。所以当尝试打开闪光灯时，应该通过torchOn的值来判断是否打开成功
 */
@property (nonatomic, assign) BOOL torchOn;
/**
 *  摄像头的渲染视图，可以通过addView的方式将视图添加到需要渲染的位置
 */
@property (nonatomic, strong, readonly) UIView * previewView;
/**
 *  话筒状态
 */
@property (nonatomic, assign) BOOL mute;
/**
 *  视频直播的预设参数，改变这个值需要在下一次直播才会生效
 */
@property (nonatomic, strong) GLPublisherVideoPreset * videoPreset;
/**
 *  滤镜效果。这个值的改变会实时生效
 */
@property (nonatomic, strong) GLVideoFilter * filter;

/**
 *  推流端连接时间。每次推流成功后都会更新该时间，单位毫秒。
 */
@property (nonatomic, readonly) NSInteger connectionTime;
/**
 *  当前推流的码率。推流成功成功后1秒钟更新一次，单位kbps。
 */
@property (nonatomic, readonly) NSInteger bps;
/**
 *  当前队列中还未发送的buffer数据大小，1秒钟更新一次。单位为byte
 */
@property (nonatomic, readonly) NSInteger bufferSize;

@end
