//
//  OpacityDynamicItem.m
//  Fling
//
//  Created by 23 on 8/26/14.
//  Copyright (c) 2014 Aged & Distilled. All rights reserved.
//

#import "OpacityDynamicItem.h"

@interface OpacityDynamicItem ()

@property (readwrite) UIDynamicItemBehavior* dynamicItemBehavior;

@end

@implementation OpacityDynamicItem

- (instancetype) initWithView:(UIView*)view
{
    self = [super init];
    if ( self )
    {
        self.view = view;
        self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
        self.dynamicItemBehavior.resistance = 1.0;
        self.dynamicItemBehavior.density = 10000.0;
    }
    return self;
}

- (CGRect)bounds
{
    return (CGRect){0.0, 0.0, 10.0, 10.0};
}

- (CGPoint)center
{
    return (CGPoint){self.view.alpha, self.view.alpha};
}

- (CGAffineTransform)transform
{
    return CGAffineTransformIdentity;
}

- (void)setCenter:(CGPoint)center
{
    //NSLog(@"New Center: %@", NSStringFromCGPoint(center));
    self.view.alpha = center.x;
}

- (void)setTransform:(CGAffineTransform)transform
{
    
}


@end
