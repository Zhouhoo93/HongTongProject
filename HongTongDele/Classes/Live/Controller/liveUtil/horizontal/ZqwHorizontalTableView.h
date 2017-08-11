

#import <UIKit/UIKit.h>
#import "ZqwTableViewDataSource.h"
#import "ZqwTableViewDelegate.h"
@class ZqwTableViewCell;
@interface ZqwHorizontalTableView : UIScrollView

@property (nonatomic, strong, readonly) NSArray* visibleCells;
@property (nonatomic, weak) id<ZqwTableViewDelegate> actionDelegate;
@property (nonatomic, weak) id<ZqwTableViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger selectedIndex;

- (ZqwTableViewCell *)dequeueZqwTalbeViewCellForIdentifiy:(NSString *)identifiy;
- (void)reloadData;

@end
