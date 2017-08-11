//
//  GLVideoFilter.h
//  GotyeLiveLite
//
//  Created by Nick on 16/3/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  滤镜
 */
@interface GLVideoFilter : NSObject

/**
 *  强度系数，取值范围为0~1
 */
@property (nonatomic, assign) CGFloat factor;

@end
