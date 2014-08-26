//
//  PitchViewController.m
//  Fling
//

#import "PitchViewController.h"

#import "TokenView.h"

@interface PitchViewController ()

@property (strong, readonly) NSArray* tokenViews;

@property (strong) UIDynamicAnimator* animator;
@property (strong) UIGravityBehavior* gravityBehavior;
@property (strong) UICollisionBehavior* fieldCollisionBehavior;
@property (strong) UICollisionBehavior* tokenCollisionBehavior;

@end

@implementation PitchViewController


#pragma mark - UIViewController Presentation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.fieldCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.tokenViews];
    self.fieldCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.fieldCollisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    
    self.tokenCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.tokenViews];
    self.tokenCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.tokenCollisionBehavior.collisionMode = UICollisionBehaviorModeItems;
    
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.tokenViews];
    self.gravityBehavior.magnitude = 10.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addDynamicTokensToView];
    [self addInitialBehaviors];
    
    // When we first appear, use gravity to drop all the tokens
    // and a collision boundary to contain them at the bottom
    [self addCollectAtBottomBehaviors];
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


#pragma mark - Behaviors

- (void) addInitialBehaviors
{
    // Add each token's item behavior
    for ( TokenView* tokenView in self.tokenViews )
    {
        [self.animator addBehavior:tokenView.dynamicItemBehavior];
    }
    
    [self.animator addBehavior:self.tokenCollisionBehavior];
}

- (void) addCollectAtBottomBehaviors
{
    [self.animator addBehavior:self.gravityBehavior];
    NSLog(@"+ Added Gravity Behavior");
    
    [self.animator addBehavior:self.fieldCollisionBehavior];
    NSLog(@"+ Added Collision Behavior");
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



