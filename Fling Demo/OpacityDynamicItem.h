//
//  OpacityDynamicItem.h
//  Fling
//
//  Created by 23 on 8/26/14.
//  Copyright (c) 2014 Aged & Distilled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpacityDynamicItem : NSObject<UIDynamicItem>

- (instancetype) initWithView:(UIView*)view;

@property (weak) UIView* view;
@property (readonly) UIDynamicItemBehavior* dynamicItemBehavior;

@end
