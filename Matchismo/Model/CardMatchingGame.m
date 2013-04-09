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
@property (strong, readwrite, nonatomic) id flipResult;
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
                    self.score += matchScore * self.matchBonus;
                    NSString *flipResultString = [NSString stringWithFormat:@"Matched %@&%@ for %d points", card, [otherCards componentsJoinedByString:@"&"], matchScore * self.matchBonus];
                    NSMutableArray *cardsArray = [otherCards mutableCopy];
                    [cardsArray insertObject:card atIndex:0];
                    self.flipResult = [self composeFlipResultStringFromArray:cardsArray
                                                             andResultString:flipResultString
                                                                     inRange:NSMakeRange([@"Matched " length], 1)];
                } else {
                    for (Card *otherCard in otherCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= self.mismatchPenalty;
                    NSString *flipResultString = [NSString stringWithFormat:@"%@&%@ don't match! %d point penalty!", card, [otherCards componentsJoinedByString:@"&"], self.mismatchPenalty];
                    NSMutableArray *cardsArray = [otherCards mutableCopy];
                    [cardsArray insertObject:card atIndex:0];
                    self.flipResult = [self composeFlipResultStringFromArray:cardsArray
                                                             andResultString:flipResultString
                                                                     inRange:NSMakeRange(0, 1)];
                }
            }
            else { // score didn't change, no match, no mismatch
                NSString *flipResultString = [NSString stringWithFormat:@"Flipped up %@", card];
                self.flipResult = [self composeFlipResultStringFromArray:@[card]
                                                         andResultString:flipResultString
                                                                 inRange:NSMakeRange([@"Flipped up " length], [[card description] length])];
                NSLog(@"Flipped up a card");
            }
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(id)composeFlipResultStringFromArray:(NSArray *)cardArray
                         andResultString:(NSString *)flipResultString
                              inRange:(NSRange)range {
    if ([[cardArray lastObject] respondsToSelector:@selector(attributedDescription)]) {
        NSMutableAttributedString *flipResultAttributedString = [[NSMutableAttributedString alloc] initWithString:flipResultString];
        for (id card in cardArray) {
            range.length = [[card description] length];
            NSAttributedString *attributedDescription = [card performSelector:@selector(attributedDescription)];
            NSDictionary *attributes = [attributedDescription attributesAtIndex:0 effectiveRange:NULL];
            [flipResultAttributedString addAttributes:attributes range:range];
            range.location += range.length + 1;
        }
        return flipResultAttributedString;
    } else {
        return flipResultString;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}
@end
