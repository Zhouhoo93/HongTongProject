

#import <Foundation/Foundation.h>

@class ZqwHorizontalTableView;
@class ZqwTableViewCell;

@protocol ZqwTableViewDataSource <NSObject>

- (NSInteger)numberOfColumnsInZqwTableView:(ZqwHorizontalTableView *)tableView;
- (ZqwTableViewCell *)zqwTableView:(ZqwHorizontalTableView *)tableView cellAtColumn:(NSInteger)column;
- (CGFloat)zqwTableView:(ZqwHorizontalTableView *)tableView cellWidthAtColumn:(NSInteger)column;

@end
