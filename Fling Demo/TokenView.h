//
//  TokenView.h
//  Fling

#import <UIKit/UIKit.h>
#import "OpacityDynamicItem.h"

@interface TokenView : UIView

@property (readonly) UIDynamicItemBehavior* dynamicItemBehavior;
@property (strong) OpacityDynamicItem* opacityItem;

- (instancetype)initWithLabel:(NSString*)label;

@end
