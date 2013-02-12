//
//  Deck.h
//  Matchismo
//
//  Created by Viktor Fonic on 01.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
