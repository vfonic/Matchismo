//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
               withMode:(int)mode
             matchBonus:(int)bonus
        mismatchPenalty:(int)penalty
               flipCost:(int)cost;

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
               withMode:(int)mode;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *flipResult;

@end
