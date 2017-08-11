

#import "ZqwTableViewCell.h"


@implementation ZqwTableViewCell

#pragma mark -
#pragma mark init

- (instancetype)initWithIdentifiy:(NSString *)identifiy{
    self = [super init];
    self.identifiy = identifiy;
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
// 进行一些基本属性设置
- (void)commonInit
{
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _headerView.layer.masksToBounds = YES;
    _headerView.image = [UIImage imageNamed:@"load"];
    _headerView.layer.cornerRadius = 20;
    [self addSubview:_headerView];
    _userName = [[UILabel alloc] init];
    _userName.frame = CGRectMake(0, 40, 40, 20);
    _userName.font = [UIFont boldSystemFontOfSize:10.f];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.textColor =[UIColor whiteColor];
    _userName.text = @"zhubo";
    _userName.clipsToBounds = YES;
    [self addSubview:_userName];
    
}

- (void) layoutSubviews
{

}


#pragma mark -
#pragma mark reset

- (void) prepareForReused
{
    _index = NSNotFound;
    [self setIsSelected:NO];
}

#pragma mark -
#pragma mark setter

- (void) setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setIsSelected:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setIsSelected:NO];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setIsSelected:NO];
}

@end
