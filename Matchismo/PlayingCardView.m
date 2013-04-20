//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Viktor Fonic on 31.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end
@implementation PlayingCardView
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

- (CGFloat) faceCardScaleFactor {
    if (!_faceCardScaleFactor) _faceCardScaleFactor = 0.78;
    return _faceCardScaleFactor;
}

-(void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString], self.suit]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        
        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
    }
}

- (void)drawPips {
    if ((self.rank == 1) || (self.rank == 3) || (self.rank == 5) || (self.rank == 9)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:0.165
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0.175
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0.165
                            verticalOffset:0.270
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0.165
                            verticalOffset:0.090
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown {
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * (1.0 - self.faceCardScaleFactor)];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{NSFontAttributeName: pipFont}];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x-pipSize.width/2.0 - hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0 - voffset*self.bounds.size.height);
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)horizontalOffset
                      verticalOffset:(CGFloat)verticalOffset
                  mirroredVertically:(BOOL)mirrored {
    [self drawPipsWithHorizontalOffset:horizontalOffset
                        verticalOffset:verticalOffset
                            upsideDown:NO];
    if (mirrored) {
        [self drawPipsWithHorizontalOffset:horizontalOffset
                            verticalOffset:verticalOffset
                                upsideDown:YES];
    }
}


- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void)drawCorners {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width*0.20];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName : cornerFont}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(2.0, 2.0);
    textBounds.size  = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

- (void)pushContextAndRotateUpsideDown {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}
- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}
- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setup {
    
}
- (void)awakeFromNib {
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
