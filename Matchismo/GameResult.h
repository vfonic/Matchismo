//
//  GameResult.h
//  Matchismo
//
//  Created by Viktor Fonic on 06.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (strong, nonatomic) NSString *gameTypeName;
@end
