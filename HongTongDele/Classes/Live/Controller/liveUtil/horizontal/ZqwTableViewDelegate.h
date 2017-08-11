

#import <Foundation/Foundation.h>

@class ZqwHorizontalTableView;

@protocol ZqwTableViewDelegate <NSObject>

- (void) zqwTableView:(ZqwHorizontalTableView*)tableView didTapAtColumn:(NSInteger)column;


@end
