

#import <UIKit/UIKit.h>

@interface ZqwTableViewCell : UIView

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, copy) NSString * identifiy;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIImageView* headerView;
@property (nonatomic, strong) UILabel* userName;


- (void) prepareForReused;
- (instancetype)initWithIdentifiy:(NSString *)identifiy;

@end
