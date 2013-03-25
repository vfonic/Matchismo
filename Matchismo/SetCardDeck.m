//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Viktor Fonic on 25.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init {
    self = [super init];
    
    if (self) {
        for (int i = 1; i <= [SetCard maxNumber]; ++i) {
            for (NSString *symbol in [SetCard validSymbols]) {
                for (UIColor *color in [SetCard validColors]) {
                    for (int shading = 0; shading < ShadingCount; ++shading) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = i;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}
@end
