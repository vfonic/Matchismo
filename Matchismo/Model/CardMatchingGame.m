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
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck withMode:(int)mode {
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
    }
    
    return self;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

#define MATCH_BONUS 2
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

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
//                    [otherCards makeObjectsPerformSelector:@selector(setUnplayable:) withObject:@(YES)];
                    for (Card *otherCard in otherCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS * self.gameMode;
                    self.flipResult = [NSString stringWithFormat:@"Matched %@&%@\nfor %d points", card.description, [otherCards componentsJoinedByString:@"&"], matchScore * MATCH_BONUS * self.gameMode];
                } else {
//                    [otherCards makeObjectsPerformSelector:@selector(setFaceUp:) withObject:@(NO)];
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    self.flipResult = [NSString stringWithFormat:@"%@&%@ don't match!\n%d point penalty!", card.description, [otherCards componentsJoinedByString:@"&"], MISMATCH_PENALTY];
                }
            }
            else { // score didn't change, no match, no mismatch
                self.flipResult = [NSString stringWithFormat:@"Flipped up %@", card.description];
                NSLog(@"Flipped up a card");
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
