//
//  TokenView.h
//  Fling

#import <UIKit/UIKit.h>

@interface TokenView : UIView

@property (readonly) UIDynamicItemBehavior* dynamicItemBehavior;

- (instancetype)initWithLabel:(NSString*)label;

@end
