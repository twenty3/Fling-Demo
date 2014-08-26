//
//  TokenView.m
//  Fling

#import "TokenView.h"

const CGFloat TokenViewDiameter = 75.0;

@interface TokenView ()

@property (strong, readwrite) UILabel* textLabel;
@property (strong) UIColor* primaryColor;
@property (strong) UIColor* alternateColor;

@end

@implementation TokenView

#pragma mark - LifeCycle

- (instancetype)initWithLabel:(NSString*)label
{
    CGRect frame = (CGRect){CGPointZero, {TokenViewDiameter, TokenViewDiameter}};
    self = [super initWithFrame:frame];
    if ( self != nil )
    {
        self.primaryColor = [UIColor blackColor];
        self.alternateColor = [UIColor whiteColor];
        
        self.textLabel = [[UILabel alloc] initWithFrame:frame];
        self.textLabel.text = label;
        self.textLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:30.0];
        self.textLabel.textColor = self.alternateColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.textLabel];
                
        self.backgroundColor = self.primaryColor;
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tokenDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapRecognizer];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.textLabel.frame = self.bounds;
}

#pragma mark - Actions

- (void) tokenDoubleTapped:(UITapGestureRecognizer*)tapRecognizer
{
    if ( [self.backgroundColor isEqual:self.primaryColor] )
    {
        self.backgroundColor = self.alternateColor;
        self.textLabel.textColor = self.primaryColor;
    }
    else
    {
        self.backgroundColor = self.primaryColor;
        self.textLabel.textColor = self.alternateColor;
    }
}


@end
