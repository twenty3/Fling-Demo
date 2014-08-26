//
//  PitchViewController.m
//  Fling
//

#import "PitchViewController.h"

#import "TokenView.h"

@interface PitchViewController ()

@property (strong, readonly) NSArray* tokenViews;

@end

@implementation PitchViewController


#pragma mark - UIViewController Presentation

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addDynamicTokensToView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Tokens

- (NSArray*) tokenViews
{
    static NSArray* gTokenViews = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray* tokenLabels = @[@"1", @"2", @"3", @"4", @"5", @"6̲", @"7", @"8", @"9̲", @"10", @"11"];
        
        NSMutableArray* tokens = [[NSMutableArray alloc] initWithCapacity:tokenLabels.count];
        for ( NSString* label in tokenLabels)
        {
            TokenView* tokenView = [[TokenView alloc] initWithLabel:label];
            [tokens addObject:tokenView];
        }
        
        gTokenViews = [tokens copy];
    });
    
    return gTokenViews;
}

- (void) addDynamicTokensToView
{
    const CGFloat minX = CGRectGetMinX(self.view.bounds) + 50.0;
    const CGFloat maxX = CGRectGetMaxX(self.view.bounds) - 50.0;
    const CGFloat xRange = maxX - minX;
    const CGFloat minY = CGRectGetMinY(self.view.bounds) + 50.0;
    const CGFloat maxY = CGRectGetMidY(self.view.bounds);
    const CGFloat yRange = maxY - minY;
    
    srand([NSDate timeIntervalSinceReferenceDate]);
    
    for ( TokenView* tokenView in self.tokenViews )
    {
        CGFloat x = minX + (xRange * (CGFloat)rand() / (CGFloat)RAND_MAX);
        CGFloat y = minY + (yRange * (CGFloat)rand() / (CGFloat)RAND_MAX);
        
        tokenView.center = (CGPoint){x, y};
        [self.view addSubview:tokenView];
    }
}


#pragma mark - Debug

- (void) logTokenPositions
{
    for ( TokenView* token in self.tokenViews )
    {
        NSLog(@"LOCATION: %@", NSStringFromCGPoint(token.center));
    }
}


@end



