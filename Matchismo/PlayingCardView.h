//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Viktor Fonic on 31.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
