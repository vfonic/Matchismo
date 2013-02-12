//
//  PlayingCard.m
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    if ([otherCards count] == 1) {
        id otherCard = [otherCards lastObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherPlayingCard = (PlayingCard *)otherCard;
            if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                score = 1;
            } else if (otherPlayingCard.rank == self.rank) {
                score = 4;
            }
        }
    } else {
        // if any of the cards match, we return a score
        for (Card *otherCard in otherCards) {
            score += [self match:@[otherCard]];
        }
    }
    
    return score;
}

@synthesize suit = _suit;
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) _suit = suit;
}
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (NSString *)description {
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits {
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥", @"♦", @"♠", @"♣"];
    return validSuits;
}

+ (NSArray *)rankStrings {
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) _rank = rank;
}
@end
