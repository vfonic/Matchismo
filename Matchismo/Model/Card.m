//
//  Card.m
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.description isEqualToString:self.description])
            score = 1;
    }
    
    return score;
}

@end
