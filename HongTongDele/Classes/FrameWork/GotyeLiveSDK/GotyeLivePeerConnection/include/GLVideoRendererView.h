//
//  GLVideoRendererView.h
//  GotyeLiveSDK
//
//  Created by Nick on 16/6/14.
//
//

#import <UIKit/UIKit.h>


@class GLVideoRendererView;

@protocol GLVideoRendererViewDelegate <NSObject>

@optional
/**
 *  视频分辨率发生变化的回调
 *
 *  @param videoView 当前显示视频的view
 *  @param size      当前视频的分辨率大小
 */
- (void)rendererView:(GLVideoRendererView *)videoView didChangeVideoSize:(CGSize)size;

@end

/**
 *  视频的显示模式
 */
typedef NS_ENUM(NSUInteger, GLVideoRendererViewFillMode) {
    /**
     *  保持比例居中。视频会按照比例放大直到撑满屏幕某一边为止。视频不会被截取，但屏幕可能会留空白
     */
    GLVideoRendererViewFillModeAspectFit,
    /**
     *  保持比例撑满。视频会按照比例放大直到撑满屏幕为止。屏幕不留空白，但视频可能被截取。
     */
    GLVideoRendererViewFillModeAspectFill
};

@interface GLVideoRendererView : UIView

/**
 *  视频分辨率回调
 */
@property (nonatomic, weak) id<GLVideoRendererViewDelegate> delegate;
/**
 *  视频填充模式
 */
@property (nonatomic, assign) GLVideoRendererViewFillMode fillMode;

@end
