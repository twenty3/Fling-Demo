//
//  TokenFormation.m
//  Fling
//
//  Created by 23 on 8/24/14.
//  Copyright (c) 2014 Aged & Distilled. All rights reserved.
//

#import "TokenFormation.h"

@interface TokenFormation()

@property (strong) NSArray* locations;

@end

@implementation TokenFormation

+ (TokenFormation*) formationWithFourFourTwo
{
    NSArray* locations = @[
                             [NSValue valueWithCGPoint:(CGPoint){100.0, 333.0}],
                             [NSValue valueWithCGPoint:(CGPoint){340.0, 566.0}],
                             [NSValue valueWithCGPoint:(CGPoint){340.0, 102.0}],
                             [NSValue valueWithCGPoint:(CGPoint){500.0, 250.0}],
                             [NSValue valueWithCGPoint:(CGPoint){270.0, 250.0}],
                             [NSValue valueWithCGPoint:(CGPoint){270.0, 418.0}],
                             [NSValue valueWithCGPoint:(CGPoint){600.0, 566.0}],
                             [NSValue valueWithCGPoint:(CGPoint){500.0, 418.0}],
                             [NSValue valueWithCGPoint:(CGPoint){780.0, 438.0}],
                             [NSValue valueWithCGPoint:(CGPoint){780.0, 230.0}],
                             [NSValue valueWithCGPoint:(CGPoint){600.0, 102.0}],
                           ];
    return [[TokenFormation alloc] initWithLocations:locations];
}

+ (TokenFormation*) formationWithFourOneTwoOne
{
    NSArray* locations = @[ [NSValue valueWithCGPoint:CGPointZero]];
    return [[TokenFormation alloc] initWithLocations:locations];
}


- (instancetype) initWithLocations:(NSArray*)locaitons
{
    self = [super init];
    if ( self )
    {
        self.locations = locaitons;
    }
    return self;
}

- (CGPoint) locationForTokenAtIndex:(NSUInteger)index
{
    CGPoint returnPoint = CGPointZero;
    
    if ( index < self.locations.count )
    {
        returnPoint = [self.locations[index] CGPointValue];
    }
    
    return returnPoint;
}

@end
