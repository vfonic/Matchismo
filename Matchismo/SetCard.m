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
    if (!validColors) validColors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
    return validColors;
}

+(NSUInteger)maxNumber { return 3; }

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithCapacity:[SetCard maxNumber]];
    for (int i = 0; i < self.number; ++i) {
        [description appendString:self.symbol];
    }
    return description;
}

@end
