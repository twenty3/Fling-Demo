//
//  TokenFormation.h
//  Fling
//
//  Created by 23 on 8/24/14.
//  Copyright (c) 2014 Aged & Distilled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TokenFormation : NSObject

+ (TokenFormation*) formationWithFourFourTwo;
+ (TokenFormation*) formationWithFourOneTwoOne;

- (CGPoint) locationForTokenAtIndex:(NSUInteger)index;

@end
