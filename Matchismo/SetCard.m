//
//  SetCard.m
//  Matchismo
//
//  Created by Viktor Fonic on 25.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    if ([otherCards count] == 2) {
        id firstCard = otherCards[0];
        id secondCard = otherCards[1];
        if ([firstCard isKindOfClass:[SetCard class]] && [secondCard isKindOfClass:[SetCard class]]) {
            SetCard *firstSetCard = firstCard;
            SetCard *secondSetCard = secondCard;
            if (((self.number == firstSetCard.number && self.number == secondSetCard.number)
                || (self.number != firstSetCard.number && self.number != secondSetCard.number && firstSetCard.number != secondSetCard.number))
                &&
                (([self.symbol isEqualToString:firstSetCard.symbol] && [self.symbol isEqualToString:secondSetCard.symbol])
                 ||(![self.symbol isEqualToString:firstSetCard.symbol] && ![self.symbol isEqualToString:secondSetCard.symbol] && ![firstSetCard.symbol isEqualToString:secondSetCard.symbol]))
                &&
                ((self.shading == firstSetCard.shading && self.shading == secondSetCard.shading)
                 ||(self.shading != firstSetCard.shading && self.shading != secondSetCard.shading && firstSetCard.shading != secondSetCard.shading))
                &&
                (([self.color isEqual:firstSetCard.color] && [self.color isEqual:secondSetCard.color])
                 ||(![self.color isEqual:firstSetCard.color] && ![self.color isEqual:secondSetCard.color] && ![firstSetCard.color isEqual:secondSetCard.color]))) {
                    score = 10;
                }
        }
    }
    return score;
}

+(NSArray *)validSymbols {
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = @[@"▲", @"●", @"■"];
    return validSymbols;
}

+(NSArray *)validColors {
    static NSArray *validColors = nil;
    if (!validColors) validColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
    return validColors;
}

+(NSUInteger)maxNumber { return 3; }

- (NSString *)description {
    return [self.symbol stringByPaddingToLength:self.number withString:self.symbol startingAtIndex:0];
}

@end
