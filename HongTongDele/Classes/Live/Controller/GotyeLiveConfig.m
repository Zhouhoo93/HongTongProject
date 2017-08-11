//
//  GotyeLiveConfig.m
//  GotyeLiveApp
//
//  Created by Nick on 16/7/21.
//  Copyright © 2016年 Gotye. All rights reserved.
//

#import "GotyeLiveConfig.h"
#import <objc/runtime.h>

#define DEFAULT_APP_KEY         (@"18796bb08dfd4e1f82e1e7e57a03894d")
#define DEFAULT_ACCESS_KEY      (@"77d7262d8c7e4676a5e7b1b333169d29")

#define INIT_DEFAULT_VALUE      (0)

@implementation GotyeLiveConfig

+ (instancetype)config
{
    static dispatch_once_t onceToken;
    static GotyeLiveConfig *config;
    dispatch_once(&onceToken, ^{
        config = [GotyeLiveConfig new];
    });
    
    return config;
}

+ (NSSet *)keyPathsForValuesAffectingDirty
{
    unsigned int num_props;
    objc_property_t * prop_list;
    prop_list = class_copyPropertyList(self, &num_props);
    
    NSMutableSet * propSet = [NSMutableSet set];
    for( unsigned int i = 0; i < num_props; i++ ){
        NSString * propName = [NSString stringWithFormat:@"%s", property_getName(prop_list[i])];
        [propSet addObject:propName];
    }
    free(prop_list);
    
    return propSet;
}

- (void)dealloc
{
    NSSet *properties = [[self class]keyPathsForValuesAffectingDirty];
    [properties enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeObserver:self forKeyPath:obj];
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSSet *properties = [[self class]keyPathsForValuesAffectingDirty];
        [properties enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            id value = [[NSUserDefaults standardUserDefaults]objectForKey:[self keyForProperty:obj]];
            [self setValue:value forKey:obj];
            [self addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:nil];
        }];

#if (DEBUG || INIT_DEFAULT_VALUE)
        if (self.appkey.length == 0 && self.accessSecret.length == 0) {
            self.appkey = DEFAULT_APP_KEY;
            self.accessSecret = DEFAULT_ACCESS_KEY;
        }
#endif
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id newValue = change[NSKeyValueChangeNewKey];
    if (newValue == [NSNull null]) {
        newValue = nil;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:newValue forKey:[self keyForProperty:keyPath]];
}

- (NSString *)keyForProperty:(NSString *)property
{
    return [@"gotye_" stringByAppendingString:property];
}


+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

@end
