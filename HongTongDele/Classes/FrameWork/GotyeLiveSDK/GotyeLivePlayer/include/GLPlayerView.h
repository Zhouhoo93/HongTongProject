//
//  GLPlayerView.h
//  GotyeLiveLite
//
//  Created by Nick on 16/3/12.
//
//

#import <UIKit/UIKit.h>

/**
 *  视频的显示模式
 */
typedef NS_ENUM(NSUInteger, GLPlayerViewFillMode) {
    /**
     *  保持比例居中。视频会按照比例放大直到撑满屏幕某一边为止。视频不会被截取，但屏幕可能会留空白
     */
    GLPlayerViewFillModeAspectFit,
    /**
     *  保持比例撑满。视频会按照比例放大直到撑满屏幕为止。屏幕不留空白，但视频可能被截取。
     */
    GLPlayerViewFillModeAspectFill
};

@interface GLPlayerView : UIView

/**
 *  视频显示模式。默认值为GLPlayerViewFillModeAspectRatio
 */
@property (nonatomic, assign) GLPlayerViewFillMode fillMode;

@end
