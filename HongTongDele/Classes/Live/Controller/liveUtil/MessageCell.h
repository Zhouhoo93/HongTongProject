//
//  MessageCell.h
//  QMZB
//
//  Created by Jim on 16/4/27.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNormalHeight           (30)
#define kMessageFont            [UIFont systemFontOfSize:14.f]
#define MakeRGB(_r, _g, _b)             [UIColor colorWithRed: (_r)/255.0 green: (_g)/255.0 blue: (_b)/255.0 alpha: 1.0]
#define kColorNickname                   MakeRGB(254, 84, 67)

#define fx(frame)                       (frame).origin.x
#define fy(frame)                       (frame).origin.y
#define fw(frame)                       (frame).size.width
#define fh(frame)                       (frame).size.height
#define fr(frame)                       (fx(frame) + fw(frame))
#define fb(frame)                       (fy(frame) + fh(frame))

#define vx(view)                        (view).frame.origin.x
#define vy(view)                        (view).frame.origin.y
#define vw(view)                        (view).frame.size.width
#define vh(view)                        (view).frame.size.height
#define vr(view)                        (vx(view) + vw(view))
#define vb(view)                        (vy(view) + vh(view))
#define vf(view)                        (view).frame

@interface MessageCell : UITableViewCell

//@property (nonatomic, strong) UILabel * nameLabel;//

@property (nonatomic, strong) UILabel * messaheLable;//

- (void)fillCellWithObject:(id)object Width:(CGFloat)width;

@end
