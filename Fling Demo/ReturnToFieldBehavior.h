//
//  ReturnToFieldBehavior.h
//  Fling
//


#import <UIKit/UIKit.h>

@class TokenView;

@interface ReturnToFieldBehavior : UIDynamicBehavior

- (instancetype) initWithToken:(TokenView*)token snapToPoint:(CGPoint)returnPoint;
    // token will snap to the given point if it leaves the animators reference view bounds

@property (readonly) TokenView* token;

@end
