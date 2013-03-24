//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, readwrite, nonatomic) NSString *flipResult;
@property (nonatomic) int gameMode;
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int flipCost;
@end

@implementation CardMatchingGame

// designated initializer
-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck
              withMode:(int)mode
            matchBonus:(int)bonus
       mismatchPenalty:(int)penalty
              flipCost:(int)cost {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; ++i) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
        self.gameMode = mode;
        self.matchBonus = bonus;
        self.mismatchPenalty = penalty;
        self.flipCost = cost;
    }
    
    return self;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck withMode:(int)mode {
    return [self initWithCardCount:count usingDeck:deck withMode:mode matchBonus:2 mismatchPenalty:2 flipCost:1];
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            NSMutableArray *otherCards = [[NSMutableArray alloc]init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherCards addObject:otherCard];
                }
            }
            if ([otherCards count] + 1 == self.gameMode) { // matching exact number of cards depending on game mode
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * self.matchBonus * self.gameMode;
                    self.flipResult = [NSString stringWithFormat:@"Matched %@&%@\nfor %d points", card.description, [otherCards componentsJoinedByString:@"&"], matchScore * self.matchBonus * self.gameMode];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= self.mismatchPenalty;
                    self.flipResult = [NSString stringWithFormat:@"%@&%@ don't match!\n%d point penalty!", card.description, [otherCards componentsJoinedByString:@"&"], self.mismatchPenalty];
                }
            }
            else { // score didn't change, no match, no mismatch
                self.flipResult = [NSString stringWithFormat:@"Flipped up %@", card.description];
                NSLog(@"Flipped up a card");
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
