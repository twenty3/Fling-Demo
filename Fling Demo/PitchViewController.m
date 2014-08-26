//
//  PitchViewController.m
//  Fling
//

#import "PitchViewController.h"

#import "TokenView.h"

@interface PitchViewController () <UIDynamicAnimatorDelegate>

@property (strong, readonly) NSArray* tokenViews;

@property (strong) UIDynamicAnimator* animator;
@property (strong) UIGravityBehavior* gravityBehavior;
@property (strong) UICollisionBehavior* fieldCollisionBehavior;
@property (strong) UICollisionBehavior* tokenCollisionBehavior;

@property (strong, readwrite) UIAttachmentBehavior* dragAttachmentBehavior;
@property (assign) CGPoint dragStartingPoint;

@property (strong) NSMutableArray* transientBehaviors;


@end

@implementation PitchViewController

#pragma mark - UIViewController Presentation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
    
    self.fieldCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.tokenViews];
    self.fieldCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.fieldCollisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    
    self.tokenCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.tokenViews];
    self.tokenCollisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.tokenCollisionBehavior.collisionMode = UICollisionBehaviorModeItems;
    
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.tokenViews];
    self.gravityBehavior.magnitude = 10.0;
    
    self.transientBehaviors = [NSMutableArray new];
    
    // Gesture recognizer so we can reset the tokens
    UITapGestureRecognizer* fieldTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fieldTapped:)];
    fieldTapRecognizer.numberOfTapsRequired = 2;
    fieldTapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:fieldTapRecognizer];
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
            
            UIPanGestureRecognizer* dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tokenDidPan:)];
            [tokenView addGestureRecognizer:dragRecognizer];
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

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    NSLog(@"Animator has paused");
    
    // When the animator comes to a rest, we may need
    // to remove transient behaviors
    
    [self removeTransientBehaviors];
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
    [self.transientBehaviors addObject:self.gravityBehavior];
    NSLog(@"+ Added Gravity Behavior");
    
    [self.animator addBehavior:self.fieldCollisionBehavior];
    [self.transientBehaviors addObject:self.fieldCollisionBehavior];
    NSLog(@"+ Added Collision Behavior");
}

- (void) removeTransientBehaviors
{
    if ( self.transientBehaviors == nil || self.transientBehaviors.count == 0 ) return;
    
    NSLog(@"Removing Transient Behaviors");
    
    for ( UIDynamicBehavior* behavior in self.transientBehaviors )
    {
        [self.animator removeBehavior:behavior];
    }
    
    [self.transientBehaviors removeAllObjects];
}

#pragma mark - Actions

-(void) tokenDidPan:(UIPanGestureRecognizer*)panRecognizer
{
    // We'll only add the attachment for dragging, when a drag starts
    // otherwise the attachment will hold the item in place even
    // when we are not moving it.
    if ( panRecognizer.state == UIGestureRecognizerStateBegan )
    {
        TokenView* viewToDrag = (TokenView*)panRecognizer.view;
        
        // We'll add the attachment at the center of the view
        // and use the delta during each pan gesture update to adjust the attachment location
        // Using the center will keep the view from rotate around the touched point
        self.dragStartingPoint = viewToDrag.center;
        self.dragAttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:viewToDrag attachedToAnchor:viewToDrag.center];
        [self.animator addBehavior:self.dragAttachmentBehavior];
    }
    else if ( panRecognizer.state == UIGestureRecognizerStateEnded )
    {
        self.dragStartingPoint = CGPointZero;
        [self.animator removeBehavior:self.dragAttachmentBehavior];
        self.dragAttachmentBehavior = nil;
    }
    else if ( panRecognizer.state == UIGestureRecognizerStateChanged )
    {
        // apply the change in the pan recognizer position (cumulative) to the
        // the starring part to move our token
        
        // NOTE: if we do the clever trick of reseting the pan recognizer's
        // translation to zero here, it will reset the velocity!
        CGPoint delta = [panRecognizer translationInView:self.view];
        CGPoint newPoint = {self.dragStartingPoint.x + delta.x, self.dragStartingPoint.y + delta.y};
        [self.dragAttachmentBehavior setAnchorPoint:newPoint];
    }
}

- (void) fieldTapped:(UITapGestureRecognizer*)recognizer
{
    // Resest the tokens to the bottom
    [self addCollectAtBottomBehaviors];
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



