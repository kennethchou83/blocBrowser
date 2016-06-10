//
//  AwesomeFloatingToolbar.m
//  BlocBroswer
//
//  Created by Kenneth Chou on 5/29/16.
//  Copyright © 2016 Kenneth Chou. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"


@interface AwesomeFloatingToolbar () <AwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


@end

@implementation AwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles {
    
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    
    self = [super init];
   
    // Save the titles, and set the 4 colors
    
    if (self) {
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        for(NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc] init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorFotThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorFotThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
            
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
            
            //tells the gesture recognizer which method to call when a tap is detected (tapFired:).
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
            
            //tells the view (self) to route touch events through this gesture recognizer.
            [self addGestureRecognizer:self.tapGesture];
            
            self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
            [self addGestureRecognizer:self.panGesture];
            
            //This is for chapter 26 assignment.
            self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
            [self addGestureRecognizer:self.pinchGesture];
            
            self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired)];
            [self addGestureRecognizer:self.longPressGesture];
            
            

        }
    }
        return self;
}

-(void) layoutSubviews {
        // set the frames for the 4 labels
        
        for (UILabel *thisLabel in self.labels) {
            NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
            
            CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
            CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
            CGFloat labelX = 0;
            CGFloat labelY = 0;
            
            // adjust labelX and labelY for each label
            if (currentLabelIndex < 2) {
                // 0 or 1, so on top
                labelY = 0;
            } else {
                // 2 or 3, so on bottom
                labelY = CGRectGetHeight(self.bounds) / 2;
            }
            
            if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
                // 0 or 2, so on the left
                labelX = 0;
            } else {
                // 1 or 3, so on the right
                labelX = CGRectGetWidth(self.bounds) / 2;
            }
            
            thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        }
    }
    
#pragma mark - Touch Handling

- (UILabel *) labelFromTouches: (NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    
    if([subview isKindOfClass:[UILabel class]]) {
        return (UILabel *)subview;
    }else{
        return nil;
    }
}

#pragma mark - Button Enabling

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
        }
    }

- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) { // #3
        CGPoint location = [recognizer locationInView:self]; // #4
        UIView *tappedView = [self hitTest:location withEvent:nil]; // #5
        
        if ([self.labels containsObject:tappedView]) { // #6
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
            }
        }
    }
}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}
//This is for chapter 26 assignment.
-(void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = recognizer.scale;
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchWithScale:scale];
        }
        
    }

}


- (void)longPressFired:(UILongPressGestureRecognizer*)recognizer
{
    
    // rearrange the colors of the four labels
    // take a look at arc4random() function
    
    for (UILabel *label in self.labels) {
        int color = arc4random_uniform(4);
        [label setBackgroundColor:self.colors[color]];
    }
    
    
}

@end

























