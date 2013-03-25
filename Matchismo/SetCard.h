//
//  SetCard.h
//  Matchismo
//
//  Created by Viktor Fonic on 25.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) int shading;
@property (strong, nonatomic) UIColor *color;

typedef enum {
    OpenShading = 0,
    StripedShading,
    SolidShading,
    ShadingCount
} ValidShading;

+(NSArray *)validSymbols;
+(NSArray *)validColors;
+(NSUInteger)maxNumber;

@end
